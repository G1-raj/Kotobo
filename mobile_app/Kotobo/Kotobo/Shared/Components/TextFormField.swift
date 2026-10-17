//
//  TextFormField.swift
//  Kotobo
//
//  Created by Govine Rajput on 17/10/26.
//

import SwiftUI

struct TextFormField: View {
    
    let label: String
    let hintText: String
    var fieldType: FieldType = .text
    
    @Binding var text: String
    @State private var isPasswordVisible = false
    
    
    enum FieldType {
        case email
        case username
        case password
        case text
        
        var icon: String {
            switch self {
            case .email:
                return "envelope"
            case .username:
                return "person"
            case .password:
                return "lock"
            case .text:
                return "textformat"
            }
        }
    }
    
    
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .fontWeight(.bold)
                .padding(.leading, 20)
            
            HStack(spacing: 10) {
                Image(systemName: fieldType.icon)
                    .foregroundStyle(.gray)
                
                
                Group {
                    if fieldType == .password && !isPasswordVisible {
                        SecureField(hintText, text: $text)
                    } else {
                        TextField(hintText, text: $text)
                            .textInputAutocapitalization(
                                fieldType == .email ? .never : .sentences
                            )
                            .autocorrectionDisabled(
                                fieldType == .email || fieldType == .username
                            )
                            .keyboardType(
                                fieldType == .email ? .emailAddress : .default
                            )
                    }
                }
                
                if fieldType == .password {
                    Button {
                        isPasswordVisible.toggle()
                    } label: {
                        Image(
                            systemName: isPasswordVisible
                                ? "eye"
                                : "eye.slash"
                        )
                        .foregroundStyle(.gray)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
            .background(.white)
            .overlay {
                RoundedRectangle(cornerRadius: 30)
                    .stroke(.gray, lineWidth: 1)
            }
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    @Previewable @State var text = ""
    TextFormField(
        label: "Password",
        hintText: "Enter password",
        fieldType: .password,
        text: $text,
    )
}
