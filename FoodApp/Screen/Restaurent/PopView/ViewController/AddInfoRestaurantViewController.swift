//
//  AddInfoRestaurantViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/17/20.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import Kingfisher
import SVProgressHUD

class AddInfoRestaurantViewController: UIViewController {
    
    @IBOutlet weak var dismissImageView: UIImageView!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveView: UIView!
    
    var urlImage: String?
    
    private let storage = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAction()
    }
    
    func setUpAction() {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.saveRestaurentAction))
        self.saveView.addGestureRecognizer(gesture)
        
        let imageDismissGesture = UITapGestureRecognizer(target: self, action:  #selector(self.dismiss))
        dismissImageView.isUserInteractionEnabled = true
        self.dismissImageView.addGestureRecognizer(imageDismissGesture)
        
        let imageRestaurantGesture = UITapGestureRecognizer(target: self, action:  #selector(self.choseImage))
        restaurantImageView.isUserInteractionEnabled = true
        self.restaurantImageView.addGestureRecognizer(imageRestaurantGesture)
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func saveRestaurentAction(sender : UITapGestureRecognizer) {
        guard let name = nameTextField.text, let title = titleTextField.text,  let address = addressTextField.text, let imageLink = urlImage, !name.isEmpty, !title.isEmpty, !address.isEmpty, !imageLink.isEmpty else {
            showAlert("Error", "Please enter your full infomation")
            return
        }
        FirebaseManager.shared.addRestaurant(name: name, title: title, address: address, imageLink: imageLink) { (success, error)  in
            var message: String = ""
            if (success) {
                message = "added successfully"
                self.showAlert("Notification", message)
            } else {
                guard let error = error else { return }
                message = "\(error.localizedDescription)"
            }
        }
    }
}

extension AddInfoRestaurantViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func choseImage(sender : UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        
        guard let imageData = image.pngData() else { return  }
        
        FirebaseManager.shared.uploadImagetoFireBaseStorage(imageData: imageData) { (url) in
            self.urlImage = url
            print(url)
            guard let urlImage = self.urlImage else { return }
            let resource = ImageResource(downloadURL: URL(string: urlImage)!, cacheKey: urlImage)
            self.restaurantImageView.kf.setImage(with: resource)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
