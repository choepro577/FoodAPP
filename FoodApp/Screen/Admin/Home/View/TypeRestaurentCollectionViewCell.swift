//
//  TypeRestaurentCollectionViewCell.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/4/20.
//

import UIKit

class TypeRestaurentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var restaurentImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    func setUpCell(nameImage: String) {
        restaurentImage.image = UIImage(named: nameImage)
    }
    
    func setUpUI() {
        shadowView.layer.cornerRadius = mainView.frame.width/20
        shadowView.layer.cornerRadius = mainView.frame.width/20
        shadowView.layer.shadowRadius = 2
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize (width: 7, height: 7)
        shadowView.layer.shadowOpacity = 0.05
    }

}
