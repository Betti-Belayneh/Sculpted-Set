//
//  SignUpView.swift
//  Fitnessapp
//created by Betti
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var signUpService: SignUpService

    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var emailAddress: String = ""
    @State private var password1: String = ""
    @State private var password2: String = ""
    @State private var acceptedTerms: Bool = false
    @State private var errorMessage: String = ""
    @State private var navigateToTabs = false

    var body: some View {
        ZStack {
            Color(red: 0.18, green: 0.10, blue: 0.05)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    Spacer().frame(height: 20)

                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "figure.strengthtraining.traditional")
                            .font(.system(size: 44))
                            .foregroundColor(Color(red: 0.76, green: 0.49, blue: 0.27))

                        Text("Create Your Account")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)

                        Text("Start growing your glutes today")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .padding(.bottom, 8)

                    // Form fields
                    VStack(spacing: 14) {
                        TextField("", text: $firstName, prompt: Text("First Name").foregroundColor(.black.opacity(0.4)))
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .padding(.horizontal, 24)

                        TextField("", text: $lastName, prompt: Text("Last Name").foregroundColor(.black.opacity(0.4)))
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .padding(.horizontal, 24)

                        TextField("", text: $emailAddress, prompt: Text("Email Address").foregroundColor(.black.opacity(0.4)))
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .padding(.horizontal, 24)

                        SecureField("", text: $password1, prompt: Text("Password").foregroundColor(.black.opacity(0.4)))
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .padding(.horizontal, 24)

                        SecureField("", text: $password2, prompt: Text("Confirm Password").foregroundColor(.black.opacity(0.4)))
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .padding(.horizontal, 24)

                        // Terms checkbox
                        HStack(spacing: 12) {
                            Button {
                                acceptedTerms.toggle()
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(acceptedTerms ? Color(red: 0.48, green: 0.25, blue: 0.10) : Color.clear)
                                        .frame(width: 22, height: 22)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 6)
                                                .stroke(Color.white.opacity(0.6), lineWidth: 1.5)
                                        )

                                    if acceptedTerms {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                }
                            }

                            Text("I agree to the Terms of Service")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))

                            Spacer()
                        }
                        .padding(.horizontal, 28)

                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .foregroundColor(Color(red: 1, green: 0.4, blue: 0.4))
                                .font(.subheadline)
                                .padding(.horizontal, 24)
                        }
                    }

                    // Create Account button
                    Button {
                        errorMessage = ""

                        if firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                            lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                            emailAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                            password1.isEmpty || password2.isEmpty {
                            errorMessage = "Please fill in all fields."
                            return
                        }

                        if password1 != password2 {
                            errorMessage = "Passwords do not match."
                            return
                        }

                        if !acceptedTerms {
                            errorMessage = "Please accept the terms."
                            return
                        }

                        let success = signUpService.registerUser(
                            firstName: firstName,
                            lastName: lastName,
                            emailAddress: emailAddress,
                            password: password1
                        )

                        if success {
                            navigateToTabs = true
                        } else {
                            errorMessage = "Could not create account."
                        }
                    } label: {
                        Text("Create Account")
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

                    Spacer().frame(height: 30)
                }
            }
        }
    }
}

#Preview {
    SignUpView()
        .environmentObject(SignUpService())
}
  
    



    



