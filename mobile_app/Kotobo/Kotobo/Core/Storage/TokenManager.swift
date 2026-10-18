//
//  TokenManager.swift
//  Kotobo
//
//  Created by Govine Rajput on 18/10/26.
//

import Foundation

actor TokenManager {
    private var accessToken: String?
    
    private var refreshTask: Task<String, Error>?
    private var refreshID: UUID?
    
    //get access token
    func getAccessToken() throws -> String? {
        //if access token is already saved in variable we will return the access token
        if let accessToken, !accessToken.isEmpty {
            return accessToken
        }
        
        
        //other wise we will read the access token from storage and then send it
        let storedToken = try KeyChainHelper.read()
        accessToken = storedToken
        return storedToken
    }
    
    //save access token
    func saveAccessToken(_ token: String) throws {
        try KeyChainHelper.save(token)
        accessToken = token
    }
    
    //delete access token from storage
    func clearAccessToken() throws {
        try KeyChainHelper.delete()
        accessToken = nil
        
        refreshTask?.cancel()
        refreshTask = nil
        refreshID = nil
    }
    
    func refresh(
        using refreshClosure: @escaping () async throws -> String
    ) async throws -> String {
        if let task = refreshTask, let id = refreshID {
            return try await awaitRefresh(
                task,
                id: id
            )
        }
        
        let id = UUID()
                
        let task = Task<String, Error> {
            try await refreshClosure()
        }
        
        refreshID = id
        refreshTask = task
        
        return try await awaitRefresh(
            task,
            id: id
        )
    }
    
    func refreshIfNeeded(
        failedToken: String,
        using refreshClosure: @escaping () async throws -> String
    ) async throws -> String {
        if let currentToken = accessToken, currentToken != failedToken {
            return currentToken
        }
        
        return try await refresh(using: refreshClosure)
    }
    
    private func awaitRefresh(_ task: Task<String, Error>, id: UUID) async throws -> String {
        do {
            let newToken = try await task.value
                        
            if refreshID == id {
                accessToken = newToken
                refreshTask = nil
                refreshID = nil
            }
            
            return newToken
        } catch {
            if(refreshID == id) {
                refreshTask = nil
                refreshID = nil
            }
            
            throw error
        }
    }
}
