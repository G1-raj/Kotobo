//
//  SignUpView.swift
//  Kotobo
//
//  Created by Govine Rajput on 17/10/26.
//

import SwiftUI

struct SignUpView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel: UserViewModel
    
    init(service: UserServiceProtocol) {
        _viewModel = State(
            initialValue: UserViewModel(
                userService: service
            )
        )
    }
    
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            Image("onboarding_background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                Text("Create Your Account")
                    .font(.system(size: 32))
                    .bold()
                
                Text("Start your Japanese learning journey today!")
                    .font(.system(size: 18))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 50)
                    .padding(.bottom, 30)
                
                //input field
                TextFormField(
                    label: "Username",
                    hintText: "Enter username",
                    fieldType: .username,
                    text: $username
                )
                .padding(.bottom, 20)
                
                TextFormField(
                    label: "Email",
                    hintText: "Enter email",
                    fieldType: .email,
                    text: $email
                )
                .padding(.bottom, 20)
                
                TextFormField(
                    label: "Passwrod",
                    hintText: "Enter passwrod",
                    fieldType: .password,
                    text: $password
                )
                .padding(.bottom, 20)
                
                CustomButton(buttonTitle: "Create Account") {
                    Task {
                        await signUp()
                    }
                }
                .padding(.bottom, 20)
                
                Text("By creating an account, you agree to our \n Terms of Service and Privacy Policy.")
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                
                
                
                
            }
            .frame(maxWidth: .infinity)
            .frame(height: 650, alignment: .top)
            .padding(.top, 20)
            .background(
                UnevenRoundedRectangle(
                    topLeadingRadius: 30,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 30
                )
                .fill(.white)
            )
        }
    }
    
    func signUp() async {
        guard !email.isEmpty else {
            viewModel.errorMessage = "Email is required"
            return
        }
        
        guard !username.isEmpty else {
            viewModel.errorMessage = "Username is required"
            return
        }
        
        guard !password.isEmpty else {
            viewModel.errorMessage = "Password is required"
            return
        }
        
        let userData = SignUpRequestModel(
            email: email,
            username: username,
            password: password
        )
        
        let user = await viewModel.signUp(user: userData)
        
        if user {
            dismiss()
        }
    }
}

#Preview {
    
    let tokenManager = TokenManager()

    let apiClient = ApiClient(
        tokenManager: tokenManager,
        refreshUrl: AppConfig.baseUrl
            .appendingPathComponent("auth/refresh")
    )

    let userService = UserService(
        apiClient: apiClient,
        tokenManager: tokenManager
    )
    
    SignUpView(
        service: userService
    )
}
