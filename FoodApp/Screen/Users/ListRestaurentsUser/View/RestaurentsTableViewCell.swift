//
//  RestaurentsTableViewCell.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/10/20.
//

import UIKit
import Kingfisher

class RestaurentsTableViewCell: UITableViewCell {

    @IBOutlet weak var addressRestaurantLabel: UILabel!
    @IBOutlet weak var titleRestaurantLabel: UILabel!
    @IBOutlet weak var nameRestaurantLabel: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func setUpCell(infoRestaurant: InfoRestaurant) {
        nameRestaurantLabel.text = infoRestaurant.name
        titleRestaurantLabel.text = infoRestaurant.title
        addressRestaurantLabel.text = infoRestaurant.address
        let resource = ImageResource(downloadURL: URL(string: infoRestaurant.imageLink)!, cacheKey: infoRestaurant.imageLink)
        restaurantImageView.kf.setImage(with: resource)
    }
    
}
