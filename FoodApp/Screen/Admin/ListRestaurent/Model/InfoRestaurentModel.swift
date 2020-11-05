//
//  File.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/4/20.
//

import Foundation

class InfoRestaurent {
    var image: String
    var name: String
    var title: String
    var address: String
    init(image: String, name: String, title: String, address: String) {
        self.image = image
        self.name = name
        self.title = name
        self.address = address
    }
}
