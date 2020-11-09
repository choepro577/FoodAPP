//
//  StatusDishViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/9/20.
//

import UIKit

class StatusDishViewController: UIViewController {

    @IBOutlet weak var choseStatusDropDown: UIPickerView!
    
    let listChoose: [String] = ["Out of Food",
                                "still have food"]
    override func viewDidLoad() {
        super.viewDidLoad()
        choseStatusDropDown.dataSource = self
        choseStatusDropDown.delegate = self
    }

}

extension StatusDishViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        listChoose.count
    }

}

extension StatusDishViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listChoose[row]
    }
    
}
