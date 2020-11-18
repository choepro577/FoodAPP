//
//  SignUpViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/4/20.
//

import UIKit
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var ruleTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpView: UIView!
    
    var pickerView = UIPickerView()
    let listChooserule: [String] = ["user", "restaurant"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAction()
        setUpPickerView()
    }
    
    func setUpAction() {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.creatAccount))
        self.signUpView.addGestureRecognizer(gesture)
    }
    
    func setUpPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        
        ruleTextField.inputView = pickerView
        ruleTextField.placeholder = "Select rule"
        ruleTextField.textAlignment = .center
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func creatAccount(sender : UITapGestureRecognizer) {
        guard let email = emailTextField.text, let password = passwordTextField.text,  let username = nameTextField.text, let rule = ruleTextField.text, !email.isEmpty, !password.isEmpty, !username.isEmpty, !rule.isEmpty else {
            showAlert("Error", "Please enter your full infomation")
            return
        }
        FirebaseManager.shared.createUser(email: email, password: password) {[weak self] (success, error, user)  in
            guard let `self` = self else { return }
            var message: String = ""
            if (success) {
                let ref = FirebaseDatabase.Database.database().reference()
                let usersReference = ref.child("admin").child("allUser")
                guard let user = user else { return }
                let uid = user.uid
                let newUsersReference = usersReference.child(uid)
                newUsersReference.setValue(["username": username, "email": email, "rule": rule, "typeRestaurant": rule])
                message = "User was sucessfully created."
            } else {
                guard let error = error else { return }
                message = "\(error.localizedDescription)"
            }
            self.showAlert("Notification", "\(message)")
        }
    }
}

extension SignUpViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        listChooserule.count
    }
    
}

extension SignUpViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listChooserule[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ruleTextField.text = listChooserule[row]
        ruleTextField.resignFirstResponder()
    }
    
}
