//
//  DishCollectionViewCell.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/26/20.
//

import UIKit

class DishCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var nameDishLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    var infoCart: InfoCard?
    var infoRestaurant: InfoRestaurant?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    
    @IBAction func deleteDishAction(_ sender: Any) {
        guard let infoRestaurant = infoRestaurant, let infoCart = infoCart else { return }
        FirebaseManager.shared.deleteDishChoosed(uidRestaurant: infoRestaurant.uid, nameDish: infoCart.nameDish) { (success, error) in
            if (success) {
            //
            } else {
                return
            }
        }
    }
    
    func setUpCell(infoCart: InfoCard) {
        self.infoCart = infoCart
        totalPriceLabel.text = "\(infoCart.totalPrice)"
        countLabel.text = "\(infoCart.count)x"
        nameDishLabel.text = "\(infoCart.nameDish)"
    }
    
}
