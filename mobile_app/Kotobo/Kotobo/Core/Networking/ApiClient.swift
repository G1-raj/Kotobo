//
//  ApiClient.swift
//  Kotobo
//
//  Created by Govine Rajput on 17/10/26.
//

import Foundation

final class ApiClient {
    
    private let session: URLSession
    private let tokenManager: TokenManager
    private let refreshUrl: URL
    
    init(session: URLSession = .shared, tokenManager: TokenManager, refreshUrl: URL) {
        self.session = session
        self.tokenManager = tokenManager
        self.refreshUrl = refreshUrl
    }
    
    
//    private func refreshAccessToken() async throws -> String {
//        return accessToken
//    }
    
}
