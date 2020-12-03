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
    let condition: Int
    let codePromo: String
    let namePromo: String
    let discount: Int
    
    init(codePromo: String, dictionary: [String: Any]) {
        self.codePromo = codePromo
        self.namePromo = dictionary["namePromo"] as? String ?? ""
        self.discount = dictionary["discount"] as? Int ?? 0
        self.condition = dictionary["condition"] as? Int ?? 0
    }
}

struct InfoCard {
    let status: String
    let nameDish: String
    let count: Int
    let note: String
    let totalPrice: Int
    
    init(nameDish: String, dictionary: [String: Any]) {
        self.nameDish = nameDish
        self.count = dictionary["count"] as? Int ?? 1
        self.note = dictionary["note"] as? String ?? ""
        self.totalPrice = dictionary["totalPrice"] as? Int ?? 1
        self.status = dictionary["status"] as? String ?? ""
    }
}

struct InfoOrderofUser {
    let id: String
    let status: String
    let name: String
    let address: String
    let phone: String
    let totalPrice: Int
    let dateTime: String
    
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        self.status = dictionary["status"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.totalPrice = dictionary["totalPrice"] as? Int ?? 1
        self.address = dictionary["address"] as? String ?? ""
        self.phone = dictionary["phoneNumber"] as? String ?? ""
        self.dateTime = dictionary["dateTime"] as? String ?? ""
    }
}

struct HistoryOrderofUser {
    let id: String
    let status: String
    let name: String
    let addressRestaurant: String
    let dateTime: String
    let totalPrice: Int
    
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        self.status = dictionary["status"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.totalPrice = dictionary["totalPrice"] as? Int ?? 1
        self.addressRestaurant = dictionary["addressRestaurant"] as? String ?? ""
        self.dateTime = dictionary["dateTime"] as? String ?? ""
    }
}
