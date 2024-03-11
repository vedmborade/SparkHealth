import SwiftUI
import MapKit

struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn = false
    @State private var showingAlert = false


    var body: some View {
        Group {
            if isLoggedIn {
                TabView {
                    Patient()
                        .tabItem {
                            Image(systemName: "person.circle")
                            Text("Patient")
                        }

                    Map()
                        .tabItem {
                            Image(systemName: "map")
                            Text("Map")
                        }

                    PredictionView()
                        .tabItem {
                            Image(systemName: "brain.head.profile")
                            Text("Prediction")
                        }

                    CalendarView()
                        .tabItem {
                            Image(systemName: "calendar")
                            Text("Calendar")
                        }
                }
                .navigationBarItems(trailing: Button(action: {
                    isLoggedIn = false
                }) {
                    Image(systemName: "arrow.left.circle.fill")
                        .foregroundColor(.red)
                })
            } else {
                LoginView(username: $username, password: $password, isLoggedIn: $isLoggedIn, showingAlert: $showingAlert)
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Incorrect Password"), message: Text("Please try again"), dismissButton: .default(Text("OK")))
        }
    }
}


struct LoginView: View {
    @Binding var username: String
    @Binding var password: String
    @Binding var isLoggedIn: Bool
    @Binding var showingAlert: Bool
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                if username.lowercased() == "judge" && password.lowercased() == "test" {
                    isLoggedIn = true
                } else {
                    showingAlert = true
                }
            }) {
                Text("Login")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
