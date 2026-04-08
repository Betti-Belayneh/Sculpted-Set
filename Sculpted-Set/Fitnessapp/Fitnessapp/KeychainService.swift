//
//  KeychainService.swift
//  
//
//  Created by Betti 
//

import Foundation
import Security

final class KeychainService {
    static let shared = KeychainService()
    private init() {}

    func savePassword(_ password: String, for email: String) -> Bool {
        let passwordData = Data(password.utf8)
        let account = email.lowercased()

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecValueData as String: passwordData
        ]

        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    func getPassword(for email: String) -> String? {
        let account = email.lowercased()

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess,
              let data = result as? Data,
              let password = String(data: data, encoding: .utf8) else {
            return nil
        }

        return password
    }

    func deletePassword(for email: String) {
        let account = email.lowercased()

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account
        ]

        SecItemDelete(query as CFDictionary)
    }
}
