//
//  AppContainer.swift
//  Kotobo
//
//  Created by Govine Rajput on 19/10/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class AppContainer {
    
    let tokenManager: TokenManager
    let apiClient: ApiClient
    let userService: UserService
    
    var authState: AuthState = .checking
    
    init() {
        
        let tokenManager = TokenManager()
        let refreshUrl = AppConfig.baseUrl.appendingPathComponent("auth/refresh")
        
        let apiClient = ApiClient(tokenManager: tokenManager, refreshUrl: refreshUrl)
        let userService = UserService(apiClient: apiClient, tokenManager: tokenManager)
        
        self.tokenManager = tokenManager
        self.apiClient = apiClient
        self.userService = userService
    }
    
    func checkAuthentication() async {
        do {
            
            let token = try await tokenManager.getAccessToken()
            
            if let token, !token.isEmpty {
                authState = .authenticated
            } else {
                authState = .unauthenticated
            }
            
        } catch {
            authState = .unauthenticated
        }
    }
    
    func loginSuccessful() {
        authState = .authenticated
    }
    
    func logOut() async throws {
        try await tokenManager.clearAccessToken()
        authState = .unauthenticated
    }
}
