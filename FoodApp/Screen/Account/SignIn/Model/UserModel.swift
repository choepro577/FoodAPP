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
    let permission: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.name = dictionary["name"] as? String ?? ""
        self.permission = dictionary["permission"] as? String ?? ""
    }
}
