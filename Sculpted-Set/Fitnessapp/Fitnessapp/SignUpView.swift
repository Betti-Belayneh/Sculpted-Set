//
//  SignUpView.swift
//  Fitnessapp
//
//  Created by Miriam on 4/8/25.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var signService = SignUpService()
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var emailAddress: String = ""
    @State private var password1: String = ""
    @State private var password2: String = ""
    @State private var acceptedTerms: Bool = false
    
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color("darkPurple").opacity(0.8), Color.purple.opacity(0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            
            ScrollView {
                VStack(spacing: 25) {
                   Spacer()
                    VStack(spacing: 8) {
                        Spacer()
                        Text("Create Your Account")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Start growing your glutes today")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.bottom, 20)
                    
                    
                    
                    VStack(spacing: 18) {
                        TextField("First Name", text: $firstName)
                            .padding()
                            .background(Color(.white))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        
                        TextField("Last Name", text: $lastName)
                            .padding()
                            .background(Color(.white))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        
                        TextField("Email Address", text: $emailAddress)
                            .padding()
                            .background(Color(.white))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        
                        SecureField("Password", text: $password1)
                            .padding()
                            .background(Color(.white))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        
                        SecureField("Confirm Password", text: $password2)
                            .padding()
                            .background(Color(.white))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        
                        HStack {
                            Button(action: {
                                    acceptedTerms.toggle()
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.white.opacity(0.7), lineWidth: 1)
                                        .frame(width: 20, height: 20)
                                                
                                    if acceptedTerms {
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color.white)
                                            .frame(width: 20, height: 20)
                                                                
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(Color("darkPurple"))
                                    }
                                }
                            }
                                                    
                                                    Text("I agree to the Terms of Service ")
                                                        .font(.caption)
                                                        .foregroundColor(.white.opacity(0.9))
                                                   
                                                    Spacer()
                                                }
                                                .padding(.top, 5)
                                            }
                    Spacer()
                    
                    Button(action: {
                        if(self.password1 == self.password2){
                            signService.registerUser(emailAddress: emailAddress, password: password1)
                        }
                    }) {
                        NavigationLink(destination: TabsView()) {
                            Text("Create Account")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color(.purple))
                                .foregroundColor(Color(.white))
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.top, 10)
                 
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 30)
            }
        }
    }
}
    
    
#Preview{
    SignUpView()
}
    
    
  
    



