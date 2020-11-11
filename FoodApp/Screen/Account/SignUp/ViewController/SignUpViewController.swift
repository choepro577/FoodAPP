//
//  SignUpViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/4/20.
//

import UIKit
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var rolePickerView: UIPickerView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpView: UIView!
    
    let listChoose: [String] = ["User",
                                "Restaurent"]
    
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
        rolePickerView.delegate = self
        rolePickerView.dataSource = self
    }
    
    @objc func creatAccount(sender : UITapGestureRecognizer) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            FirebaseManager.shared.createUser(email: email, password: password) {[weak self] (success, error, user)  in
                guard let `self` = self else { return }
                var message: String = ""
                if (success) {
                    let ref = FirebaseDatabase.Database.database().reference()
                    let usersReference = ref.child("users")
                    guard let user = user else { return }
                    let uid = user.uid
                    let newUsersReference = usersReference.child(uid)
                    newUsersReference.setValue(["username": self.nameTextField.text, "email": self.emailTextField.text])
                    message = "User was sucessfully created."
                } else {
                    guard let error = error else { return }
                    message = "\(error.localizedDescription)"
                }
                let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

extension SignUpViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        listChoose.count
    }

}

extension SignUpViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listChoose[row]
    }
    
}
