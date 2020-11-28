//
//  ListOrderTableViewCell.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/27/20.
//

import UIKit

class ListOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var orderView: UIView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var phoneUserOrderLabel: UILabel!
    @IBOutlet weak var addressUserOrderLabel: UILabel!
    @IBOutlet weak var nameUserOrderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func isComing(uidUser: String, status: String) {
        if status == "1" {
            FirebaseManager.shared.updateStatusOrderOfRestaurant(status: "2", uidUser: uidUser) { (suscess, error) in
                if (suscess) {
                    //
                }
            }
        }
        if status == "2" {
            FirebaseManager.shared.updateStatusOrderOfRestaurant(status: "1", uidUser: uidUser) { (suscess, error) in
                if (suscess) {
                   //
                }
            }
        }
    }
    
    func setUpCell(infoOrder: InfoOrderofUser) {
        idLabel.text = infoOrder.id
        phoneUserOrderLabel.text = infoOrder.phone
        addressUserOrderLabel.text = infoOrder.address
        nameUserOrderLabel.text = "\(infoOrder.name)"
        totalPriceLabel.text = "\(infoOrder.totalPrice)"
        if infoOrder.status == "1" {
            orderView.backgroundColor = UIColor.white
        }
        if infoOrder.status == "2"
        {
            orderView.backgroundColor = UIColor.green
        }
        if infoOrder.status == "3"
        {
            orderView.backgroundColor = UIColor.systemGray2
        }
    }
    
}
