//
//  File.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/4/20.
//

import Foundation

struct InfoRestaurant {
    let uid: String
    let imageLink: String
    let name: String
    let title: String
    let address: String
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.imageLink = dictionary["imageLink"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.title = dictionary["title"] as? String ?? ""
        self.address = dictionary["addressLocation"] as? String ?? ""
    }
}

struct InfoDish {
    let nameDish: String
    let imageLink: String
    
    init(nameDish: String, dictionary: [String: Any]) {
        self.nameDish = nameDish
        self.imageLink = dictionary["imagelink"] as? String ?? ""
    }
}

struct InfoDishDetail {
    let nameDishDetail: String
    let imageLink: String
    let price: String
    let status: String
    
    init(nameDishDetail: String, dictionary: [String: Any]) {
        self.nameDishDetail = nameDishDetail
        self.imageLink = dictionary["imagelink"] as? String ?? ""
        self.price = dictionary["price"] as? String ?? ""
        self.status = dictionary["status"] as? String ?? ""
    }
}

struct InfoPromo {
    let codePromo: String
    let namePromo: String
    let discount: String
    
    init(codePromo: String, dictionary: [String: Any]) {
        self.codePromo = codePromo
        self.namePromo = dictionary["namePromo"] as? String ?? ""
        self.discount = dictionary["discount"] as? String ?? ""
    }
}
