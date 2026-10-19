//
//  ChangePasswordModel.swift
//  Kotobo
//
//  Created by Govine Rajput on 19/10/26.
//

import Foundation


struct ChangePasswordRequestModel: Encodable {
    let email: String
    let password: String
}
