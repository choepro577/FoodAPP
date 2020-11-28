//
//  DishOrderInRestaurantTableViewCell.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/28/20.
//

import UIKit

class DishOrderInRestaurantTableViewCell: UITableViewCell {

    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var nameDishLabel: UILabel!
    @IBOutlet weak var countDishLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func setUpCell(infoDishOrder: InfoCard) {
            countDishLabel.text = "\(infoDishOrder.count)x"
            nameDishLabel.text = infoDishOrder.nameDish
            noteLabel.text = infoDishOrder.note
            totalPriceLabel.text = "\(infoDishOrder.totalPrice)"
    }
    
}
