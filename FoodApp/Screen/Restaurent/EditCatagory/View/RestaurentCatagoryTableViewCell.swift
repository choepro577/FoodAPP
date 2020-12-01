//
//  RestaurentCatagoryTableViewCell.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/7/20.
//

import UIKit

class RestaurentCatagoryTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var nameDishLabel: UILabel!
    @IBOutlet weak var dishImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    func setUpInfoCell(infoDish: InfoDish) {
        nameDishLabel.text = infoDish.nameDish
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
        
        nameDishLabel.layer.shadowRadius = 5
        nameDishLabel.layer.shadowColor = UIColor.black.cgColor
        nameDishLabel.layer.shadowOffset = CGSize (width: 10, height: 10)
        nameDishLabel.layer.shadowOpacity = 0.05
    }
    
}
