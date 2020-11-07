//
//  SignInViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/4/20.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var forgotPassWordLabel: UILabel!
    @IBOutlet weak var signInView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    func setUpUI() {
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: "Forgot your password?", attributes: underlineAttribute)
        forgotPassWordLabel.attributedText = underlineAttributedString
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAccount))
        self.signInView.addGestureRecognizer(gesture)
    }
    
    @objc func checkAccount(sender : UITapGestureRecognizer) {
        let vc = RestaurentHomeViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signUpAcction(_ sender: Any) {
        let vc = SignUpViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
