import SwiftUI
import FirebaseDatabase
import FirebaseDatabaseSwift

struct Patient: View {
    @State private var sensorValue: Int?
    @State private var deltaAcceleration: Double?
    @State private var showPatientInfo = false
    @State private var showFallAlert = false

    var body: some View {
        ZStack {
            Color(red: 0.4, green: 0.8, blue: 1)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Button(action: {
                    showPatientInfo = true
                }) {
                    ProfilePictureView()
                }

                SensorDataView(sensorValue: sensorValue, deltaAcceleration: deltaAcceleration, showFallAlert: $showFallAlert)
                    .padding()
                    .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                    .cornerRadius(20)
                    .shadow(radius: 5)
            }
            .padding()
            .sheet(isPresented: $showPatientInfo) {
                PatientInfoView()
            }
            .alert(isPresented: $showFallAlert) {
                Alert(
                    title: Text("Potential Fall Detected"),
                    message: Text("Airbags deployed\n\nContacting emergency contacts"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .onAppear {
            fetchSensorData()
        }
    }

    private func fetchSensorData() {
        let ref = Database.database().reference()

        ref.child("sensorData/sensorValue").observe(.value, with: { snapshot in
            if let value = snapshot.value as? Int {
                sensorValue = value
            }
        })

        ref.child("sensorData/stdDev").observe(.value, with: { snapshot in
            if let delta = snapshot.value as? Double {
                deltaAcceleration = delta
            }
        })
    }
}

struct ProfilePictureView: View {
    var body: some View {
        Image(systemName: "person.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 120, height: 120)
            .foregroundColor(Color(red: 0.3, green: 0.6, blue: 1))
            .padding()
            .background(Color(red: 0.2, green: 0.5, blue: 0.8))
            .cornerRadius(80)
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 4)
            )
    }
}

struct SensorDataView: View {
    let sensorValue: Int?
    let deltaAcceleration: Double?
    @Binding var showFallAlert: Bool
    @State private var fallLog: [(location: String, timestamp: Date)] = []

    var body: some View {
        VStack(spacing: 20) {
            Text("Sensor Data")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))

            if let value = sensorValue, let delta = deltaAcceleration {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Sensor Value")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        Text("\(value)")
                            .font(.subheadline)
                            .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                    }

                    Spacer()

                    VStack(alignment: .trailing) {
                        Text("∆Acceleration")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        Text("\(delta, specifier: "%.2f")")
                            .font(.subheadline)
                            .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                    }
                }
                .onChange(of: delta) { newValue, _ in
                    if abs(newValue) > 300 {
                        showFallAlert = true
                        fallLog.append((location: "Living Room", timestamp: Date()))
                    }
                }
            } else {
                Text("Loading...")
                    .font(.subheadline)
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("Fall/Seizure Log")
                    .font(.headline)
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))

                ForEach(fallLog, id: \.timestamp) { log in
                    HStack {
                        Text(log.location)
                            .font(.subheadline)
                        Spacer()
                        Text(log.timestamp, style: .time)
                            .font(.subheadline)
                    }
                }
            }
            .padding()
            .background(Color(red: 0.9, green: 0.9, blue: 0.9))
            .cornerRadius(20)
            .shadow(radius: 5)
        }
        .padding()
    }
}

struct PatientInfoView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Patient Information")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))

            VStack(alignment: .leading, spacing: 10) {
                Text("Name: John Doe")
                    .font(.headline)
                Text("Address: 123 Main Street, Anytown USA")
                    .font(.subheadline)
                Text("Weight: 75 kg")
                    .font(.subheadline)
                Text("Emergency Contacts:")
                    .font(.headline)
                Text("Jane Doe (Wife) - 555-1234")
                    .font(.subheadline)
                Text("Dr. Smith (Physician) - 555-5678")
                    .font(.subheadline)
            }
            .padding()
            .background(Color(red: 0.9, green: 0.9, blue: 0.9))
            .cornerRadius(20)
            .shadow(radius: 5)

            VStack(alignment: .leading, spacing: 10) {
                Text("Medications:")
                    .font(.headline)
                Text("- Aspirin (81mg) - Once daily")
                    .font(.subheadline)
                Text("- Lisinopril (10mg) - Once daily")
                    .font(.subheadline)
                Text("Upcoming Appointments:")
                    .font(.headline)
                Text("- Physical Exam - June 15, 2023")
                    .font(.subheadline)
                Text("- Cardiology Follow-up - July 1, 2023")
                    .font(.subheadline)
            }
            .padding()
            .background(Color(red: 0.9, green: 0.9, blue: 0.9))
            .cornerRadius(20)
            .shadow(radius: 5)

            Spacer()
        }
        .padding()
        .background(Color(red: 0.95, green: 0.95, blue: 0.95))
    }
}
