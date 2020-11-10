//
//  InfomationUserViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/10/20.
//

import UIKit

class InfomationUserViewController: UIViewController {

    @IBOutlet weak var dissmissImageView: UIImageView!
    @IBOutlet weak var infoUserImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAction()
    }
    
    func setUpAction() {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.backAction))
        dissmissImageView.isUserInteractionEnabled = true
        self.dissmissImageView.addGestureRecognizer(gesture)
        
        let infoUsergesture = UITapGestureRecognizer(target: self, action:  #selector(self.showInfoUser))
        infoUserImageView.isUserInteractionEnabled = true
        self.infoUserImageView.addGestureRecognizer(infoUsergesture)
    }
    
    @objc func backAction(sender : UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func showInfoUser(sender : UITapGestureRecognizer) {
        
        let vc = DetailUserViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }


}
