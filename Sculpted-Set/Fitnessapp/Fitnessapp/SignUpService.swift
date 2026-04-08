//
//  SignUpService.swift
//  Fitnessapp
//
//  Created by Betti 
//
import Foundation

struct AppUser: Codable {
    let firstName: String
    let lastName: String
    let email: String
}


final class SignUpService: ObservableObject {
    private let currentUserKey = "currentUser"
    private let currentUserEmailKey = "currentUserEmail"
    private let isLoggedInKey = "isLoggedIn"
    @Published var isUserLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
    func registerUser(firstName: String,
                      lastName: String,
                      emailAddress: String,
                      password: String) -> Bool {
        let trimmedEmail = emailAddress.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        guard !firstName.isEmpty,
              !lastName.isEmpty,
              !trimmedEmail.isEmpty,
              !password.isEmpty else {
            return false
        }

        let user = AppUser(
            firstName: firstName.trimmingCharacters(in: .whitespacesAndNewlines),
            lastName: lastName.trimmingCharacters(in: .whitespacesAndNewlines),
            email: trimmedEmail
        )

        guard let encodedUser = try? JSONEncoder().encode(user) else {
            return false
        }

        let savedToKeychain = KeychainService.shared.savePassword(password, for: trimmedEmail)
        guard savedToKeychain else { return false }

        UserDefaults.standard.set(encodedUser, forKey: userKey(for: trimmedEmail))
        UserDefaults.standard.set(trimmedEmail, forKey: currentUserEmailKey)
        UserDefaults.standard.set(true, forKey: isLoggedInKey)

        return true
    }

    func loginUser(emailAddress: String, password: String) -> Bool {
        let trimmedEmail = emailAddress.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        guard let savedPassword = KeychainService.shared.getPassword(for: trimmedEmail),
              savedPassword == password else {
            return false
        }

        UserDefaults.standard.set(trimmedEmail, forKey: currentUserEmailKey)
        UserDefaults.standard.set(true, forKey: isLoggedInKey)
        return true
    }

    func logoutUser() {
        UserDefaults.standard.set(false, forKey: isLoggedInKey)
        UserDefaults.standard.removeObject(forKey: currentUserEmailKey)
        isUserLoggedIn = false
    }

    func isLoggedIn() -> Bool {

        UserDefaults.standard.bool(forKey: isLoggedInKey)
    }

    func getCurrentUser() -> AppUser? {
        guard let email = UserDefaults.standard.string(forKey: currentUserEmailKey),
              let data = UserDefaults.standard.data(forKey: userKey(for: email)),
              let user = try? JSONDecoder().decode(AppUser.self, from: data) else {
            return nil
        }

        return user
    }

    private func userKey(for email: String) -> String {
        "user_\(email)"
    }
}  // end of SignUpService class
