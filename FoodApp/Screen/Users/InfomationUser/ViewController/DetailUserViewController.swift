//
//  DetailUserViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/10/20.
//

import UIKit

class DetailUserViewController: UIViewController {

    @IBOutlet weak var dissmissImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAction()
    }

    func setUpAction() {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.backAction))
        dissmissImageView.isUserInteractionEnabled = true
        self.dissmissImageView.addGestureRecognizer(gesture)
    }
    
    @objc func backAction(sender : UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }

}
