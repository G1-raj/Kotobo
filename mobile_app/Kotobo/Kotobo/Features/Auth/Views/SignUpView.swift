//
//  SignUpView.swift
//  Kotobo
//
//  Created by Govine Rajput on 17/10/26.
//

import SwiftUI

struct SignUpView: View {
    
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
                    print("Signup")
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
}

#Preview {
    SignUpView()
}
