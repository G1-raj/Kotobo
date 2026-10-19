//
//  LoginResponseModel.swift
//  Kotobo
//
//  Created by Govine Rajput on 19/10/26.
//

import Foundation

struct LoginResponseModel: Decodable {
    let id: Int
    let email: String
    let username: String
    let accessToken: String
    let createdAt: Date
    let updatedAt: Date
}
