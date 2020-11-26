//
//  AddToCardViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/25/20.
//

import UIKit
import Kingfisher
import SVProgressHUD

protocol AddToCartViewControllerDelegate {
    func addCard(countDish: Int, totalPrice: Int)
}

class AddToCardViewController: UIViewController {

    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var countDishAddedLabel: UILabel!
    @IBOutlet weak var countDishLabel: UILabel!
    @IBOutlet weak var priceDishLabel: UILabel!
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var dishImageView: UIImageView!
    @IBOutlet weak var addView: UIView!
    
    var infoRestaurant: InfoRestaurant?
    var dishDetail: InfoDishDetail?
    var countDish: Int = 1
    var totalPrice: Int = 0
    var delegate :AddToCartViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getInfoDishDetailsCard()
        setUpInfoDish()
        setUpAction()
    }
    
    func setUpAction() {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.addToCardAction))
        self.addView.addGestureRecognizer(gesture)
    }
    
    func getInfoDishDetailsCard() {
        guard let infoRestaurant = infoRestaurant, let dishDetail = dishDetail else { return }
        FirebaseManager.shared.getInfoDishDetailCard(uidRestaurant: infoRestaurant.uid, nameDish: dishDetail.nameDishDetail) { (infoCard) in
            self.countDish = infoCard.count
            self.totalPrice = infoCard.totalPrice
            DispatchQueue.main.async {
                self.countDishAddedLabel.text = "\(self.countDish)"
                self.totalPriceLabel.text = "\(self.totalPrice)"
                self.countDishLabel.text = "\(self.countDish)"
            }
        }
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func setUpInfoDish() {
        guard let dishDetail = dishDetail else { return }
        priceDishLabel.text = dishDetail.price
        dishNameLabel.text = dishDetail.nameDishDetail
        totalPriceLabel.text = dishDetail.price
        let resource = ImageResource(downloadURL: URL(string: dishDetail.imageLink)!, cacheKey: dishDetail.imageLink)
        dishImageView.kf.setImage(with: resource)
    }
    
    @objc func addToCardAction(sender : UITapGestureRecognizer) {
        guard let infoRestaurant = infoRestaurant,
              let dishDetail = dishDetail else { return }
        FirebaseManager.shared.addToCard(uidRestaurant: infoRestaurant.uid, nameDish: dishDetail.nameDishDetail, totalPrice: totalPrice, count: countDish, note: noteTextField.text ?? "") { (success, error) in
            var message: String = ""
            if (success) {
                message = "added successfully"
                SVProgressHUD.dismiss()
                self.showAlert("Notification", message)
            } else {
                guard let error = error else { return }
                message = "\(error.localizedDescription)"
            }
        }
        self.dismiss(animated: true)
    }
    
    @IBAction func reductionActionButton(_ sender: Any) {
        guard let dishDetail = dishDetail else { return }
        let priceDish = Int(dishDetail.price) ?? 0
        
        if countDish > 1 {
            countDish -= 1
            totalPrice = priceDish * countDish
            countDishLabel.text = "\(countDish)"
            countDishAddedLabel.text = "\(countDish)"
            totalPriceLabel.text = "\(totalPrice)"
            delegate?.addCard(countDish: countDish, totalPrice: totalPrice)
        }
    }
    
    @IBAction func increaseActionButton(_ sender: Any) {
        guard let dishDetail = dishDetail else { return }
        let priceDish = Int(dishDetail.price) ?? 0
        
        countDish += 1
        totalPrice = priceDish * countDish
        countDishLabel.text = "\(countDish)"
        countDishAddedLabel.text = "\(countDish)"
        totalPriceLabel.text = "\(totalPrice)"
        delegate?.addCard(countDish: countDish, totalPrice: totalPrice)
    }
    
}
