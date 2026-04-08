//
//  LoginView.swift
//  Fitnessapp
//created by Betti
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var signUpService: SignUpService
    @Environment(\.dismiss) private var dismiss

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var loginFailed = false
    @State private var navigateToTabs = false

    var body: some View {
        ZStack {
            Color(red: 0.18, green: 0.10, blue: 0.05)
                .ignoresSafeArea()

            VStack(spacing: 28) {
                Spacer()

                // Header
                VStack(spacing: 8) {
                    Image(systemName: "figure.strengthtraining.traditional")
                        .font(.system(size: 44))
                        .foregroundColor(Color(red: 0.76, green: 0.49, blue: 0.27))

                    Text("Welcome Back")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    Text("Log in to continue your journey")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.6))
                }

                // Fields
                VStack(spacing: 14) {
                    TextField("", text: $email, prompt: Text("Email").foregroundColor(.black.opacity(0.4)))
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 24)

                    SecureField("", text: $password, prompt: Text("Password").foregroundColor(.black.opacity(0.4)))
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 24)
                }

                if loginFailed {
                    Text("Invalid email or password.")
                        .foregroundColor(Color(red: 1, green: 0.4, blue: 0.4))
                        .font(.subheadline)
                }

                // Login button
                Button {
                    let success = signUpService.loginUser(emailAddress: email, password: password)
                    if success {
                        navigateToTabs = true
                    } else {
                        loginFailed = true
                    }
                } label: {
                    Text("Log In")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color(red: 0.48, green: 0.25, blue: 0.10))
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        .padding(.horizontal, 24)
                }

                NavigationLink("", destination: TabsView(signUpService: signUpService), isActive: $navigateToTabs)
                    .hidden()

                Spacer()
            }
        }
        .navigationBarBackButtonHidden(false)
    }
}

#Preview {
    LoginView()
        .environmentObject(SignUpService())
}
