//
//  CouponsCollectionViewCell.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/26/20.
//

import UIKit

protocol CouponsCollectionViewCellDelegate {
    func addPromo(discount: Int, condition: Int)
}

class CouponsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var addCouponView: UIView!
    @IBOutlet weak var percentCouponLabel: UILabel!
    @IBOutlet weak var nameCouponLabel: UILabel!
    @IBOutlet weak var codeCoponLabel: UILabel!
    
    var infoPromo: InfoPromo?
    var delegate :CouponsCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpAction()
    }
    
    func setUpAction() {
        let addGesture = UITapGestureRecognizer(target: self, action:  #selector(self.addCouponAction))
        self.addCouponView.addGestureRecognizer(addGesture)
    }
    
    @objc func addCouponAction(sender : UITapGestureRecognizer) {
        guard let infoPromo = infoPromo else { return }
        delegate?.addPromo(discount: infoPromo.discount, condition: infoPromo.condition)
    }
    
    func setUpUI() {
//        mainView.layer.cornerRadius = mainView.frame.width/20
//
//        catagoryImageView.layer.cornerRadius = mainView.frame.width/20
//
//        saveCatagoryView.layer.cornerRadius = saveCatagoryView.frame.width/20
//        saveCatagoryView.layer.shadowRadius = 5
//        saveCatagoryView.layer.shadowColor = UIColor.black.cgColor
//        saveCatagoryView.layer.shadowOffset = CGSize (width: 10, height: 10)
//        saveCatagoryView.layer.shadowOpacity = 0.1
//        saveCatagoryView.layer.borderWidth = 2
//        saveCatagoryView.layer.borderColor = UIColor.white.cgColor
    }
    
    func setUpCell(infoPromo: InfoPromo) {
        self.infoPromo = infoPromo
        percentCouponLabel.text = "\(infoPromo.discount)"
        nameCouponLabel.text = infoPromo.namePromo
        codeCoponLabel.text = infoPromo.codePromo
    }

}
