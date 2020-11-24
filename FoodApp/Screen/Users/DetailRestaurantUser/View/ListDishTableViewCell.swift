//
//  ListDishTableViewCell.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/24/20.
//

import UIKit
import Kingfisher

class ListDishTableViewCell: UITableViewCell {

    @IBOutlet weak var nameDishDetailLabel: UILabel!
    @IBOutlet weak var priceDishLabel: UILabel!
    @IBOutlet weak var dishImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUpCell(infoDish: InfoDishDetail) {
        nameDishDetailLabel.text = infoDish.nameDishDetail
        priceDishLabel.text = infoDish.price
        let resource = ImageResource(downloadURL: URL(string: infoDish.imageLink)!, cacheKey: infoDish.imageLink)
        dishImageView.kf.setImage(with: resource)
    }
    
}
