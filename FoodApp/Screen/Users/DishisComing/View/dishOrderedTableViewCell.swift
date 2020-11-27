//
//  dishOrderedTableViewCell.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/27/20.
//

import UIKit

class dishOrderedTableViewCell: UITableViewCell {

    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var nameDishLabel: UILabel!
    @IBOutlet weak var countDishLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func setUpCell(infoCard: InfoCard ) {
        countDishLabel.text = "\(infoCard.count)x"
        nameDishLabel.text = infoCard.nameDish
        totalPriceLabel.text = "\(infoCard.totalPrice)"
    }
    
    
}
