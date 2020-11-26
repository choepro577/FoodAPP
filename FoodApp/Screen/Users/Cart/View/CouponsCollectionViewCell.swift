//
//  CouponsCollectionViewCell.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/26/20.
//

import UIKit

protocol CouponsCollectionViewCellDelegate {
    func addPromo(discount: Int)
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
        delegate?.addPromo(discount: infoPromo.discount)
    }
    
    func setUpCell(infoPromo: InfoPromo) {
        self.infoPromo = infoPromo
        percentCouponLabel.text = "\(infoPromo.discount)"
        nameCouponLabel.text = infoPromo.namePromo
        codeCoponLabel.text = infoPromo.codePromo
    }

}
