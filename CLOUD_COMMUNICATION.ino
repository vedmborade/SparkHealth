#include <Arduino.h>
#include <WiFi.h>
#include <FirebaseESP32.h>
#include <Wire.h>
#include <addons/TokenHelper.h>
#include <addons/RTDBHelper.h>
#include <math.h>

/* WiFi credentials */
#define WIFI_SSID "LSC"
#define WIFI_PASSWORD "96"

/* API Key */
#define API_KEY "AIzaSyBwTq7clLoxeH1mf0pZkdHbsIuQ"

/* RTDB URL */
#define DATABASE_URL "https://healthapp-ec047-default-rtdb.firebaseio.com/"

/* User Email and Password */
#define USER_EMAIL "vedmborade@gmail.com"
#define USER_PASSWORD "666666"

// Define Firebase Data object
FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;

const int LED = 13;
const int GSR = 39;
const int BUZZER = 35;
int sensorValue;

const int MPU_ADDR = 0x68;

int16_t accX, accY, accZ;
float stdDev = 0.0; // New variable to store standard deviation

// Calibration values
int16_t accX_offset = 0, accY_offset = 0, accZ_offset = 0;

void setup() {
  Serial.begin(115200);

  Wire.begin();

  Wire.beginTransmission(MPU_ADDR);
  Wire.write(0x6B);
  Wire.write(0);
  Wire.endTransmission(true);

  // Calibrate the accelerometer
  calibrateAccelerometer();

  // Connect to WiFi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);

  /* Assign the API key (required) */
  config.api_key = API_KEY;

  /* Assign the user sign in credentials */
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback;  // see addons/TokenHelper.h

  Firebase.reconnectNetwork(true);

  fbdo.setBSSLBufferSize(4096, 1024);

  Firebase.begin(&config, &auth);

  Firebase.setDoubleDigits(5);

  pinMode(LED, OUTPUT);
  digitalWrite(LED, LOW);
  delay(1000);
}

void loop() {
  static float prevStdDev = 0.0; // Declare and initialize prevStdDev

  if (Firebase.ready() && (millis() - sendDataPrevMillis > 5000 || sendDataPrevMillis == 0)) {
    sendDataPrevMillis = millis();

    sensorValue = analogRead(GSR);
    float conductivevoltage = sensorValue * (5.0 / 1023.0);
    Serial.print("sensorValue=");
    Serial.println(sensorValue);

    readAccelData();

    // Apply calibration offsets
    accX -= accX_offset;
    accY -= accY_offset;
    accZ -= accZ_offset;

    // Calculate standard deviation
    stdDev = abs(sqrt(sq(accX) + sq(accY) + sq(accZ)) - prevStdDev);
    prevStdDev = sqrt(sq(accX) + sq(accY) + sq(accZ)); // Update prevStdDev for the next iteration

    if (stdDev > 25000) {
      digitalWrite(BUZZER, HIGH);
      delay(5000); // Keep the buzzer on for 500 milliseconds
      digitalWrite(BUZZER, LOW);
    }

    // Write sensor data to the Firebase Real-time Database
    FirebaseJson json;
    json.add("sensorValue", sensorValue);
    json.add("stdDev", stdDev);

    Serial.println("Sending data to Firebase...");

    if (Firebase.setJSON(fbdo, "/sensorData", json)) {
      Serial.println("Data sent successfully");
    } else {
      Serial.println("Failed to send data: " + fbdo.errorReason());
    }

    delay(5000);
  }
}

void readAccelData() {
  Wire.beginTransmission(MPU_ADDR);
  Wire.write(0x3B);
  Wire.endTransmission(false);
  Wire.requestFrom(MPU_ADDR, 6, true);

  accX = Wire.read() << 8 | Wire.read();
  accY = Wire.read() << 8 | Wire.read();
  accZ = Wire.read() << 8 | Wire.read();
}

void calibrateAccelerometer() {
  int16_t accX_sum = 0, accY_sum = 0, accZ_sum = 0;
  uint8_t samples = 100;

  Serial.println("Calibrating accelerometer...");
  delay(1000); // Add a delay to allow the MPU-6050 to stabilize

  for (uint8_t i = 0; i < samples; i++) {
    readAccelData();
    accX_sum += accX;
    accY_sum += accY;
    accZ_sum += accZ;
    delay(10); // Add a small delay between samples
  }

  accX_offset = -accX_sum / samples;
  accY_offset = -accY_sum / samples;
  accZ_offset = (accZ_sum / samples) - 16384; // Account for 1g acceleration

  Serial.print("Accelerometer offsets: ");
  Serial.print("X = "); Serial.print(accX_offset);
  Serial.print(" Y = "); Serial.print(accY_offset);
  Serial.print(" Z = "); Serial.println(accZ_offset);
}
