//
//  RestaurentCatagoryTableViewCell.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/7/20.
//

import UIKit

class RestaurentCatagoryTableViewCell: UITableViewCell {

    @IBOutlet weak var nameDishLabel: UILabel!
    @IBOutlet weak var dishImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpInfoCell(infoDish: InfoDish) {
        nameDishLabel.text = infoDish.nameDish
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
