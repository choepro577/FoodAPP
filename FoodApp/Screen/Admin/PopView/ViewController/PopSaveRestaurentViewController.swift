//
//  PopSaveRestaurentViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/5/20.
//

import UIKit
import FirebaseStorage

class PopSaveRestaurentViewController: UIViewController {
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var dismissImageView: UIImageView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var titleRestaurentTextField: UITextField!
    @IBOutlet weak var nameRestaurantTextField: UITextField!
    @IBOutlet weak var saveView: UIView!
    
    
    
    private let storage = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAction()
        
        guard let urlString = UserDefaults.standard.value(forKey: "url") as? String,
              let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.restaurantImageView.image = image
            }
            
        })
        task.resume()
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
    
    @objc func dismiss(sender : UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
    @objc func saveRestaurentAction(sender : UITapGestureRecognizer) {
        guard let name = nameRestaurantTextField.text, let title = titleRestaurentTextField.text,  let address = addressTextField.text,!name.isEmpty, !title.isEmpty, !address.isEmpty else {
            showAlert("Error", "Please enter your full infomation")
            return
        }
        FirebaseManager.shared.addRestaurant(name: name, title: title, address: address, imageLink: "hongco") { (success, error)  in
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

extension PopSaveRestaurentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        
        storage.child("images/file.png").putData(imageData, metadata: nil, completion: { _, error in
            guard error == nil else {
                print("Failed to upload")
                return
            }
        })
        
        self.storage.child("images/file.png").downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                return
            }
            let urlString = url.absoluteString
            
            DispatchQueue.main.async {
                self.restaurantImageView.image = image
            }
            print("\(urlString)")
            UserDefaults.standard.set(urlString, forKey: "url")
        })
        
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

