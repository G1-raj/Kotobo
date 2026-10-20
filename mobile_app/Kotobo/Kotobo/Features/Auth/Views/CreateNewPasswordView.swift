//
//  CreateNewPasswordView.swift
//  Kotobo
//
//  Created by Govine Rajput on 18/10/26.
//

import SwiftUI

struct CreateNewPasswordView: View {
    
    @State private var viewModel: UserViewModel
    
    @Binding var email: String
    
    init(email: Binding<String>, service: UserServiceProtocol) {
        self._email = email
        _viewModel = State(
            initialValue: UserViewModel(
                userService: service
            )
        )
    }
    
    @State private var newPassword = ""
    @State private var confirmNewPassword = ""

    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("onboarding_background")
                .resizable()
                .scaledToFill()
                .clipped()
                .ignoresSafeArea()
            
            VStack {
                Text("Create New Password")
                    .font(.system(size: 26, weight: .semibold))
                    .padding(.bottom, 5)
                    .padding(.top, 20)
                
                Text("Your password must be different")
                    .foregroundStyle(.gray)
                
                Text("from previous one")
                    .foregroundStyle(.gray)
                    .padding(.bottom, 30)
                
                TextFormField(
                    label: "New Password",
                    hintText: "Enter new password",
                    fieldType: .password,
                    text: $newPassword
                )
                .padding(.bottom, 20)
                
                TextFormField(
                    label: "Confirm New Password",
                    hintText: "Confirm new password",
                    fieldType: .password,
                    text: $confirmNewPassword
                )
                
                Spacer()
                
                CustomButton(buttonTitle: "Reset Password") {
                    Task {
                        await changePassword()
                    }
                }
                .padding(.bottom, 60)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 550)
            .background(
                UnevenRoundedRectangle(
                    topLeadingRadius: 30,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 30
                )
                .fill(
                    Color(
                        red: 253 / 255,
                        green: 249 / 255,
                        blue: 243 / 255,
                    )
                )
            )
        }
    }
    
    func changePassword() async {
        guard !newPassword.isEmpty else {
            viewModel.errorMessage = "Password is required"
            return
        }
        
        guard !confirmNewPassword.isEmpty else {
            viewModel.errorMessage = "Confirm password is required"
            return
        }
        
        if newPassword != confirmNewPassword {
            viewModel.errorMessage = "Password does not matched"
            return
        }
        
        let passwordData = ChangePasswordRequestModel(
            email: email,
            password: newPassword
        )
        
        let isSuccess = await viewModel.changePassword(pass: passwordData)
    }
}

#Preview {
    
    @Previewable @State var email = "example@gmail.com"
    
    let tokenManager = TokenManager()
    let refreshUrl = AppConfig.baseUrl.appendingPathComponent("auth/refresh")
    
    let apiClient = ApiClient(
        tokenManager: tokenManager,
        refreshUrl: refreshUrl
    )
    
    let service = UserService(
        apiClient: apiClient,
        tokenManager: tokenManager
    )
    
    CreateNewPasswordView(
        email: $email,
        service: service
    )
}
