//
//  VerifyOtpView.swift
//  Kotobo
//
//  Created by Govine Rajput on 18/10/26.
//

import SwiftUI
import Combine

struct VerifyOtpView: View {
    
    @State private var navigateToCreatePassword = false
    
    @State private var otp = ""
    
    @State private var timeRemaining = 60
    @State private var isTimerRunning = true

    
    private let timer = Timer.publish(
        every: 1,
        on: .main,
        in: .common
    ).autoconnect()
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Image("onboarding_background")
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .ignoresSafeArea()
                
                
                VStack(alignment: .trailing) {
                    
                    Image("onboarding_screen_girl_screen_1")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                    
                }
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .padding(.bottom, 450)

                
                VStack {
                    Text("Enter your verification code")
                        .font(.system(size: 26, weight: .semibold))
                        .padding(.bottom, 5)
                        .padding(.top, 20)
                    
                    Text("We've sent a 6-digit code to")
                        .foregroundStyle(.gray)
                    
                    Text("you@example.com")
                        .foregroundColor(Color.black)
                        .bold()
                        .padding(.bottom, 30)
                    
                    OtpField(
                        otp: $otp
                    )
                    .padding(.bottom, 20)
                    
                    
                    HStack {
                        
                        Text("Didn't receive the code?")
                            .foregroundStyle(.gray)
                        
                        if timeRemaining > 0 {
                            Text("Resend in")
                                .foregroundStyle(
                                    Color(
                                        red: 248 / 255,
                                        green: 108 / 255,
                                        blue: 134 / 255
                                    )
                                )
                                .bold()
                            
                            Text("00:\(String(format: "%02d", timeRemaining))")
                                .foregroundStyle(
                                    Color(
                                        red: 248 / 255,
                                        green: 108 / 255,
                                        blue: 134 / 255
                                    )
                                )
                                .bold()
                        } else {
                            Button {
                                print("Resend")
                            } label: {
                                Text("Resend")
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
                    }
                    .frame(maxWidth: .infinity)
                    .onReceive(timer) { _ in
                        guard isTimerRunning, timeRemaining > 0 else {
                            return
                        }
                        
                        timeRemaining -= 1
                        
                        if timeRemaining == 0 {
                            isTimerRunning = false
                        }
                    }

                    
                    Spacer()
                    
                    CustomButton(buttonTitle: "Verify") {
                       navigateToCreatePassword = true
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
            .navigationDestination(isPresented: $navigateToCreatePassword) {
                CreateNewPasswordView()
            }
        }
    }
}

#Preview {
    VerifyOtpView()
}
