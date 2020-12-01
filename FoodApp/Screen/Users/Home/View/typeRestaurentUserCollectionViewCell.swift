//
//  typeRestaurentUserCollectionViewCell.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/10/20.
//

import UIKit

class typeRestaurentUserCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var restaurentImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    func setUpCell(nameImage: String) {
        restaurentImageView.image = UIImage(named: nameImage)
    }
    
    func setUpUI() {
        shadowView.layer.cornerRadius = shadowView.frame.width/20
        shadowView.layer.cornerRadius = shadowView.frame.width/20
        shadowView.layer.shadowRadius = 2
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize (width: 7, height: 7)
        shadowView.layer.shadowOpacity = 0.05
    }

}

