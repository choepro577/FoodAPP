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
    
    @IBOutlet weak var addCatagoryScrollView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var dismissImageView: UIImageView!
    @IBOutlet weak var catagoryImageView: UIImageView!
    @IBOutlet weak var catagoryTextField: UITextField!
    @IBOutlet weak var saveCatagoryView: UIView!
    
    var urlImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAction()
        setUpUI()
    }
    
    func setUpUI() {
        mainView.layer.cornerRadius = mainView.frame.width/20
        
        catagoryImageView.layer.cornerRadius = mainView.frame.width/20
        
        saveCatagoryView.layer.cornerRadius = saveCatagoryView.frame.width/20
        saveCatagoryView.layer.shadowRadius = 5
        saveCatagoryView.layer.shadowColor = UIColor.black.cgColor
        saveCatagoryView.layer.shadowOffset = CGSize (width: 10, height: 10)
        saveCatagoryView.layer.shadowOpacity = 0.1
        saveCatagoryView.layer.borderWidth = 2
        saveCatagoryView.layer.borderColor = UIColor.white.cgColor
    }
    
    func setUpAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIWindow.keyboardWillHideNotification, object: nil)
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.saveRestaurentAction))
        self.saveCatagoryView.addGestureRecognizer(gesture)
        
        let imageRestaurantGesture = UITapGestureRecognizer(target: self, action:  #selector(self.choseImage))
        catagoryImageView.isUserInteractionEnabled = true
        self.catagoryImageView.addGestureRecognizer(imageRestaurantGesture)
        
        let imageDismissRestaurantGesture = UITapGestureRecognizer(target: self, action:  #selector(self.dismissAction))
        dismissImageView.isUserInteractionEnabled = true
        self.dismissImageView.addGestureRecognizer(imageDismissRestaurantGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {

        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.addCatagoryScrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height - 150
        addCatagoryScrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        addCatagoryScrollView.contentInset = contentInset
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) -> Void in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func dismissAction(sender : UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
    @objc func saveRestaurentAction(sender : UITapGestureRecognizer) {
        
        guard let name = catagoryTextField.text,
              !name.isEmpty
        else {
            self.showAlert("Error", "Please enter your full infomation")
            return
        }
        
        guard let imageData = self.catagoryImageView.image?.pngData() else { return  }
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.clear)
        FirebaseManager.shared.uploadImageDish(imageData: imageData, typeImage: "imageCatagory", nameImageCatagory: name) { (url, error) in
            self.urlImage = url
            print(url)
            guard let imageUrl = self.urlImage else { return }
            let resource = ImageResource(downloadURL: URL(string: imageUrl)!, cacheKey: imageUrl)
            self.catagoryImageView.kf.setImage(with: resource)
            SVProgressHUD.dismiss()
            if error == nil {
                FirebaseManager.shared.addCatagory(nameCatagory: name, imageLink: url) { (success, error)  in
                    var message: String = ""
                    if (success) {
                        message = "added successfully"
                        SVProgressHUD.dismiss()
                        self.showAlert("Notification", message)
                    } else {
                        SVProgressHUD.dismiss()
                        guard let error = error else { return }
                        message = "\(error.localizedDescription)"
                    }
                }
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
        
        DispatchQueue.main.async {
            self.catagoryImageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
