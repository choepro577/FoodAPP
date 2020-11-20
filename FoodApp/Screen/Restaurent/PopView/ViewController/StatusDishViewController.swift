//
//  StatusDishViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/9/20.
//

import UIKit
import SVProgressHUD

class StatusDishViewController: UIViewController {
    
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var choseStatusDropDown: UIPickerView!
    
    var statusChoose: String?
    var nameDish: String?
    var nameDishDetail: String?
    
    let listChoose: [String] = ["Out of Food",
                                "still have food"]
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAction()
        setUpPickerView()
    }
    
    func setUpPickerView() {
        choseStatusDropDown.dataSource = self
        choseStatusDropDown.delegate = self
    }
    
    func setUpAction() {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.saveStatusAction))
        self.saveView.addGestureRecognizer(gesture)
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func saveStatusAction(sender : UITapGestureRecognizer) {
        SVProgressHUD.show()
        guard let nameDish = nameDish,
              let nameDishDetail = nameDishDetail,
              let statusChoose = statusChoose,
              !nameDish.isEmpty,
              !nameDishDetail.isEmpty,
              !statusChoose.isEmpty
        else {
            self.showAlert("Error", "Plese check your connect")
            SVProgressHUD.dismiss()
            return
        }
        
        FirebaseManager.shared.updateStatusDishDetail(nameDish: nameDish, nameDishDetail: nameDishDetail, status: statusChoose) { (success, error) in
            var message: String = ""
            if (success) {
                message = "Update successfully"
                SVProgressHUD.dismiss()
                self.showAlert("Notification", message)
            } else {
                guard let error = error else { return }
                message = "\(error.localizedDescription)"
            }
        }
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        statusChoose = listChoose[row]
    }
    
}
