//
//  OtpField.swift
//  Kotobo
//
//  Created by Govine Rajput on 18/10/26.
//

import SwiftUI

struct OtpField: View {
    
    let length: Int
    @Binding var otp: String
    
    @FocusState private var focusedIndex: Int?
    
    init(length: Int = 6, otp: Binding<String>) {
        self.length = length
        self._otp = otp
    }
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<length, id: \.self) { index in
                otpBox(at: index)
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func otpBox(at index: Int) -> some View {
        let digits = Array(otp)
        let digit = index < digits.count ? String(digits[index]) : ""
        
        return ZStack {
            Text(digit)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(.black)
            
            TextField("", text: Binding(
                get: { digit },
                set: { newValue in
                    let numbers = newValue.filter(\.isNumber)
                    
                    if numbers.isEmpty {
                        if index < otp.count {
                            otp = String(otp.prefix(index))
                        }
                        
                        focusedIndex = max(0, index - 1)
                        return
                    }
                    
                    let characters = Array(otp)
                    let enteredDigit = String(numbers.suffix(1))
                    
                    if index < characters.count {
                        var updated = characters
                        updated[index] = Character(enteredDigit)
                        otp = String(updated.prefix(length))
                    } else {
                        otp += enteredDigit
                    }
                    
                    if otp.count >= length {
                        focusedIndex = nil
                    } else {
                        focusedIndex = min(index + 1, length - 1)
                    }
                }
            ))
            .keyboardType(.numberPad)
            .textContentType(.oneTimeCode)
            .focused($focusedIndex, equals: index)
            .opacity(0.2)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 55)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    focusedIndex == index ? Color.blue : Color.gray.opacity(0.5),
                    lineWidth: focusedIndex == index ? 2 : 1
                )
        }
        .contentShape(Rectangle())
        .onTapGesture {
            focusedIndex = min(otp.count, length-1)
        }
    }
}

#Preview {
    @Previewable @State var otp = ""
    OtpField(
        otp: $otp
    )
}
