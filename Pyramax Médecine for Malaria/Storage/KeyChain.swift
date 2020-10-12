//
//  KeyChain.swift
//  MedicalApp
//
//  Created by Alex Kholodoff on 16.10.2019.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import Foundation

class KeyсhainService {
        
    func save(_ password: String, for account: String) {
        let password = password.data(using: String.Encoding.utf8)!
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecValueData as String: password]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { return print("save error")
        }
    }
    
    // get pass on acc
    func retrivePassword(for account: String) -> String? {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: kCFBooleanTrue!]
        
        var retrivedData: AnyObject? = nil
        let _ = SecItemCopyMatching(query as CFDictionary, &retrivedData)
        
        guard let data = retrivedData as? Data else {return nil}
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
}

protocol KeyChainService {
    func save(_ email: String, pass: String)
    func getPass(_ email: String) -> String
}

extension KeyChainService {
    
    func save(_ email: String, pass: String) {
        
        let acc = "SanteUser"
        
        let queryDelete: [String: Any] =
            [kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: acc]
        let statusDelete = SecItemDelete(queryDelete as CFDictionary)
        
        // statusDelete = 0 -> Ok
        // statusDelete = - 25 500 -> not found key
        if statusDelete == errSecSuccess || statusDelete == errSecItemNotFound {
            print("statusDelete = ", statusDelete)
        }
        
        let pass = pass.data(using: String.Encoding.utf8)!
        let query: [String: Any] =
            [kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: acc,
            kSecValueData as String: pass]
        
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { return print("save error")
        }
    }
    
    func getPass(_ eMail: String) -> String {
        
        let acc = "SanteUser"
//        let email = String()
        
        let query: [String: Any] =
            [kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: acc,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: kCFBooleanTrue!]
//            kSecAttrLabel as String: email]
        
        var retrivedData: AnyObject? = nil
        let _ = SecItemCopyMatching(query as CFDictionary, &retrivedData)
        
        guard let data = retrivedData as? Data else {return ""}
        
        let pass = String(data: data, encoding: String.Encoding.utf8) ?? ""
        return pass
    }
}
