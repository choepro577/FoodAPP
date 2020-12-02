//
//  UserModel.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/11/20.
//

import Foundation


struct CurrentUser {
    let uid: String
    let name: String
    let rule: String
    let address: String
    let subAddress: String
    let typeRestaurant: String
    let phoneNumber: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.name = dictionary["username"] as? String ?? ""
        self.rule = dictionary["rule"] as? String ?? ""
        self.typeRestaurant = dictionary["typeRestaurant"] as? String ?? ""
        self.phoneNumber = dictionary["phoneNumber"] as? String ?? ""
        self.address = dictionary["address"] as? String ?? ""
        self.subAddress = dictionary["subAddress"] as? String ?? ""
    }
}
