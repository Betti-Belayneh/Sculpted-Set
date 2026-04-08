//
//  ContentView.swift
//  Fitnessapp
//created by Betti
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var signUpService: SignUpService

    var body: some View {
        NavigationStack {
            ZStack {
                // Dark brown background
                Color(red: 0.18, green: 0.10, blue: 0.05)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Spacer()

                    // Logo / App name
                    VStack(spacing: 8) {
                        Image(systemName: "figure.strengthtraining.traditional")
                            .font(.system(size: 60))
                            .foregroundColor(Color(red: 0.76, green: 0.49, blue: 0.27))

                        Text("Sculpted Set")
                            .font(.system(size: 38, weight: .bold, design: .rounded))
                            .foregroundColor(.white)

                        Text("Your personal fitness companion")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.6))
                    }

                    Spacer()

                    VStack(spacing: 14) {
                        NavigationLink(destination: SignUpView()
                            .environmentObject(signUpService)) {
                                Text("Get Started")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(height: 56)
                                    .frame(maxWidth: .infinity)
                                    .background(Color(red: 0.48, green: 0.25, blue: 0.10))
                                    .cornerRadius(14)
                                    .padding(.horizontal, 30)
                            }

                        NavigationLink(destination: LoginView()
                            .environmentObject(signUpService)) {
                                Text("Log In")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(height: 56)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white.opacity(0.12))
                                    .cornerRadius(14)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(Color.white.opacity(0.4), lineWidth: 1.5)
                                    )
                                    .padding(.horizontal, 30)
                            }
                    }

                    Spacer().frame(height: 50)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SignUpService())
    }
}
