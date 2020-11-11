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
    }
    
    func setUpAction() {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAccount))
        self.signInView.addGestureRecognizer(gesture)
    }
    
    @objc func checkAccount(sender : UITapGestureRecognizer) {
        SVProgressHUD.show()
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        FirebaseManager.shared.signIn(email: email, pass: password) {[weak self] (success, error) in
            guard let `self` = self else { return }
            var message: String = ""
            if (success) {
                if Auth.auth().currentUser != nil {
                    guard let uid = Auth.auth().currentUser?.uid else { return }
                    Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
                        guard let dict = snapshot.value as? [String: Any] else { return }
                        let user = CurrentUser (uid: uid, dictionary: dict)
                        if user.permission == "1" {
                            let vc = AdminHomeViewController()
                            self.navigationController?.pushViewController(vc, animated: true)
                            SVProgressHUD.dismiss()
                        }
                        if user.permission == "2" {
                            let vc = RestaurentHomeViewController()
                            self.navigationController?.pushViewController(vc, animated: true)
                            SVProgressHUD.dismiss()
                        }
                        if user.permission == "3" {
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
            }
        }
    }
    
    @IBAction func signUpAcction(_ sender: Any) {
        let vc = SignUpViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
