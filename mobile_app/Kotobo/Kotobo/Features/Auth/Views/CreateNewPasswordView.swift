//
//  CreateNewPasswordView.swift
//  Kotobo
//
//  Created by Govine Rajput on 18/10/26.
//

import SwiftUI

struct CreateNewPasswordView: View {
    
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
                    print("New password set")
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
}

#Preview {
    CreateNewPasswordView()
}
