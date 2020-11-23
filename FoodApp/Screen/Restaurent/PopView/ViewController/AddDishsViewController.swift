//
//  AddDishsViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/9/20.
//

import UIKit
import Kingfisher
import SVProgressHUD

class AddDishsViewController: UIViewController {
    
    @IBOutlet weak var dismissImageView: UIImageView!
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var priceDishTextField: UITextField!
    @IBOutlet weak var namDishDetailsTextField: UITextField!
    @IBOutlet weak var dishImageView: UIImageView!
    
    var nameImageCatagory: String?
    var urlImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAction()
    }
    
    func setUpAction() {
        let imageRestaurantGesture = UITapGestureRecognizer(target: self, action:  #selector(self.choseImage))
        dishImageView.isUserInteractionEnabled = true
        self.dishImageView.addGestureRecognizer(imageRestaurantGesture)
        
        let imageDismissRestaurantGesture = UITapGestureRecognizer(target: self, action:  #selector(self.dismissAction))
        dismissImageView.isUserInteractionEnabled = true
        self.dismissImageView.addGestureRecognizer(imageDismissRestaurantGesture)
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.saveDishAction))
        self.saveView.addGestureRecognizer(gesture)
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func dismissAction(sender : UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
    @objc func saveDishAction(sender : UITapGestureRecognizer) {
        guard let nameDishDetail = namDishDetailsTextField.text,
              let price = priceDishTextField.text,
              let nameImageCatagory = nameImageCatagory,
              !nameDishDetail.isEmpty,
              !price.isEmpty,
              !nameImageCatagory.isEmpty else {
            showAlert("Error", "Please enter your full infomation")
            return
        }
        
        guard let imageData = self.dishImageView.image?.pngData() else { return  }
        SVProgressHUD.show()
        FirebaseManager.shared.uploadImageDishDetail(imageData: imageData, typeImage: "imageDishDetails", nameImageCatagory: nameImageCatagory ){ (url, error) in
            self.urlImage = url
            print(url)
            guard let imageUrl = self.urlImage else { return }
            let resource = ImageResource(downloadURL: URL(string: imageUrl)!, cacheKey: imageUrl)
            self.dishImageView.kf.setImage(with: resource)
            SVProgressHUD.dismiss()
            if error == nil {
                FirebaseManager.shared.addDishDetail(nameDish: nameImageCatagory, imageLink: url, nameDishDetail: nameDishDetail, price: price) { (success, error) in
                    var message: String = ""
                    if (success) {
                        message = "added successfully"
                        SVProgressHUD.dismiss()
                        self.showAlert("Notification", message)
                    } else {
                        guard let error = error else { return }
                        message = "\(error.localizedDescription)"
                    }
                }
            }
        }
    }
}

extension AddDishsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func choseImage(sender : UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        
        DispatchQueue.main.async {
            self.dishImageView.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
