//
//  typeRestaurentUserCollectionViewCell.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/10/20.
//

import UIKit

class typeRestaurentUserCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var restaurentImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpUI(nameImage: String) {
        restaurentImageView.image = UIImage(named: nameImage)
    }

}

