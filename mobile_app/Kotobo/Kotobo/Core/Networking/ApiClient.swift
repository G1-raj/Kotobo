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
    
    //get request client
    func get<T: Decodable>(_ type: T.Type, from url: URL, auth: AuthRequirement = .accessToken) async throws -> T {
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        return try await perform(
            request,
            auth: auth
        )
    }
    
    //post with body to upload the data on server
    func post<T: Decodable, Body: Encodable>(_ type: T.Type, to url: URL, body: Body, auth: AuthRequirement = .accessToken) async throws -> T {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        
        request.httpBody = try JSONEncoder().encode(body)
        
        return try await perform(
            request,
            auth: auth
        )
    }
    
    
    //post without body
    func post<T: Decodable>(_ type: T.Type, to url: URL, auth: AuthRequirement = .accessToken) async throws -> T {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        
        return try await perform(
            request,
            auth: auth
        )
    }
    
    
    //put request to update data on server
    func put<T: Decodable, Body: Encodable>(_ type: T.Type, to url: URL, body: Body, auth: AuthRequirement = .accessToken) async throws -> T {
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        
        request.httpBody = try JSONEncoder().encode(body)
        
        return try await perform(
            request,
            auth: auth
        )
    }
    
    
    //delete request
    func delete(from url: URL, auth: AuthRequirement = .accessToken) async throws {
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        _ = try await execute(request, auth: auth)
    }
    
    private func perform<T: Decodable>(_ request: URLRequest, auth: AuthRequirement) async throws -> T {
        
        let (data, _) = try await execute(request, auth: auth)
        
        do {
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            return try decoder.decode(T.self, from: data)
            
        } catch let error as DecodingError {
            throw APIError.decodingError
        }
    }
    
    private func execute(
        _ originalRequest: URLRequest,
        auth: AuthRequirement,
        retryOnUnauthorized: Bool = true
    ) async throws -> (Data, HTTPURLResponse) {
        
        var request = originalRequest
        
        let tokenUsed = try await applyAuthentication(
            to: &request,
            auth: auth
        )
        
        do {
            
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            if httpResponse.statusCode == 401, auth == .accessToken, retryOnUnauthorized {
                let newToken = try await tokenManager.refreshIfNeeded(failedToken: tokenUsed!) {
                    try await self.refreshAccessToken()
                }
                
                var retryRequest = originalRequest
                retryRequest.setValue(
                    "Bearer \(newToken)",
                    forHTTPHeaderField: "Authorization"
                )
                
                return try await execute(retryRequest, auth: .accessToken, retryOnUnauthorized: false)
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                throw APIError.serverError(httpResponse.statusCode)
            }
            
            return (data, httpResponse)
            
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    //if request needs authorization we send it with access token if does not needed then we does not send access token
    private func applyAuthentication(to request: inout URLRequest, auth: AuthRequirement) async throws -> String? {
        switch auth {
        case .none:
            request.setValue(
                nil,
                forHTTPHeaderField: "Authorization"
            )
            
            return nil
            
        case .accessToken:
            guard let token = try await tokenManager.getAccessToken(), !token.isEmpty else {
                throw APIError.invalidResponse
            }
            
            request.setValue(
                "Bearer \(token)",
                forHTTPHeaderField: "Authorization"
            )
            
            return token
        }
    }
    
    
    private func refreshAccessToken() async throws -> String {
        let response: SuccessResponseModel<RefreshTokenResponseModel> = try await post(
            SuccessResponseModel<RefreshTokenResponseModel>.self,
            to: refreshUrl,
            auth: .none
        )
        
        guard let accessToken = response.data?.accessToken else {
            throw APIError.invalidResponse
        }
        
        return accessToken
    }
    
}
