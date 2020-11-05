//
//  PopAddPromoViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/5/20.
//

import UIKit

class PopAddPromoViewController: UIViewController {

    @IBOutlet weak var addPromoView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }


    func setUpUI() {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.saveRestaurentAction))
        self.addPromoView.addGestureRecognizer(gesture)
    }
    
    @objc func saveRestaurentAction(sender : UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }

}
