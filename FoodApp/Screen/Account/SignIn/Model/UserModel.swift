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
    let typeRestaurant: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.name = dictionary["name"] as? String ?? ""
        self.rule = dictionary["rule"] as? String ?? ""
        self.typeRestaurant = dictionary["typeRestaurant"] as? String ?? ""
    }
}
