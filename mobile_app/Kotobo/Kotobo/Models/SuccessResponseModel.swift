//
//  SuccessResponseModel.swift
//  Kotobo
//
//  Created by Govine Rajput on 18/10/26.
//

import Foundation

struct SuccessResponseModel<T: Decodable>: Decodable {
    let success: Bool
    let data: T?
    let message: String
}
