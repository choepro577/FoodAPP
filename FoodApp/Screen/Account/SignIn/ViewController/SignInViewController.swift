//
//  SignInViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/4/20.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

class SignInViewController: UIViewController {
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var signinLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var forgotPassWordLabel: UILabel!
    @IBOutlet weak var signInView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpAction()
    }
    
    func setUpUI() {
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: "Forgot your password?", attributes: underlineAttribute)
        forgotPassWordLabel.attributedText = underlineAttributedString
        
        emailTextField.layer.shadowColor = UIColor.black.cgColor
        emailTextField.layer.shadowOffset = CGSize (width: 10, height: 10)
        emailTextField.layer.shadowOpacity = 0.1
        
        passwordTextField.layer.shadowColor = UIColor.black.cgColor
        passwordTextField.layer.shadowOffset = CGSize (width: 10, height: 10)
        passwordTextField.layer.shadowOpacity = 0.1
        
        signinLabel.layer.shadowColor = UIColor.black.cgColor
        signinLabel.layer.shadowOffset = CGSize (width: 10, height: 10)
        signinLabel.layer.shadowOpacity = 0.1
        
        emailLabel.layer.shadowColor = UIColor.black.cgColor
        emailLabel.layer.shadowOffset = CGSize (width: 10, height: 10)
        emailLabel.layer.shadowOpacity = 0.1
        
        passwordLabel.layer.shadowColor = UIColor.black.cgColor
        passwordLabel.layer.shadowOffset = CGSize (width: 10, height: 10)
        passwordLabel.layer.shadowOpacity = 0.1
        
        forgotPassWordLabel.layer.shadowColor = UIColor.black.cgColor
        forgotPassWordLabel.layer.shadowOffset = CGSize (width: 10, height: 10)
        forgotPassWordLabel.layer.shadowOpacity = 0.1
        
        signInView.layer.cornerRadius = signInView.frame.width/20
        signInView.layer.cornerRadius = signInView.frame.width/20
        signInView.layer.shadowRadius = 5
        signInView.layer.shadowColor = UIColor.black.cgColor
        signInView.layer.shadowOffset = CGSize (width: 10, height: 10)
        signInView.layer.shadowOpacity = 0.1
        signInView.layer.borderWidth = 2
        signInView.layer.borderColor = UIColor.white.cgColor
    }
    
    func setUpAction() {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAccount))
        self.signInView.addGestureRecognizer(gesture)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func checkAccount(sender : UITapGestureRecognizer) {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.clear)
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        FirebaseManager.shared.signIn(email: email, pass: password) {[weak self] (success, error) in
            guard let `self` = self else { return }
            var message: String = ""
            if (success) {
                if Auth.auth().currentUser != nil {
                    guard let uid = Auth.auth().currentUser?.uid else { return }
                    Database.database().reference().child("admin").child("allUser").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
                        guard let dict = snapshot.value as? [String: Any] else { return }
                        let user = CurrentUser (uid: uid, dictionary: dict)
                        if user.rule == "Admin" {
                            let vc = AdminHomeViewController()
                            self.navigationController?.pushViewController(vc, animated: true)
                            SVProgressHUD.dismiss()
                        }
                        if user.rule == "restaurant" {
                            let vc = HomeRestaurantViewController()
                            self.navigationController?.pushViewController(vc, animated: true)
                            SVProgressHUD.dismiss()
                        }
                        if user.rule == "user" {
                            let vc = UsersHomeViewController()
                            self.navigationController?.pushViewController(vc, animated: true)
                            SVProgressHUD.dismiss()
                        }
                    })
                }
            } else {
                guard let error = error else { return }
                message = "\(error.localizedDescription)"
                let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                SVProgressHUD.dismiss()
            }
        }
    }
    
    @IBAction func signUpAcction(_ sender: Any) {
        let vc = SignUpViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
