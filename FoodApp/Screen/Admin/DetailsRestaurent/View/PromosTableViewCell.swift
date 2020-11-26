//
//  PromosTableViewCell.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/5/20.
//

import UIKit

class PromosTableViewCell: UITableViewCell {

    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var namePromoLabel: UILabel!
    @IBOutlet weak var codePromoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpCell(infoPromo: InfoPromo) {
        self.namePromoLabel.text = infoPromo.namePromo
        self.codePromoLabel.text = infoPromo.codePromo
        self.discountLabel.text = "\(infoPromo.discount)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
