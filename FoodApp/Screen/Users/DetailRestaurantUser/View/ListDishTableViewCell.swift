//
//  ListDishTableViewCell.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/24/20.
//

import UIKit
import Kingfisher

class ListDishTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var nameDishDetailLabel: UILabel!
    @IBOutlet weak var priceDishLabel: UILabel!
    @IBOutlet weak var dishImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    func setUpUI() {
        dishImageView.layer.cornerRadius = dishImageView.frame.width/10
        
        mainView.layer.cornerRadius = mainView.frame.width/30
        mainView.layer.shadowRadius = 5
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOffset = CGSize (width: 5, height: 5)
        mainView.layer.shadowOpacity = 0.05
        mainView.layer.borderWidth = 2
        mainView.layer.borderColor = UIColor.systemGray3.cgColor
        
        nameDishDetailLabel.layer.shadowRadius = 5
        nameDishDetailLabel.layer.shadowColor = UIColor.black.cgColor
        nameDishDetailLabel.layer.shadowOffset = CGSize (width: 10, height: 10)
        nameDishDetailLabel.layer.shadowOpacity = 0.05
        
        priceDishLabel.layer.shadowRadius = 5
        priceDishLabel.layer.shadowColor = UIColor.black.cgColor
        priceDishLabel.layer.shadowOffset = CGSize (width: 10, height: 10)
        priceDishLabel.layer.shadowOpacity = 0.05
    }
    
    func setUpCell(infoDish: InfoDishDetail) {
        if infoDish.status == "still have food" {
            self.isUserInteractionEnabled = true
            mainView.backgroundColor = .white
            nameDishDetailLabel.text = infoDish.nameDishDetail
            priceDishLabel.text = "\(infoDish.price) VNĐ"
            let resource = ImageResource(downloadURL: URL(string: infoDish.imageLink)!, cacheKey: infoDish.imageLink)
            dishImageView.kf.setImage(with: resource)
        }
        if infoDish.status == "Out of Food" {
            self.isUserInteractionEnabled = false
            mainView.backgroundColor = .systemGray3
            nameDishDetailLabel.text = infoDish.nameDishDetail
            priceDishLabel.text = "\(infoDish.price) VNĐ"
            let resource = ImageResource(downloadURL: URL(string: infoDish.imageLink)!, cacheKey: infoDish.imageLink)
            dishImageView.kf.setImage(with: resource)
        }
    }
    
}
