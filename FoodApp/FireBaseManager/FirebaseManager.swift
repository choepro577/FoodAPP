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

// MARK: FirebaseDatabase Update, Delete, Insert

class FirebaseManager {
    
    public static let shared = FirebaseManager()
    
    func addRestaurant(name: String, title: String, address: String, imageLink: String, typeRestaurantInput: String, completionBlock: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let ref = Database.database().reference()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child("admin").child("allUser").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
            let user = CurrentUser (uid: uid, dictionary: dict)
            let newUsersType = ref.child("admin").child("restaurant").child(typeRestaurantInput).child(uid).child("infomation").child(uid)
            let object = ["name": name, "title": title, "addressLocation": address, "imageLink": imageLink] as [String:Any]
            newUsersType.setValue(object, withCompletionBlock: { error, ref in
                if error == nil {
                    completionBlock(true, nil)
                    self.updateInfoUserTypeRestaurant(typeRestaurant: typeRestaurantInput) { (success, error) in
                        if error != nil {
                            return
                        } else {
                            self.deleteRestaurant(typeRestaurant: user.typeRestaurant, typeCheckRestaurant: typeRestaurantInput)
                        }
                    }
                } else {
                    completionBlock(false, error)
                }
            })
        })
    }
    
    func addCatagory(nameCatagory: String, imageLink: String, completionBlock: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        
        let ref = Database.database().reference().child("admin")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child("allUser").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
            let user = CurrentUser (uid: uid, dictionary: dict)
            let object = ["imagelink": imageLink] as [String:Any]
            ref.child("restaurant").child(user.typeRestaurant).child(uid).child("catagory").child("listDish").child(nameCatagory).setValue(object, withCompletionBlock: { error, ref in
                if error == nil {
                    completionBlock(true, nil)
                } else {
                    completionBlock(false, error)
                }
            })
        })
    }
    
    func deleteRestaurant(typeRestaurant: String, typeCheckRestaurant: String) {
        if typeRestaurant == typeCheckRestaurant {
            return
        } else {
            guard let user = Auth.auth().currentUser else { return }
            Database.database().reference().child("admin")
                .child("restaurant")
                .child(typeRestaurant)
                .child(user.uid).removeValue() { (error, _ ) in
                    if error == nil {
                        print("deleted")
                    }
                }
        }
    }
    
    func getListRestaunt(typeRestaurant: String, completionBlock: @escaping (_ infoRestaurent: [InfoRestaurant]) -> Void) {
        Database.database().reference().child("admin").child("restaurant").child(typeRestaurant).observe(DataEventType.value, with: { (usersSnapshot) in
            var listRestaurant: [InfoRestaurant] = [InfoRestaurant]()
            print(usersSnapshot)
            let userEnumerator = usersSnapshot.children
            while let users = userEnumerator.nextObject() as? DataSnapshot {
                let uid = users.key
                print(uid)
                let todoEnumerator = users.childSnapshot(forPath: "infomation").children
                print("sss\(users)")
                while let todoItem = todoEnumerator.nextObject() as? DataSnapshot {
                    print("todo item \(todoItem)")
                    guard let dict = todoItem.value as? [String: Any] else { return }
                    print(dict)
                    let user = InfoRestaurant(uid: uid, dictionary: dict)
                    listRestaurant.append(user)
                }
            }
            completionBlock(listRestaurant)
        })
    }
    
    func getListDishRestaurant(completionBlock: @escaping (_ infoRestaurent: [InfoDish]) -> Void){
        let ref = Database.database().reference().child("admin")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child("allUser").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
            let user = CurrentUser (uid: uid, dictionary: dict)
            ref.child("restaurant").child(user.typeRestaurant).observe(DataEventType.value, with: { (usersSnapshot) in
                var listDish: [InfoDish] = [InfoDish]()
                let userEnumerator = usersSnapshot.children
                print(usersSnapshot)
                while let users = userEnumerator.nextObject() as? DataSnapshot {
                    let todoEnumerator = users.childSnapshot(forPath: "catagory").children
                    print("user : \(users)")
                    while let todoItem = todoEnumerator.nextObject() as? DataSnapshot {
                        print("todo item \(todoItem)")
                        let todoEnumerator = todoItem.children
                        while let todoItem = todoEnumerator.nextObject() as? DataSnapshot {
                            let nameDish = todoItem.key
                            print("name dish la : \(nameDish)")
                            print("imagelink : \(todoItem)")
                            guard let dict = todoItem.value as? [String: Any] else { return }
                            print("dict : \(dict)")
                            let user = InfoDish(nameDish: nameDish, dictionary: dict)
                            print(user)
                            listDish.append(user)
                           
                        }
                    }
                }
               
                completionBlock(listDish)
            })
        })
    }
    
    func checkTypeRestaurant (completionBlock: @escaping (_ typeRestaurant: String) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("admin").child("allUser").child(uid).observe(DataEventType.value, with: {(snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
            let user = CurrentUser (uid: uid, dictionary: dict)
            completionBlock(user.typeRestaurant)
        })
    }
    
    func getInfoRestaurant(completionBlock: @escaping (_ infoRestaurent: InfoRestaurant) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        self.checkTypeRestaurant() { (typeRestaurant) in
            Database.database().reference().child("admin").child("restaurant").child(typeRestaurant).child(user.uid).child("infomation").child(user.uid).observe(DataEventType.value, with: {(snapshot) in
                guard let dict = snapshot.value as? [String: Any] else { return }
                let info = InfoRestaurant(uid: user.uid, dictionary: dict)
                completionBlock(info)
            })
        }
    }
    
    func updateInfoUserTypeRestaurant(typeRestaurant: String, completionBlock: @escaping (_ success: Bool, _ error: Error?) -> Void ) {
        guard let user = Auth.auth().currentUser else { return }
        let object = ["typeRestaurant": typeRestaurant] as [String:Any]
        Database.database().reference().child("admin").child("allUser").child(user.uid).updateChildValues(object, withCompletionBlock: { error, ref in
            if error == nil {
                completionBlock(true, nil)
            } else {
                completionBlock(false, error)
            }
        })
    }
    
}

// MARK: FirebaseAuth
extension FirebaseManager {
    
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
    
}

// MARK: FirebaseStorage
extension FirebaseManager {
    
    func getImageURLFromFireBaseStorage(typeImage: String, completionBlock: @escaping (_ urlImage: String) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        Storage.storage().reference().child("imageRestaurant").child(user.uid).child(typeImage).child("file.png").downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                return
            }
            let urlImage = url.absoluteString
            completionBlock(urlImage)
            // UserDefaults.standard.set(urlString, forKey: "url")
        })
    }
    
    func uploadImagetoFireBaseStorage(imageData: Data, typeImage: String, completionBlock: @escaping (_ urlImage: String) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        Storage.storage().reference().child("imageRestaurant").child(user.uid).child(typeImage).child("file.png").putData(imageData, metadata: nil, completion: { _, error in
            if error == nil {
                var urlString: String?
                self.getImageURLFromFireBaseStorage(typeImage: typeImage) { (url) in
                    urlString = url
                    guard let urlString = urlString else { return }
                    completionBlock(urlString)
                }
            }
        })
    }
    
}
