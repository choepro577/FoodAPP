//
//  TypeRestaurentCollectionViewCell.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/4/20.
//

import UIKit

class TypeRestaurentCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var restaurentImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpUI(nameImage: String) {
        restaurentImage.image = UIImage(named: nameImage)
    }

}
