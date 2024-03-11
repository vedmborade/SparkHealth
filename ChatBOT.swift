import SwiftUI
import Combine

struct PredictionView: View {
    @State private var userInput: String = ""
    @State private var chatHistory: [String] = []

    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(chatHistory, id: \.self) { message in
                        Text(message)
                            .padding(8)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
            }

            HStack {
                TextField("Type your message...", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: sendMessage) {
                    Text("Send")
                }
            }
            .padding()
        }
        .padding()
    }

    func sendMessage() {
        guard !userInput.isEmpty else { return }

        // Add user's message to chat history
        chatHistory.append("User: \(userInput)")

        // Call OpenAI API to get response
        getOpenAIResponse { response in
            DispatchQueue.main.async {
                // Add response to chat history
                chatHistory.append("ChatGPT: \(response)")

                // Clear user input
                userInput = ""
            }
        }
    }

    func getOpenAIResponse(completion: @escaping (String) -> Void) {
        // Replace with your actual API call to OpenAI's ChatGPT API
        let apiKey = "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"
        let prompt = userInput

        // Perform API call and handle response
        let response = "If you suspect that you or someone else is experiencing a stroke, it's crucial to seek emergency medical attention immediately. Time is of the essence when dealing with a stroke, as prompt medical intervention can significantly improve the chances of a positive outcome.Call for help right away and provide information about the situation."
        completion(response)
    }
}

struct PredictionView_Previews: PreviewProvider {
    static var previews: some View {
        PredictionView()
    }
}
