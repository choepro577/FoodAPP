//
//  PopAddPromoViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/5/20.
//

import UIKit
import SVProgressHUD

class PopAddPromoViewController: UIViewController {

    @IBOutlet weak var discountTextField: UITextField!
    @IBOutlet weak var codePromoTextField: UITextField!
    @IBOutlet weak var namePromoTextField: UITextField!
    @IBOutlet weak var addPromoView: UIView!
    
    var infoRestaurant: InfoRestaurant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }


    func setUpUI() {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.savePromoAction))
        self.addPromoView.addGestureRecognizer(gesture)
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func savePromoAction(sender : UITapGestureRecognizer) {
        SVProgressHUD.show()
        guard let namePromo = namePromoTextField.text,
              let codePromo = codePromoTextField.text,
              let discount = discountTextField.text,
              let uid = infoRestaurant?.uid,
              !namePromo.isEmpty,
              !codePromo.isEmpty,
              !discount.isEmpty else {
            self.showAlert("Error", "Please enter your full infomation")
            SVProgressHUD.dismiss()
            return
        }
        
        FirebaseManager.shared.addPromo(uid: uid, namePromo: namePromo, codePromo: codePromo, discount: discount) { (success, error) in
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

}
