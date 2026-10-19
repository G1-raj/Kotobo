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
    func signUp(user: SignUpRequestModel) async -> Bool {
        
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
    func logIn(user: LoginRequestModel) async -> Bool {
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
    
    //forgot password
    
    //forgot password view model to connect view and sevice to send otp to reset password
    func sendOtp(user: SendOtpRequestModel) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        do {
            
            let response = try await service.sendOtp(user: user)
            
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
    
    //view model to connect service and verify otp view
    func verifyOtp(otp: VerifyOtpRequestModel) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        do {
            
            let response = try await service.verifyOtp(otp: otp)
            
            guard let otp = response.data else {
                errorMessage = response.message
                return false
            }
            
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    //view model to connect servicy and change password view
    func changePassword(pass: ChangePasswordRequestModel) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        do {
            
            let response = try await service.changePassword(passCredentials: pass)
            
            guard let pass = response.data else {
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
