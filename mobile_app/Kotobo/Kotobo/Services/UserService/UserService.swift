//
//  UserService.swift
//  Kotobo
//
//  Created by Govine Rajput on 19/10/26.
//

import Foundation

protocol UserServiceProtocol {
    
    func signUp(user: SignUpRequestModel) async throws -> SuccessResponseModel<SignUpResponseModel>
    func logIn(user: LoginRequestModel) async throws -> SuccessResponseModel<LoginResponseModel>
    func sendOtp(user: SendOtpRequestModel) async throws -> SuccessResponseModel<EmptyResponseModel>
    func verifyOtp(otp: VerifyOtpRequestModel) async throws -> SuccessResponseModel<EmptyResponseModel>
    func changePassword(passCredentials: ChangePasswordRequestModel) async throws -> SuccessResponseModel<ChangePasswordResponseModel>
    func logOut() async throws -> SuccessResponseModel<EmptyResponseModel>
    
}

final class UserService: UserServiceProtocol {
    
    private let apiClient: ApiClient
    private let tokenManager: TokenManager
    private let baseUrl: URL
    
    init(apiClient: ApiClient, tokenManager: TokenManager, baseUrl: URL = AppConfig.baseUrl) {
        self.apiClient = apiClient
        self.tokenManager = tokenManager
        self.baseUrl = baseUrl
    }
    
    //signup service
    func signUp(user: SignUpRequestModel) async throws -> SuccessResponseModel<SignUpResponseModel> {
        var url = baseUrl.appendingPathComponent("auth/signup")
        
        return try await apiClient.post(
            SuccessResponseModel<SignUpResponseModel>.self,
            to: url,
            body: user,
            auth: .none
        )
    }
    
    //login service
    func logIn(user: LoginRequestModel) async throws -> SuccessResponseModel<LoginResponseModel> {
        var url = baseUrl.appendingPathComponent("auth/login")
        
        return try await apiClient.post(
            SuccessResponseModel<LoginResponseModel>.self,
            to: url,
            body: user,
            auth: .none
        )
    }
    
    //forgot password services
    //send otp service
    func sendOtp(user: SendOtpRequestModel) async throws -> SuccessResponseModel<EmptyResponseModel> {
        let url = baseUrl.appendingPathComponent("auth/fogot-password/sendOtp")
        
        return try await apiClient.post(
            SuccessResponseModel<EmptyResponseModel>.self,
            to: url,
            body: user,
            auth: .none
        )
    }
    
    //verify otp service
    func verifyOtp(otp: VerifyOtpRequestModel) async throws -> SuccessResponseModel<EmptyResponseModel> {
        let url = baseUrl.appendingPathComponent("auth/forgot-password/verifyOtp")
        
        return try await apiClient.post(
            SuccessResponseModel<EmptyResponseModel>.self,
            to: url,
            body: otp,
            auth: .none
        )
    }
    
    //change password service
    func changePassword(passCredentials: ChangePasswordRequestModel) async throws -> SuccessResponseModel<ChangePasswordResponseModel> {
        let url = baseUrl.appendingPathComponent("auth/forgot-password/resetPassword")
        
        return try await apiClient.put(
            SuccessResponseModel<ChangePasswordResponseModel>.self,
            to: url,
            body: passCredentials,
            auth: .none
        )
    }
    
    func logOut() async throws -> SuccessResponseModel<EmptyResponseModel> {
        let url = baseUrl.appendingPathComponent("auth/logout")
        
        return try await apiClient.post(
            SuccessResponseModel<EmptyResponseModel>.self,
            to: url,
            auth: .none
        )
    }
}
