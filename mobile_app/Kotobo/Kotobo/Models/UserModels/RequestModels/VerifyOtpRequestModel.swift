//
//  VerifyOtpModel.swift
//  Kotobo
//
//  Created by Govine Rajput on 19/10/26.
//

import Foundation

struct VerifyOtpRequestModel: Encodable {
    let email: String
    let otp: String
}
