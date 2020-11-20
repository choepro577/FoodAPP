//
//  DishTableViewCell.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/9/20.
//

import UIKit
import Kingfisher


class DishTableViewCell: UITableViewCell {

    @IBOutlet weak var priceDishDetailLabel: UILabel!
    @IBOutlet weak var nameDishDetailLabel: UILabel!
    @IBOutlet weak var dishDetailImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func setUpCell(infoDishDetail: InfoDishDetail) {
        nameDishDetailLabel.text = infoDishDetail.nameDishDetail
        priceDishDetailLabel.text = infoDishDetail.price
        let resource = ImageResource(downloadURL: URL(string: infoDishDetail.imageLink)!, cacheKey: infoDishDetail.imageLink)
        dishDetailImageView.kf.setImage(with: resource)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
