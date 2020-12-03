//
//  SignUpViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/4/20.
//

import UIKit
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var signUpScroolView: UIScrollView!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var ruleTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpView: UIView!
    
    var pickerView = UIPickerView()
    let listChooserule: [String] = ["user", "restaurant"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberTextField.keyboardType = .numberPad
        setUpAction()
        setUpPickerView()
        setUpUI()
    }
    
    func setUpUI() {
        emailTextField.layer.shadowColor = UIColor.black.cgColor
        emailTextField.layer.shadowOffset = CGSize (width: 10, height: 10)
        emailTextField.layer.shadowOpacity = 0.1
        
        passwordTextField.layer.shadowColor = UIColor.black.cgColor
        passwordTextField.layer.shadowOffset = CGSize (width: 10, height: 10)
        passwordTextField.layer.shadowOpacity = 0.1
        
        roleLabel.layer.shadowColor = UIColor.black.cgColor
        roleLabel.layer.shadowOffset = CGSize (width: 10, height: 10)
        roleLabel.layer.shadowOpacity = 0.1
        
        phoneNumberLabel.layer.shadowColor = UIColor.black.cgColor
        phoneNumberLabel.layer.shadowOffset = CGSize (width: 10, height: 10)
        phoneNumberLabel.layer.shadowOpacity = 0.1
        
        passwordLabel.layer.shadowColor = UIColor.black.cgColor
        passwordLabel.layer.shadowOffset = CGSize (width: 10, height: 10)
        passwordLabel.layer.shadowOpacity = 0.1
        
        nameLabel.layer.shadowColor = UIColor.black.cgColor
        nameLabel.layer.shadowOffset = CGSize (width: 10, height: 10)
        nameLabel.layer.shadowOpacity = 0.1
        
        signUpLabel.layer.shadowColor = UIColor.black.cgColor
        signUpLabel.layer.shadowOffset = CGSize (width: 10, height: 10)
        signUpLabel.layer.shadowOpacity = 0.1
        
        emailLabel.layer.shadowColor = UIColor.black.cgColor
        emailLabel.layer.shadowOffset = CGSize (width: 10, height: 10)
        emailLabel.layer.shadowOpacity = 0.1
        
        signUpView.layer.cornerRadius = signUpView.frame.width/20
        signUpView.layer.shadowRadius = 5
        signUpView.layer.shadowColor = UIColor.black.cgColor
        signUpView.layer.shadowOffset = CGSize (width: 10, height: 10)
        signUpView.layer.shadowOpacity = 0.1
        signUpView.layer.borderWidth = 2
        signUpView.layer.borderColor = UIColor.white.cgColor
    }
    
    func setUpAction() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIWindow.keyboardWillHideNotification, object: nil)
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.creatAccount))
        self.signUpView.addGestureRecognizer(gesture)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {

        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.signUpScroolView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        signUpScroolView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification) {

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        signUpScroolView.contentInset = contentInset
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
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let username = nameTextField.text,
              let rule = ruleTextField.text,
              let phoneNumber = phoneNumberTextField.text,
              !email.isEmpty,
              !password.isEmpty,
              !username.isEmpty,
              !phoneNumber.isEmpty,
              !rule.isEmpty else {
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
                newUsersReference.setValue(["username": username, "email": email, "rule": rule, "typeRestaurant": rule, "phoneNumber": phoneNumber])
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
