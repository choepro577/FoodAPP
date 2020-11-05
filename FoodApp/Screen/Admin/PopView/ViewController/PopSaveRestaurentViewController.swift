//
//  PopSaveRestaurentViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/5/20.
//

import UIKit

class PopSaveRestaurentViewController: UIViewController {

    @IBOutlet weak var saveView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    func setUpUI() {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.saveRestaurentAction))
        self.saveView.addGestureRecognizer(gesture)
    }
    
    @objc func saveRestaurentAction(sender : UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }

}
