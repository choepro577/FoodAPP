//
//  AddCatagoryViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/7/20.
//

import UIKit

class AddCatagoryViewController: UIViewController {

    @IBOutlet weak var saveCatagoryView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    func setUpUI() {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.saveRestaurentAction))
        self.saveCatagoryView.addGestureRecognizer(gesture)
    }
    
    @objc func saveRestaurentAction(sender : UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }

}
