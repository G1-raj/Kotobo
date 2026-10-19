//
//  LoginView.swift
//  Kotobo
//
//  Created by Govine Rajput on 17/10/26.
//

import SwiftUI

struct LoginView: View {
    
    @Environment(AppContainer.self) private var container
    @State private var viewModel: UserViewModel
    
    init(service: UserServiceProtocol) {
        _viewModel = State(
            initialValue: UserViewModel(
                userService: service
            )
        )
    }
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Image("shrine")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 200)
                    .padding(.bottom, 20)
                
                Text("ことぼ")
                    .font(.largeTitle)
                    .bold()
                
                Text("KOTOBA")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.bottom, 30)
                
                VStack {
                    
                    TextFormField(
                        label: "Email",
                        hintText: "Enter your email",
                        fieldType: .email,
                        text: $email
                    )
                    
                    TextFormField(
                        label: "",
                        hintText: "Enter your password",
                        fieldType: .password,
                        text: $password
                    )
                    .padding(.bottom, 20)
                    
                    CustomButton(buttonTitle: "Login") {
                        Task {
                            await login()
                        }
                    }
                    .padding(.bottom, 10)
                    
                    NavigationLink {
                        ForgotPasswordView(
                            service: container.userService
                        )
                    } label: {
                        Text("Forgot Password?")
                            .foregroundStyle(.black)
                    }
                    .padding(.bottom, 20)
                }
                .frame(maxWidth: .infinity)
                .background(.white)
                
                Spacer()
                
                HStack {
                    Text("Don't have an account?")
                        .fontWeight(.semibold)
                    
                    NavigationLink {
                        SignUpView(
                            service: container.userService
                        )
                    } label: {
                        Text("Signup")
                            .foregroundStyle(
                                Color(
                                    red: 248 / 255,
                                    green: 108 / 255,
                                    blue: 134 / 255
                                )
                            )
                            .bold()
                    }
                }
                .padding(.bottom, 20)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color(
                    red: 253 / 255,
                    green: 249 / 255,
                    blue: 243 / 255,
                )
            )
        }
    }
    
    func login() async {
        guard !email.isEmpty else {
            viewModel.errorMessage = "Email is required"
            return
        }
        
        guard !password.isEmpty else {
            viewModel.errorMessage = "Password is required"
            return
        }
        
        let userData = LoginRequestModel(
            email: email,
            password: password
        )
        
        let isSuccess = await viewModel.logIn(user: userData)
        
        if isSuccess {
            container.loginSuccessful()
        }
    }
}

#Preview {
    
    let tokenManager = TokenManager()
    let refreshUrl = AppConfig.baseUrl.appendingPathComponent("auth/refresh")
    
    let apiClinet = ApiClient(
        tokenManager: tokenManager,
        refreshUrl: refreshUrl
    )
    
    let service = UserService(
        apiClient: apiClinet,
        tokenManager: tokenManager
    )
    
    LoginView(
        service: service
    )
}
