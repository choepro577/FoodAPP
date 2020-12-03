//
//  AddToCardViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/25/20.
//

import UIKit
import Kingfisher
import SVProgressHUD

class AddToCardViewController: UIViewController {

    @IBOutlet weak var addTocartScrollView: UIScrollView!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getInfoDishDetailsCard()
        setUpInfoDish()
        setUpAction()
        setUpUI()
    }
    
    func setUpUI() {
        addView.layer.cornerRadius = addView.frame.width/30
        addView.layer.shadowRadius = 5
        addView.layer.shadowColor = UIColor.black.cgColor
        addView.layer.shadowOffset = CGSize (width: 10, height: 10)
        addView.layer.shadowOpacity = 0.1
        addView.layer.borderWidth = 2
        addView.layer.borderColor = UIColor.white.cgColor
    }
    
    func setUpAction() {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.addToCardAction))
        self.addView.addGestureRecognizer(gesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIWindow.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {

        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.addTocartScrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        addTocartScrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        addTocartScrollView.contentInset = contentInset
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
                let priceDish = Int(dishDetail.price) ?? 0
        if totalPrice == 0 {
            FirebaseManager.shared.addToCard(uidRestaurant: infoRestaurant.uid, nameDish: dishDetail.nameDishDetail, totalPrice: priceDish, count: countDish, note: noteTextField.text ?? "") { (success, error) in
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
        } else {
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
    }
    
}
