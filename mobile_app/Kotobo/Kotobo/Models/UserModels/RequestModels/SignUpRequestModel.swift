//
//  SignUpRequestModel.swift
//  Kotobo
//
//  Created by Govine Rajput on 19/10/26.
//

import Foundation

struct SignUpRequestModel: Encodable {
    let email: String
    let username: String
    let password: String
}
