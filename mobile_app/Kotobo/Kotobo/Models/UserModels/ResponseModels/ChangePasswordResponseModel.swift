//
//  ChangePasswordResponseModel.swift
//  Kotobo
//
//  Created by Govine Rajput on 19/10/26.
//

import Foundation


struct ChangePasswordResponseModel: Decodable {
    let id: Int
    let email: String
    let username: String
    let createdAt: Date
    let updatedAt: Date
}
