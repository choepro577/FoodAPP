//
//  CartViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/25/20.
//

import UIKit
import GooglePlaces

class CartViewController: UIViewController {
    
    @IBOutlet weak var AddressLocationLabel: UILabel!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var totalPriceDishsLabel: UILabel!
    @IBOutlet weak var totalCountDishLabel: UILabel!
    @IBOutlet weak var dishCollectionView: UICollectionView!
    @IBOutlet weak var couponsCollectionView: UICollectionView!
    @IBOutlet weak var totalMoneyPayLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var orderView: UIView!
    
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
        setUpUI()
    }
    
    func setUpUI() {
        orderView.layer.cornerRadius = orderView.frame.width/20
        orderView.layer.shadowRadius = 5
        orderView.layer.shadowColor = UIColor.black.cgColor
        orderView.layer.shadowOffset = CGSize (width: 10, height: 10)
        orderView.layer.shadowOpacity = 0.1
        orderView.layer.borderWidth = 2
        orderView.layer.borderColor = UIColor.white.cgColor
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
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
        
        let cartViewRestaurantGesture = UITapGestureRecognizer(target: self, action:  #selector(self.orderAction))
        self.orderView.addGestureRecognizer(cartViewRestaurantGesture)
    }
    
    @objc func orderAction(sender : UITapGestureRecognizer) {
        guard let infoRestaurant = infoRestaurant  else { return }
        guard let provisionalFee = provisionalFee else { return }
        
        if listInfoDistOrder.isEmpty {
            self.showAlert("Error", "You have not placed an order")
        } else {
            FirebaseManager.shared.orderRestaurant(uidRestaurant: infoRestaurant.uid, status: "1", address: "39 nguyen thi dieu", totalPrice: provisionalFee) { (success, error) in
                var message: String = ""
                if (success) {
                  let vc = DishisCommingViewController()
                    vc.infoRestaurant = infoRestaurant
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    guard let error = error else { return }
                    message = "\(error.localizedDescription)"
                    self.showAlert("Error", message)
                }
            }
        }
    }
    
    @objc func dismissAction(sender : UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editPlace(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
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

extension CartViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        AddressLocationLabel.text = place.formattedAddress ?? "unknown address"
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension CartViewController: CouponsCollectionViewCellDelegate {
    func addPromo(discount: Int, condition: Int) {
        guard let provisionalFee = provisionalFee else { return }
        
        if provisionalFee >= condition {
            totalMoneyPayLabel.text = "\(provisionalFee + applyFees - (((provisionalFee + applyFees) * discount) / 100))"
            discountLabel.text = "- \(((provisionalFee + applyFees) * discount) / 100)"
        } else {
            self.showAlert("Error", "The orders value is not enough")
            discountLabel.text = "0"
            totalMoneyPayLabel.text = "\(provisionalFee + applyFees)"
        }
    }
}

