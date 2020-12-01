//
//  restaurantInUserTableViewCell.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/29/20.
//

import UIKit
import Kingfisher

class restaurantInUserTableViewCell: UITableViewCell {

    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var nameRestaurantLabel: UILabel!
    @IBOutlet weak var titleRestaurantLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUpCell(infoRestaurant: InfoRestaurant) {
        nameRestaurantLabel.text = infoRestaurant.name
        titleRestaurantLabel.text = infoRestaurant.title
        addressLabel.text = infoRestaurant.address
        let resource = ImageResource(downloadURL: URL(string: infoRestaurant.imageLink)!, cacheKey: infoRestaurant.imageLink)
        restaurantImageView.kf.setImage(with: resource)
    }
    
}
