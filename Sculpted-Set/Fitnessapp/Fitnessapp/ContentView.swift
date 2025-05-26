//
//  ContentView.swift
//  Fitnessapp
//
//  Created by Miriam on 4/10/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6)
                    .edgesIgnoringSafeArea(.all)

                VStack {
            
                    // App name
                    Text("Sculpted Set")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 50)
                        .frame(maxWidth: .infinity, alignment: .top)
                        .foregroundColor(Color("darkPurple"))
                    
                    Spacer()
                    // Navigate to Sign Up page
                    NavigationLink(destination: SignUpView()) {
                        Text("Get Started")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(height: 60)
                            .frame(maxWidth: .infinity)
                            .background(Color.purple) 
                            .cornerRadius(15)
                            .padding(.horizontal, 30)
                    }

                    // Navigate to Login page
                    NavigationLink(destination: LoginView()) {
                        Text("Login")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.purple)
                            .frame(height: 35)
                            .frame(width: 120)
                            .background(Color.white)
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.purple, lineWidth: 2)
                            )
                    }
                    Spacer()
                }
            }
        }
    }
} // end of ContentView()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
