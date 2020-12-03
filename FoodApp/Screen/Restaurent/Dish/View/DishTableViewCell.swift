//
//  DishTableViewCell.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/9/20.
//

import UIKit
import Kingfisher


class DishTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var priceDishDetailLabel: UILabel!
    @IBOutlet weak var nameDishDetailLabel: UILabel!
    @IBOutlet weak var dishDetailImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }

    func setUpCell(infoDishDetail: InfoDishDetail) {
        if infoDishDetail.status == "still have food" {
            mainView.backgroundColor = .white
            nameDishDetailLabel.text = infoDishDetail.nameDishDetail
            priceDishDetailLabel.text = infoDishDetail.price
            let resource = ImageResource(downloadURL: URL(string: infoDishDetail.imageLink)!, cacheKey: infoDishDetail.imageLink)
            dishDetailImageView.kf.setImage(with: resource)
        }
        if infoDishDetail.status == "Out of Food" {
            mainView.backgroundColor = .systemGray3
            nameDishDetailLabel.text = infoDishDetail.nameDishDetail
            priceDishDetailLabel.text = infoDishDetail.price
            let resource = ImageResource(downloadURL: URL(string: infoDishDetail.imageLink)!, cacheKey: infoDishDetail.imageLink)
            dishDetailImageView.kf.setImage(with: resource)
        }
    }
    
    func setUpUI() {
        dishDetailImageView.layer.cornerRadius = dishDetailImageView.frame.width/10
        
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
        
        priceDishDetailLabel.layer.shadowRadius = 5
        priceDishDetailLabel.layer.shadowColor = UIColor.black.cgColor
        priceDishDetailLabel.layer.shadowOffset = CGSize (width: 10, height: 10)
        priceDishDetailLabel.layer.shadowOpacity = 0.05
    }

}
