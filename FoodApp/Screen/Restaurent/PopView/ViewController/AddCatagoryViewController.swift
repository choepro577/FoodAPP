//
//  AddCatagoryViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/7/20.
//

import UIKit
import SVProgressHUD
import Kingfisher

class AddCatagoryViewController: UIViewController {
    
    @IBOutlet weak var catagoryImageView: UIImageView!
    @IBOutlet weak var catagoryTextField: UITextField!
    @IBOutlet weak var saveCatagoryView: UIView!
    
    var urlImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    func setUpUI() {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.saveRestaurentAction))
        self.saveCatagoryView.addGestureRecognizer(gesture)
        
        let imageRestaurantGesture = UITapGestureRecognizer(target: self, action:  #selector(self.choseImage))
        catagoryImageView.isUserInteractionEnabled = true
        self.catagoryImageView.addGestureRecognizer(imageRestaurantGesture)
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func saveRestaurentAction(sender : UITapGestureRecognizer) {
        
        guard let name = catagoryTextField.text,
              let imageLink = urlImage,
              !name.isEmpty,
              !imageLink.isEmpty
        else {
            self.showAlert("Error", "Please enter your full infomation")
            return
        }
        
        FirebaseManager.shared.addCatagory(nameCatagory: name, imageLink: imageLink) { (success,error) in
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

extension AddCatagoryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        SVProgressHUD.show()
        FirebaseManager.shared.uploadImagetoFireBaseStorage(imageData: imageData, typeImage: "imageCatagory") { (url) in
            self.urlImage = url
            print(url)
            guard let imageUrl = self.urlImage else { return }
            let resource = ImageResource(downloadURL: URL(string: imageUrl)!, cacheKey: imageUrl)
            self.catagoryImageView.kf.setImage(with: resource)
            SVProgressHUD.dismiss()
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
