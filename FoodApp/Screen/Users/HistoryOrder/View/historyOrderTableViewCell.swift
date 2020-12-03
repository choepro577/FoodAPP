//
//  historyOrderTableViewCell.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 12/4/20.
//

import UIKit

class historyOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var addressResLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func setUpCell(infoHistoryOrder: HistoryOrderofUser) {
        totalPriceLabel.text = "\(infoHistoryOrder.totalPrice)"
        addressResLabel.text = infoHistoryOrder.addressRestaurant
    }
    
}
