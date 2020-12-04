//
//  DetailHistoryTableViewCell.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 12/4/20.
//

import UIKit

class DetailHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var nameDishLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUpCell(infoCard: InfoCard)  {
        nameDishLabel.text = "Name dish: \(infoCard.nameDish)"
        countLabel.text = "Count: \(infoCard.count)"
        noteLabel.text = "Note: \(infoCard.note)"
        totalPriceLabel.text = "\(infoCard.totalPrice) VNĐ"
    }
    
}
