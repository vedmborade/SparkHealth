The Problem:
Epilepsy impacts millions worldwide, with inadequate solutions for predicting and managing seizures. Patients face risks of injury during seizures, which reduces the quality of their life.

The Solution:
SparkHealth is a novel mobile app that continuously monitors signals through wearable sensors to detect impending seizures. It is connected to the cloud via a Firebase NOSQL database.

How It Works:
Wearable sensors track the user's electric conductance (GSR Sensor) and body movements (MPU Sensors)
Data is streamed to the app for analysis by machine learning models
Models identify user's unique pre-seizure biomarker patterns and high seizure probability triggers an alert to caregivers
AI Chatbot provides real-time first-aid instructions through the app
Schedule doctor appointments and access private cloud-secured health information
Smart wearable deploys airbags to protect user when a fall is detected

Key Technologies:
Sensors + Microcontrollers:
MPU Sensor: Measures orientation + acceleration with accelerometers, gyroscopes.
GSR Sesnor: GSR sensor detects body’s electrical conductance levels.
ESP32:  Wifi Module used to transmit sensor data to the Firebase NOSQL Realtime Database; Internet of Things (IOT)
Circuitry: 
I2C (A bidirectional communication interface used between sensors) and UART (A serial communication interface used between computers and microcontrollers) (Hardware demonstrated)
ChipYard Software: RISC-V ASIC (Application-Specific integrated circuit) to make custom MicroController Chip (Need access to a Fabrication Lab to transcribe circuit onto a Silicon Semi-Conductor Chip)
Programming
C++ programming language to program ESP32 to connect to the Firebase NOSQL Realtime Database Application Programming Interface (API)
SwiftIUI programming Language to develop IOS + WatchOS apps.
Python to program Machine Learning Algorithm to predict Seizures using GetML API

