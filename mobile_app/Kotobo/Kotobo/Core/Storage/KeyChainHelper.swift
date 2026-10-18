//
//  KeyChainHelper.swift
//  Kotobo
//
//  Created by Govine Rajput on 18/10/26.
//

import Foundation
import Security

enum KeyChainHelper {
    
    nonisolated private static let service = "devplaceholder.IJGCAWK5.Kotoba"
    
    nonisolated private static let account = "accessToken"
    
    
    //to save access token
    nonisolated static func save(_ token: String) throws {
        let data = Data(token.utf8)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        let attributes: [String: Any] = [
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        let updateStatus = SecItemUpdate(
            query as CFDictionary,
            attributes as CFDictionary
        )
        
        if updateStatus == errSecItemNotFound {
            var newItem = query
            
            attributes.forEach {
                newItem[$0.key] = $0.value
            }
            
            let status = SecItemAdd(
                newItem as CFDictionary,
                nil
            )
            
            guard status == errSecSuccess else {
                throw NSError(
                    domain: NSOSStatusErrorDomain,
                    code: Int(status)
                )
            }
        } else if updateStatus != errSecSuccess {
            throw NSError(
                domain: NSOSStatusErrorDomain,
                code: Int(updateStatus)
            )
        }
    }
    
    
    //to read access token from storage
    nonisolated static func read() throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: CFTypeRef?
        
        let status = SecItemCopyMatching(
            query as CFDictionary,
            &result
        )

        if status == errSecItemNotFound {
            return nil
        }
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let token = String(
                  data: data,
                  encoding: .utf8
              ) else {
            throw NSError(
                domain: NSOSStatusErrorDomain,
                code: Int(status)
            )
        }

        return token
    }
    
    //to delete the access token
    nonisolated static func delete() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]

        let status = SecItemDelete(
            query as CFDictionary
        )
        
        guard status == errSecSuccess ||
              status == errSecItemNotFound else {
            throw NSError(
                domain: NSOSStatusErrorDomain,
                code: Int(status)
            )
        }
    }
}
