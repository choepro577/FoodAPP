//
//  PopAddPromoViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/5/20.
//

import UIKit
import SVProgressHUD

class PopAddPromoViewController: UIViewController {

    @IBOutlet weak var conditionTextField: UITextField!
    @IBOutlet weak var allView: UIView!
    @IBOutlet weak var discountTextField: UITextField!
    @IBOutlet weak var codePromoTextField: UITextField!
    @IBOutlet weak var namePromoTextField: UITextField!
    @IBOutlet weak var addPromoView: UIView!
    
    var infoRestaurant: InfoRestaurant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        discountTextField.keyboardType = .numberPad
        conditionTextField.keyboardType = .numberPad
        setUpUI()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let emp =  (self.view.frame.size.height - 315) / 3
            print(emp)
              if self.view.frame.origin.y == 0 {
                  self.view.frame.origin.y -= (keyboardSize.height - emp)
              }
         }
     }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let emp =  (self.view.frame.size.height - 315) / 3
            if self.view.frame.origin.y != 0 {
                  self.view.frame.origin.y += (keyboardSize.height + emp)
              }
         }
     }


    func setUpUI() {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.savePromoAction))
        self.addPromoView.addGestureRecognizer(gesture)
        allView.layer.cornerRadius = allView.frame.width/20
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIWindow.keyboardWillHideNotification, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tap)
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) -> Void in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func savePromoAction(sender : UITapGestureRecognizer) {
        SVProgressHUD.show()
        guard let namePromo = namePromoTextField.text,
              let codePromo = codePromoTextField.text,
              let condition = Int(conditionTextField.text!),
              let discount = Int(discountTextField.text!),
              let uid = infoRestaurant?.uid,
              !namePromo.isEmpty,
              !codePromo.isEmpty else {
            self.showAlert("Error", "Please enter your full infomation")
            SVProgressHUD.dismiss()
            return
        }
        
        FirebaseManager.shared.addPromo(uid: uid, namePromo: namePromo, codePromo: codePromo, discount: discount, condition: condition) { (success, error) in
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
