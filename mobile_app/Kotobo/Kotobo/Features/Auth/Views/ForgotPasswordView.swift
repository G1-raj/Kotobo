//
//  ForgotPasswordView.swift
//  Kotobo
//
//  Created by Govine Rajput on 18/10/26.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    
    
    @State private var email = ""
    @State private var navigateToVerifyOtp = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Image("onboarding_background")
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .ignoresSafeArea()
                
                
                VStack {
                    
                    Text("Forgot Password?")
                        .font(.system(size: 26, weight: .semibold))
                        .padding(.bottom, 5)
                        .padding(.top, 20)
                    
                    Text("No worries! Enter your email address \nand we'll send you a verification code \nto reset your password")
                        .font(.system(size: 16))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 30)
                    
                    TextFormField(
                        label: "Email",
                        hintText: "Enter your email",
                        fieldType: .email,
                        text: $email,
                    )
                    
                    Spacer()
                    
                    CustomButton(buttonTitle: "Send Otp") {
                        navigateToVerifyOtp = true
                    }
                    .padding(.bottom, 80)
                        
                    
                }
                .frame(maxWidth: .infinity)
                .frame(height: 450)
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
            .navigationDestination(isPresented: $navigateToVerifyOtp) {
                VerifyOtpView()
            }
            
        }
    }
}

#Preview {
    ForgotPasswordView()
}
