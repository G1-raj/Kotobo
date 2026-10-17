//
//  CustomButton.swift
//  Kotobo
//
//  Created by Govine Rajput on 17/10/26.
//

import SwiftUI

struct CustomButton: View {
    
    let buttonTitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("\(buttonTitle)")
                .frame(width: 350, height: 55)
                .background(
                    Color(
                        red: 248 / 255,
                        green: 108 / 255,
                        blue: 134 / 255
                    )
                )
                .foregroundStyle(.white)
                .bold()
                .clipShape(
                    RoundedRectangle(cornerRadius: 32)
                )
        }
    }
}

#Preview {
    CustomButton(buttonTitle: "Button") {
        print("Preview")
    }
}
