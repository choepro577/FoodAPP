//
//  ListRestaurentTableViewCell.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/5/20.
//

import UIKit

class ListRestaurentTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var addressRestaurantLabel: UILabel!
    @IBOutlet weak var imageRestaurant: UIImageView!
    @IBOutlet weak var titleRestaurantLabel: UILabel!
    @IBOutlet weak var nameRestaurantLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    func setUpUI() {
        imageRestaurant.layer.cornerRadius = imageRestaurant.frame.width/20

        mainView.layer.cornerRadius = mainView.frame.width/30
        mainView.layer.shadowRadius = 5
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOffset = CGSize (width: 5, height: 5)
        mainView.layer.shadowOpacity = 0.05
        mainView.layer.borderWidth = 2
        mainView.layer.borderColor = UIColor.systemGray3.cgColor
    }
    
    func setUpInfoCell(infoRestaurant: InfoRestaurant) {
        nameRestaurantLabel.text = infoRestaurant.name
        titleRestaurantLabel.text = infoRestaurant.title
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
