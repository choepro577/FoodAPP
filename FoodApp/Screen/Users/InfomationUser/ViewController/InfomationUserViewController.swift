//
//  InfomationUserViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/10/20.
//

import UIKit

class InfomationUserViewController: UIViewController {

    @IBOutlet weak var historyOrderView: UIView!
    @IBOutlet weak var signOutView: UIView!
    @IBOutlet weak var dissmissImageView: UIImageView!
    @IBOutlet weak var infoUserImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAction()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setUpAction() {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.backAction))
        dissmissImageView.isUserInteractionEnabled = true
        self.dissmissImageView.addGestureRecognizer(gesture)
        
        let infoUsergesture = UITapGestureRecognizer(target: self, action:  #selector(self.showInfoUser))
        infoUserImageView.isUserInteractionEnabled = true
        self.infoUserImageView.addGestureRecognizer(infoUsergesture)
        
        let signOutgesture = UITapGestureRecognizer(target: self, action:  #selector(self.signOut))
        self.signOutView.addGestureRecognizer(signOutgesture)
        
        let historyOrdergesture = UITapGestureRecognizer(target: self, action:  #selector(self.showHistoryOrder))
        self.historyOrderView.addGestureRecognizer(historyOrdergesture)
    }
    
    @objc func showHistoryOrder(sender : UITapGestureRecognizer) {
        let vc = HistoryOrderViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func signOut(sender : UITapGestureRecognizer) {
        let viewController = SignInViewController()
            let navCtrl = UINavigationController(rootViewController: viewController)
            guard let window = UIApplication.shared.keyWindow,
                let rootViewController = window.rootViewController
                    else {
                return
            }

            navCtrl.view.frame = rootViewController.view.frame
            navCtrl.view.layoutIfNeeded()

            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                window.rootViewController = navCtrl
            })
    }
    
    @objc func backAction(sender : UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func showInfoUser(sender : UITapGestureRecognizer) {
        
        let vc = DetailUserViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }


}
