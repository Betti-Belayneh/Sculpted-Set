//
//  SignUpService.swift
//  Fitnessapp
//
//  Created by Miriam on 4/16/25.
//
import SwiftUI

class SignUpService: ObservableObject {

    // Dictionary stores user's login information [emailAddress : password]
    private var appUsers: [String: String] = [:]

    func registerUser(emailAddress: String, password: String) {

        appUsers[emailAddress] = password

    }

}  // end of SignUpService class
