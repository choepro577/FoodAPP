//
//  RestaurentsTableViewCell.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/10/20.
//

import UIKit
import Kingfisher

class RestaurentsTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var addressRestaurantLabel: UILabel!
    @IBOutlet weak var titleRestaurantLabel: UILabel!
    @IBOutlet weak var nameRestaurantLabel: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    func setUpUI() {
        restaurantImageView.layer.cornerRadius = restaurantImageView.frame.width/20
        mainView.layer.cornerRadius = mainView.frame.width/30
        mainView.layer.shadowRadius = 5
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOffset = CGSize (width: 5, height: 5)
        mainView.layer.shadowOpacity = 0.05
        mainView.layer.borderWidth = 2
        mainView.layer.borderColor = UIColor.systemGray3.cgColor
    }
    
    func setUpCell(infoRestaurant: InfoRestaurant) {
        nameRestaurantLabel.text = infoRestaurant.name
        titleRestaurantLabel.text = infoRestaurant.title
        addressRestaurantLabel.text = infoRestaurant.address
        let resource = ImageResource(downloadURL: URL(string: infoRestaurant.imageLink)!, cacheKey: infoRestaurant.imageLink)
        restaurantImageView.kf.setImage(with: resource)
    }
    
}
