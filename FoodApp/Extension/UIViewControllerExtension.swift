//
//  UIViewControllerExtension.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/23/20.
//

import Foundation

extension UIAlertAction {
    func showAlert(_ title: String, _ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
