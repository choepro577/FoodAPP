//
//  FindRestaurentDishViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/10/20.
//

import UIKit

class FindRestaurentDishViewController: UIViewController {

    @IBOutlet weak var dishAndRestaurentSearchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dishAndRestaurentSearchBar.backgroundImage = UIImage()
    }

    @IBAction func cancelActionButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
