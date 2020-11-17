//
//  ListRestaurentTableViewCell.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/5/20.
//

import UIKit

class ListRestaurentTableViewCell: UITableViewCell {

    @IBOutlet weak var imageRestaurant: UIImageView!
    @IBOutlet weak var titleRestaurantLabel: UILabel!
    @IBOutlet weak var nameRestaurantLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
