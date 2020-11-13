//
//  PopSaveRestaurentViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/5/20.
//

import UIKit

class PopSaveRestaurentViewController: UIViewController {

    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var titleRestaurentTextField: UITextField!
    @IBOutlet weak var nameRestaurantTextField: UITextField!
    @IBOutlet weak var saveView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAction()
    }

    func setUpAction() {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.saveRestaurentAction))
        self.saveView.addGestureRecognizer(gesture)
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func saveRestaurentAction(sender : UITapGestureRecognizer) {
        guard let name = nameRestaurantTextField.text, let title = titleRestaurentTextField.text,  let address = addressTextField.text,!name.isEmpty, !title.isEmpty, !address.isEmpty else {
            showAlert("Error", "Please enter your full infomation")
            return
        }
        FirebaseManager.shared.addRestaurant(name: name, title: title, address: address)
       // self.dismiss(animated: true)
    }

}
