//
//  CartViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/25/20.
//

import UIKit

class CartViewController: UIViewController {

    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var totalPriceDishsLabel: UILabel!
    @IBOutlet weak var totalCountDishLabel: UILabel!
    @IBOutlet weak var dishCollectionView: UICollectionView!
    @IBOutlet weak var couponsCollectionView: UICollectionView!
    @IBOutlet weak var totalMoneyPayLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    
    var infoRestaurant: InfoRestaurant?
    var listInfoDistOrder: [InfoCard] = [InfoCard]()
    var listPromo: [InfoPromo] = [InfoPromo]()
    var provisionalFee: Int?
    var applyFees: Int = 15000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAction()
        setUpCollectionView()
        getInfoCart()
        getListPromo()
    }
    
    func getInfoCart() {
        guard let infoRestaurant = infoRestaurant  else { return }
        FirebaseManager.shared.getInfoCard(uidRestaurant: infoRestaurant.uid) { (countDish, totalPrice, listInfocart) in
            self.listInfoDistOrder = listInfocart
            self.provisionalFee = totalPrice
            DispatchQueue.main.async {
                self.totalPriceDishsLabel.text = "\(totalPrice)"
                self.totalCountDishLabel.text = "\(countDish)"
                self.totalMoneyPayLabel.text = "\(totalPrice + self.applyFees)"
                self.dishCollectionView.reloadData()
            }
        }
    }
    
    func getListPromo() {
        guard let infoRestaurant = infoRestaurant  else { return }
        FirebaseManager.shared.getListPromoRestaurant(uid: infoRestaurant.uid) { (listPromo) in
            self.listPromo = listPromo
            DispatchQueue.main.async {
                self.couponsCollectionView.reloadData()
            }
        }
    }
    
    func setUpCollectionView() {
        dishCollectionView.delegate = self
        dishCollectionView.dataSource = self
        dishCollectionView.register(UINib(nibName: "DishCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CellID")
        
        couponsCollectionView.delegate = self
        couponsCollectionView.dataSource = self
        couponsCollectionView.register(UINib(nibName: "CouponsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CellID")
    }

    func setUpAction() {
        let imageDismissRestaurantGesture = UITapGestureRecognizer(target: self, action:  #selector(self.dismissAction))
        backImageView.isUserInteractionEnabled = true
        self.backImageView.addGestureRecognizer(imageDismissRestaurantGesture)
    }
    
    @objc func dismissAction(sender : UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension CartViewController: UICollectionViewDelegate {
    
}

extension CartViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.dishCollectionView {
            return listInfoDistOrder.count
        } else {
                return listPromo.count
            }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.dishCollectionView {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath) as? DishCollectionViewCell else { return DishCollectionViewCell() }
            cell.infoRestaurant = infoRestaurant
            cell.setUpCell(infoCart: listInfoDistOrder[indexPath.row])
            return cell
            
        } else {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath) as? CouponsCollectionViewCell else { return CouponsCollectionViewCell() }
            cell.setUpCell(infoPromo: listPromo[indexPath.row])
            cell.delegate = self
            return cell
            }
    }

}

extension CartViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.dishCollectionView {
            let numberCellForRow: CGFloat = 1
            let widthForOneItem = self.dishCollectionView.bounds.size.width / numberCellForRow
            return CGSize (width: widthForOneItem, height: 50)// chiều cao cell
        } else {
            let numberCellForRow: CGFloat = 1.3
            let widthForOneItem = self.dishCollectionView.bounds.size.width / numberCellForRow
            return CGSize (width: widthForOneItem, height: 80)// chiều cao cell
            }
    }
}

extension CartViewController: CouponsCollectionViewCellDelegate {
    func addPromo(discount: Int) {
        guard let provisionalFee = provisionalFee else { return }
        totalMoneyPayLabel.text = "\(provisionalFee + applyFees - (((provisionalFee + applyFees) * discount) / 100))"
        discountLabel.text = "- \(((provisionalFee + applyFees) * discount) / 100)"
    }
}
