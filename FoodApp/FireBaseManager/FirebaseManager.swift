//
//  FirebaseManager.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/10/20.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class FirebaseManager {
    
    public static let shared = FirebaseManager()
    
    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool, _ error: Error?, _ user: User?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if (authResult?.user) != nil {
                let user = authResult?.user
                completionBlock(true, error ?? nil, user)
            } else {
                let user = authResult?.user
                completionBlock(false, error ?? nil, user)
            }
        }
    }
    
    func signIn(email: String, pass: String, completionBlock: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                completionBlock(false, error )
            } else {
                completionBlock(true, error ?? nil)
            }
        }
    }
    
    func addRestaurant(name: String, title: String, address: String, imageLink: String, completionBlock: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let ref = Database.database().reference()
        guard let user = Auth.auth().currentUser else { return }
        let newUsersType = ref.child("admin").child("restaurant").child(user.uid)
        let addInfomationRestaurant = newUsersType.child("infomation")
        let object = ["name": name, "title": title, "addressLocation": address, "imageLink": imageLink] as [String:Any]
        addInfomationRestaurant.setValue(object, withCompletionBlock: { error, ref in
            if error == nil {
                completionBlock(true, nil)
            } else {
                completionBlock(false, error)
            }
        })
    }
    
    func getListRestaunt(completionBlock: @escaping (_ InfoRestaurent: [InfoRestaurant]) -> Void) {
        Database.database().reference().child("admin").child("restaurant").observe(DataEventType.value, with: { (usersSnapshot) in
            var listRestaurant: [InfoRestaurant] = [InfoRestaurant]()
            let userEnumerator = usersSnapshot.children
            while let users = userEnumerator.nextObject() as? DataSnapshot {
                let uid = users.key
                let todoEnumerator = users.children
                while let todoItem = todoEnumerator.nextObject() as? DataSnapshot {
                    print(todoItem)
                    guard let dict = todoItem.value as? [String: Any] else { return }
                    let user = InfoRestaurant(uid: uid, dictionary: dict)
                    listRestaurant.append(user)
                }
            }
            completionBlock(listRestaurant)
        })
    }
    
    func getImageFromFireBaseStorage(completionBlock: @escaping (_ urlImage: String) -> Void) {
        
        guard let user = Auth.auth().currentUser else { return }
        Storage.storage().reference().child("imageRestaurant").child(user.uid).child("file.png").downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                return
            }
            let urlImage = url.absoluteString
            completionBlock(urlImage)
            // UserDefaults.standard.set(urlString, forKey: "url")
        })
    }
    
    func uploadImagetoFireBaseStorage(imageData: Data, completionBlock: @escaping (_ urlImage: String) -> Void) {
        
        guard let user = Auth.auth().currentUser else { return }
        Storage.storage().reference().child("imageRestaurant").child(user.uid).child("file.png").putData(imageData, metadata: nil, completion: { _, error in
            if error == nil {
                var urlString: String?
                self.getImageFromFireBaseStorage() { (url) in
                    urlString = url
                    guard let urlString = urlString else { return }
                    let ref = Database.database().reference()
                    let newUsersType = ref.child("admin").child("restaurant").child(user.uid).child("infomation").child("imageLink")
                    newUsersType.setValue(urlString)
                    completionBlock(urlString)
                }
            }
        })
    }
    
}
