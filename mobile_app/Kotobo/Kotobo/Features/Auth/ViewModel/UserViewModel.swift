//
//  UserViewModel.swift
//  Kotobo
//
//  Created by Govine Rajput on 19/10/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class UserViewModel {
    
    private let service: UserServiceProtocol
    
    var isLoading = false
    var errorMessage: String?
    
    
    init(userService: UserServiceProtocol) {
        self.service = userService
    }
    
    //Signup view model to connect view and service for signup
    func signUp(user: SignUpRequestModel) async throws -> Bool {
        
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        do {
            
            let response = try await service.signUp(user: user)
            
            guard let user = response.data else {
                errorMessage = response.message
                return false
            }
            
            return true
            
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    //login view model to connect view and service for login
    func logIn(user: LoginRequestModel) async throws -> Bool {
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        do {
            
            let response = try await service.logIn(user: user)
            
            guard let user = response.data else {
                errorMessage = response.message
                return false
            }
            
            return true
            
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
}
