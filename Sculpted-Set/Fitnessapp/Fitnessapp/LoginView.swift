import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color("darkPurple").opacity(0.8), Color.purple.opacity(0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // App Name
                Text("Sculpted Set")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(.systemGray6))
              
                VStack(spacing: 20) {
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color(.white))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.white))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
               
                NavigationLink(destination: TabsView()) {
                    Text("Login")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(.purple))
                        .foregroundColor(Color(.white))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    LoginView()
}
