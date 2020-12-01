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
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var typeRestaurantTextField: UITextField!
    @IBOutlet weak var dismissImageView: UIImageView!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveView: UIView!
    
    var pickerView = UIPickerView()
    let listChooserule: [String] = ["rice restaurant", "milk tea", "noodles", "fried chicken", "healthy", "snacks"]
    var urlImage: String?
    var listRestaurant: InfoRestaurant?
    
    private let storage = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAction()
        getInfoRestaurant()
        setUpPickerView()
        setUpUI()
    }
    
    func setUpUI() {
        mainView.layer.cornerRadius = mainView.frame.width/20
        
        restaurantImageView.layer.cornerRadius = mainView.frame.width/20
        
        saveView.layer.cornerRadius = saveView.frame.width/20
        saveView.layer.shadowRadius = 5
        saveView.layer.shadowColor = UIColor.black.cgColor
        saveView.layer.shadowOffset = CGSize (width: 10, height: 10)
        saveView.layer.shadowOpacity = 0.1
        saveView.layer.borderWidth = 2
        saveView.layer.borderColor = UIColor.white.cgColor
    }
    
    func setUpPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        
        typeRestaurantTextField.inputView = pickerView
        typeRestaurantTextField.placeholder = "Select rule"
        typeRestaurantTextField.textAlignment = .center
    }
    
    func setUpAction() {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.saveRestaurentAction))
        self.saveView.addGestureRecognizer(gesture)
        
        let imageDismissGesture = UITapGestureRecognizer(target: self, action:  #selector(self.dismissAction))
        dismissImageView.isUserInteractionEnabled = true
        self.dismissImageView.addGestureRecognizer(imageDismissGesture)
        
        let imageRestaurantGesture = UITapGestureRecognizer(target: self, action:  #selector(self.choseImage))
        restaurantImageView.isUserInteractionEnabled = true
        self.restaurantImageView.addGestureRecognizer(imageRestaurantGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIWindow.keyboardWillHideNotification, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let emp =  (self.view.frame.size.height - 500) / 3
              if self.view.frame.origin.y == 0 {
                  self.view.frame.origin.y -= (keyboardSize.height - emp)
              }
         }
     }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let emp =  (self.view.frame.size.height - 500) / 3
            if self.view.frame.origin.y != 0 {
                  self.view.frame.origin.y += (keyboardSize.height + emp)
              }
         }
     }
    
    @objc func dismissAction(sender : UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
    func getInfoRestaurant() {
        FirebaseManager.shared.getInfoRestaurant() { (infoResutl) in
            self.listRestaurant = infoResutl
            guard let listRestaurant = self.listRestaurant else { return }
            let resource = ImageResource(downloadURL: URL(string: listRestaurant.imageLink)!, cacheKey: listRestaurant.imageLink)
            self.restaurantImageView.kf.setImage(with: resource)
            self.urlImage = listRestaurant.imageLink
        }
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func saveRestaurentAction(sender : UITapGestureRecognizer) {
        guard let name = nameTextField.text,
              let title = titleTextField.text,
              let address = addressTextField.text,
              let typeRestaurant = typeRestaurantTextField.text?.removeWhitespace(),
              !name.isEmpty,
              !title.isEmpty,
              !address.isEmpty,
              !typeRestaurant.isEmpty else {
            showAlert("Error", "Please enter your full infomation")
            return
        }
        
        guard let imageData = self.restaurantImageView.image?.pngData() else { return  }
        SVProgressHUD.show()
        FirebaseManager.shared.uploadImagetoFireBaseStorage(imageData: imageData, typeImage: "avataRestaurant") { (url, error) in
            self.urlImage = url
            print(url)
            guard let imageUrl = self.urlImage else { return }
            let resource = ImageResource(downloadURL: URL(string: imageUrl)!, cacheKey: imageUrl)
            self.restaurantImageView.kf.setImage(with: resource)
            SVProgressHUD.dismiss()
            if error == nil {
                FirebaseManager.shared.addRestaurant(name: name, title: title, address: address, imageLink: url, typeRestaurantInput: typeRestaurant) { (success, error)  in
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
        
        DispatchQueue.main.async {
            self.restaurantImageView.image = image
        }
        
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension AddInfoRestaurantViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        listChooserule.count
    }
    
}

extension AddInfoRestaurantViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listChooserule[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeRestaurantTextField.text = listChooserule[row]
        typeRestaurantTextField.resignFirstResponder()
    }
    
}
