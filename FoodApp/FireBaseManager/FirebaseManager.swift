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
            let newUsersType = ref
                .child("admin")
                .child("restaurant")
                .child(typeRestaurantInput)
                .child(uid)
                .child("allInfoRestaurant")
                .child("infomation")
                .child(uid)
            let object = ["name": name, "title": title, "addressLocation": address, "imageLink": imageLink] as [String:Any]
            newUsersType.setValue(object, withCompletionBlock: { error, ref in
                if error == nil {
                    completionBlock(true, nil)
                    self.updateInfoUserTypeRestaurant(typeRestaurant: typeRestaurantInput) { (success, error) in
                        if error != nil {
                            return
                        } else {
                            self.autoDeletetheSameRestaurant(typeRestaurant: user.typeRestaurant, typeCheckRestaurant: typeRestaurantInput)
                        }
                    }
                } else {
                    completionBlock(false, error)
                }
            })
        })
    }
    
    func addToCard(uidRestaurant: String, nameDish: String, totalPrice: Int, count: Int, note: String, completionBlock: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference()
        ref.child("admin").child("allUser").child(uidRestaurant).observeSingleEvent(of: .value, with: {(snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
            let userRestaurant = CurrentUser (uid: uidRestaurant, dictionary: dict)
            let object = ["count": count, "totalPrice": totalPrice, "note": note] as [String:Any]
            ref.child("admin")
                .child("restaurant")
                .child(userRestaurant.typeRestaurant)
                .child(uidRestaurant)
                .child("allInfoRestaurant")
                .child("CARD")
                .child(uid)
                .child("listDish")
                .child(nameDish)
                .setValue(object, withCompletionBlock: { error, ref in
                    if error == nil {
                        completionBlock(true, nil)
                    } else {
                        completionBlock(false, error)
                    }
                })
        })
    }
    
    func orderRestaurant(uidRestaurant: String, status: String, address: String, totalPrice: Int, completionBlock: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference()
        ref.child("admin").child("allUser").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
            let user = CurrentUser (uid: uidRestaurant, dictionary: dict)
            ref.child("admin").child("allUser").child(uidRestaurant).observeSingleEvent(of: .value, with: {(snapshot) in
                guard let dict = snapshot.value as? [String: Any] else { return }
                let userRestaurant = CurrentUser (uid: uidRestaurant, dictionary: dict)
                let object = ["status": status, "address": address, "phoneNumber": user.phoneNumber , "totalPrice": totalPrice, "name": user.name] as [String:Any]
                ref.child("admin")
                    .child("restaurant")
                    .child(userRestaurant.typeRestaurant)
                    .child(uidRestaurant)
                    .child("allInfoRestaurant")
                    .child("CARD")
                    .child(uid)
                    .child("status")
                    .child(uid)
                    .setValue(object, withCompletionBlock: { error, ref in
                        if error == nil {
                            completionBlock(true, nil)
                        } else {
                            completionBlock(false, error)
                        }
                    })
            })
        })
    }
    
    func deleteDishChoosed(uidRestaurant: String, nameDish: String, completionBlock: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference()
        ref.child("admin").child("allUser").child(uidRestaurant).observeSingleEvent(of: .value, with: {(snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
            let userRestaurant = CurrentUser (uid: uidRestaurant, dictionary: dict)
            ref.child("admin")
                .child("restaurant")
                .child(userRestaurant.typeRestaurant)
                .child(uidRestaurant)
                .child("allInfoRestaurant")
                .child("CARD")
                .child(uid)
                .child("listDish")
                .child(nameDish)
                .removeValue() { (error, _ ) in
                    if error == nil {
                        completionBlock(true, error)
                    }
                }
        })
    }

    
    func addCatagory(nameCatagory: String, imageLink: String, completionBlock: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let ref = Database.database().reference().child("admin")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child("allUser").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
            let user = CurrentUser (uid: uid, dictionary: dict)
            let object = ["imagelink": imageLink] as [String:Any]
            ref.child("restaurant").child(user.typeRestaurant).child(uid).child("allInfoRestaurant").child("catagory").child("listDish").child(nameCatagory).setValue(object, withCompletionBlock: { error, ref in
                if error == nil {
                    completionBlock(true, nil)
                } else {
                    completionBlock(false, error)
                }
            })
        })
    }
    
    func addDishDetail(nameDish: String, imageLink: String, nameDishDetail: String, price: String, completionBlock: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let ref = Database.database().reference().child("admin")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child("allUser").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
            let user = CurrentUser (uid: uid, dictionary: dict)
            let object = ["imagelink": imageLink, "price": price, "status": "still have food"] as [String:Any]
            ref.child("restaurant")
                .child(user.typeRestaurant)
                .child(uid)
                .child("allInfoRestaurant")
                .child("catagory")
                .child("listDish")
                .child(nameDish)
                .child("detailDish")
                .child(nameDishDetail)
                .setValue(object, withCompletionBlock: { error, ref in
                    if error == nil {
                        completionBlock(true, nil)
                    } else {
                        completionBlock(false, error)
                    }
                })
        })
    }
    
    func addPromo(uid: String, namePromo: String, codePromo: String, discount: Int, condition: Int, completionBlock: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let ref = Database.database().reference().child("admin")
        ref.child("allUser").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
            let user = CurrentUser (uid: uid, dictionary: dict)
            let object = ["namePromo": namePromo, "discount": discount, "condition": condition] as [String:Any]
            ref.child("restaurant").child(user.typeRestaurant).child(uid).child("allInfoRestaurant").child("sale").child("listPromo").child(codePromo).setValue(object, withCompletionBlock: { error, ref in
                if error == nil {
                    completionBlock(true, nil)
                } else {
                    completionBlock(false, error)
                }
            })
        })
    }
    
    func getListRestaunt(typeRestaurant: String, completionBlock: @escaping (_ infoRestaurent: [InfoRestaurant]) -> Void) {
        Database.database().reference().child("admin").child("restaurant").child(typeRestaurant).observe(DataEventType.value, with: { (usersSnapshot) in
            var listRestaurant: [InfoRestaurant] = [InfoRestaurant]()
            let userEnumerator = usersSnapshot.children
            while let users = userEnumerator.nextObject() as? DataSnapshot {
                let uid = users.key
                let todoEnumerator = users.childSnapshot(forPath: "allInfoRestaurant").childSnapshot(forPath: "infomation").children
                while let todoItem = todoEnumerator.nextObject() as? DataSnapshot {
                    guard let dict = todoItem.value as? [String: Any] else { return }
                    let user = InfoRestaurant(uid: uid, dictionary: dict)
                    listRestaurant.append(user)
                }
            }
            completionBlock(listRestaurant)
        })
    }
    
    
    func getInfoCard(uidRestaurant: String, completionBlock: @escaping (_ countDish: Int, _ totalPrice: Int, _ listInfoCart: [InfoCard]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference()
        ref.child("admin").child("allUser").child(uidRestaurant).observeSingleEvent(of: .value, with: {(snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
            let userRestaurant = CurrentUser (uid: uidRestaurant, dictionary: dict)
            ref.child("admin")
                .child("restaurant")
                .child(userRestaurant.typeRestaurant)
                .child(uidRestaurant)
                .child("allInfoRestaurant")
                .child("CARD")
                .child(uid)
                .child("listDish")
                .observe(DataEventType.value, with: { (usersSnapshot) in
                    var countDish: Int = 0
                    var totalPrice: Int = 0
                    var listInfoCart: [InfoCard] = [InfoCard]()
                    let userEnumerator = usersSnapshot.children
                    while let users = userEnumerator.nextObject() as? DataSnapshot {
                        let nameDish = users.key
                        guard let dict = users.value as? [String: Any] else { return }
                        let user = InfoCard(nameDish: nameDish, dictionary: dict)
                        listInfoCart.append(user)
                        countDish += user.count
                        totalPrice += user.totalPrice
                    }
                    completionBlock(countDish, totalPrice, listInfoCart)
                })
        })
    }
    
    func getInfoDishDetailCard(uidRestaurant: String, nameDish:String, completionBlock: @escaping (_ infoCard: InfoCard) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference()
        ref.child("admin").child("allUser").child(uidRestaurant).observeSingleEvent(of: .value, with: {(snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
            let userRestaurant = CurrentUser (uid: uidRestaurant, dictionary: dict)
            print(userRestaurant.typeRestaurant)
            print(uid)
            print(uidRestaurant)
            ref.child("admin")
                .child("restaurant")
                .child(userRestaurant.typeRestaurant)
                .child(uidRestaurant)
                .child("allInfoRestaurant")
                .child("CARD")
                .child(uid)
                .child("listDish")
                .child(nameDish)
                .observe(DataEventType.value, with: { (usersSnapshot) in
                    guard let dict = usersSnapshot.value as? [String: Any] else { return }
                    let infoCard = InfoCard(nameDish: nameDish, dictionary: dict)
                    completionBlock(infoCard)
                })
        })
    }
    
    func getlistOrder(completionBlock: @escaping (_ infoCard: [InfoOrderofUser]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference()
        ref.child("admin").child("allUser").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
            let userRestaurant = CurrentUser (uid: uid, dictionary: dict)
            ref.child("admin")
                .child("restaurant")
                .child(userRestaurant.typeRestaurant)
                .child(uid)
                .child("allInfoRestaurant")
                .child("CARD")
                .observe(DataEventType.value, with: { (usersSnapshot) in
                    var listOrder: [InfoOrderofUser] = [InfoOrderofUser]()
                    print(usersSnapshot)
                    let userEnumerator = usersSnapshot.children
                    while let users = userEnumerator.nextObject() as? DataSnapshot {
                        let todoEnumerator = users.childSnapshot(forPath: "status").children
                        while let todoItem = todoEnumerator.nextObject() as? DataSnapshot {
                                let id = todoItem.key
                                guard let dict = todoItem.value as? [String: Any] else { return }
                                let user = InfoOrderofUser(id: id, dictionary: dict)
                            listOrder.append(user)
                        }
                    }
                    completionBlock(listOrder)
                })
        })
    }
    
    func getInfoOrder(uidRestaurant: String, completionBlock: @escaping (_ infoOrder: InfoOrderofUser) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference()
        ref.child("admin").child("allUser").child(uidRestaurant).observeSingleEvent(of: .value, with: {(snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
            let userRestaurant = CurrentUser (uid: uidRestaurant, dictionary: dict)
            ref.child("admin")
                .child("restaurant")
                .child(userRestaurant.typeRestaurant)
                .child(uidRestaurant)
                .child("allInfoRestaurant")
                .child("CARD")
                .child(uid)
                .child("status")
                .child(uid)
                .observe(DataEventType.value, with: { (usersSnapshot) in
                    guard let dict = usersSnapshot.value as? [String: Any] else { return }
                    let infoCart = InfoOrderofUser(id: uid, dictionary: dict)
                    completionBlock(infoCart)
                })
        })
    }
    
    func getListDishRestaurant(completionBlock: @escaping (_ infoRestaurent: [InfoDish]) -> Void) {
        let ref = Database.database().reference().child("admin")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child("allUser").child(uid).observe(DataEventType.value, with: {(snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
            let user = CurrentUser (uid: uid, dictionary: dict)
            ref.child("restaurant").child(user.typeRestaurant).observe(DataEventType.value, with: { (usersSnapshot) in
                var listDish: [InfoDish] = [InfoDish]()
                let userEnumerator = usersSnapshot.childSnapshot(forPath: uid).children
                while let users = userEnumerator.nextObject() as? DataSnapshot {
                    let todoEnumerator = users.childSnapshot(forPath: "catagory").children
                    while let todoItem = todoEnumerator.nextObject() as? DataSnapshot {
                        let todoEnumerator = todoItem.children
                        while let todoItem = todoEnumerator.nextObject() as? DataSnapshot {
                            let nameDish = todoItem.key
                            guard let dict = todoItem.value as? [String: Any] else { return }
                            let user = InfoDish(nameDish: nameDish, dictionary: dict)
                            listDish.append(user)
                        }
                    }
                }
                completionBlock(listDish)
            })
        })
    }
    
    func getListDishDetails(nameDish: String, completionBlock: @escaping (_ InfoDishDetail: [InfoDishDetail]) -> Void) {
        let ref = Database.database().reference().child("admin")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child("allUser").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
            let user = CurrentUser (uid: uid, dictionary: dict)
            ref.child("restaurant").child(user.typeRestaurant).observe(DataEventType.value, with: { (usersSnapshot) in
                var listDishDetail: [InfoDishDetail] = [InfoDishDetail]()
                let userEnumerator = usersSnapshot.childSnapshot(forPath: uid).children
                while let users = userEnumerator.nextObject() as? DataSnapshot {
                    let todoEnumerator = users.childSnapshot(forPath: "catagory").children
                    while let todoItem = todoEnumerator.nextObject() as? DataSnapshot {
                        print("list dish \(todoItem)")
                        let todoEnumerator = todoItem.childSnapshot(forPath: nameDish).childSnapshot(forPath: "detailDish").children
                        while let todoItem = todoEnumerator.nextObject() as? DataSnapshot {
                            print("-----------\(todoItem)")
                            let nameDishDetail = todoItem.key
                            guard let dict = todoItem.value as? [String: Any] else { return }
                            let user = InfoDishDetail(nameDishDetail: nameDishDetail, dictionary: dict)
                            listDishDetail.append(user)
                        }
                    }
                }
                completionBlock(listDishDetail)
            })
        })
    }
    
    func getListPromoRestaurant(uid: String, completionBlock: @escaping (_ infoPromoRestaurent: [InfoPromo]) -> Void) {
        let ref = Database.database().reference().child("admin")
        ref.child("allUser").child(uid).observe(DataEventType.value, with: {(snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
            let user = CurrentUser (uid: uid, dictionary: dict)
            ref.child("restaurant").child(user.typeRestaurant).observe(DataEventType.value, with: { (usersSnapshot) in
                var listPromo: [InfoPromo] = [InfoPromo]()
                let userEnumerator = usersSnapshot.childSnapshot(forPath: uid).children
                while let users = userEnumerator.nextObject() as? DataSnapshot {
                    let todoEnumerator = users.childSnapshot(forPath: "sale").children
                    while let todoItem = todoEnumerator.nextObject() as? DataSnapshot {
                        let todoEnumerator = todoItem.children
                        while let todoItem = todoEnumerator.nextObject() as? DataSnapshot {
                            let codePromo = todoItem.key
                            guard let dict = todoItem.value as? [String: Any] else { return }
                            let user = InfoPromo(codePromo: codePromo, dictionary: dict)
                            listPromo.append(user)
                        }
                    }
                }
                completionBlock(listPromo)
            })
        })
    }
    
    func getListDishRestaurantForUser(uid: String, completionBlock: @escaping (_ infoDish: [InfoDish], _ infoDishDetail: [[InfoDishDetail]]) -> Void) {
        let ref = Database.database().reference().child("admin")
        ref.child("allUser").child(uid).observe(DataEventType.value, with: {(snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
            let user = CurrentUser (uid: uid, dictionary: dict)
            ref.child("restaurant").child(user.typeRestaurant).observe(DataEventType.value, with: { (usersSnapshot) in
                var listDish: [InfoDish] = [InfoDish]()
                var listDishDetails: [[InfoDishDetail]] = [[InfoDishDetail]]()
                let userEnumerator = usersSnapshot.childSnapshot(forPath: uid).children
                while let users = userEnumerator.nextObject() as? DataSnapshot {
                    let todoEnumerator = users.childSnapshot(forPath: "catagory").children
                    while let todoItem = todoEnumerator.nextObject() as? DataSnapshot {
                        let todoEnumerator = todoItem.children
                        while let todoItem = todoEnumerator.nextObject() as? DataSnapshot {
                            let nameDish = todoItem.key
                            guard let dict = todoItem.value as? [String: Any] else { return }
                            let user = InfoDish(nameDish: nameDish, dictionary: dict)
                            listDish.append(user)
                            let todoEnumerator = todoItem.childSnapshot(forPath: "detailDish").children
                            var listDishDetail: [InfoDishDetail] = [InfoDishDetail]()
                            while let todoItem = todoEnumerator.nextObject() as? DataSnapshot {
                                let nameDishDetail = todoItem.key
                                guard let dict = todoItem.value as? [String: Any] else { return }
                                let user = InfoDishDetail(nameDishDetail: nameDishDetail, dictionary: dict)
                                listDishDetail.append(user)
                            }
                            listDishDetails.append(listDishDetail)
                        }
                    }
                }
                completionBlock(listDish, listDishDetails)
            })
        })
    }
    
    func checkTypeRestaurant (completionBlock: @escaping (_ typeRestaurant: String) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference()
            .child("admin")
            .child("allUser")
            .child(uid)
            .observe(DataEventType.value, with: {(snapshot) in
                guard let dict = snapshot.value as? [String: Any] else { return }
                let user = CurrentUser (uid: uid, dictionary: dict)
                completionBlock(user.typeRestaurant)
            })
    }
    
    func getInfoRestaurant(completionBlock: @escaping (_ infoRestaurent: InfoRestaurant) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        self.checkTypeRestaurant() { (typeRestaurant) in
            Database.database().reference()
                .child("admin")
                .child("restaurant")
                .child(typeRestaurant)
                .child(user.uid)
                .child("allInfoRestaurant")
                .child("infomation")
                .child(user.uid).observe(DataEventType.value, with: {(snapshot) in
                    guard let dict = snapshot.value as? [String: Any] else { return }
                    let info = InfoRestaurant(uid: user.uid, dictionary: dict)
                    completionBlock(info)
                })
        }
    }
    
    
    func updateInfoUserTypeRestaurant(typeRestaurant: String, completionBlock: @escaping (_ success: Bool, _ error: Error?) -> Void ) {
        guard let user = Auth.auth().currentUser else { return }
        let object = ["typeRestaurant": typeRestaurant] as [String:Any]
        Database.database().reference()
            .child("admin")
            .child("allUser")
            .child(user.uid)
            .updateChildValues(object, withCompletionBlock: { error, ref in
                if error == nil {
                    completionBlock(true, nil)
                } else {
                    completionBlock(false, error)
                }
            })
    }
    
    func updateStatusDishDetail(nameDish: String, nameDishDetail: String, status: String, completionBlock: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let ref = Database.database().reference().child("admin")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child("allUser").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
            let user = CurrentUser (uid: uid, dictionary: dict)
            let object = ["status": status] as [String:Any]
            ref.child("restaurant")
                .child(user.typeRestaurant)
                .child(uid)
                .child("allInfoRestaurant")
                .child("catagory")
                .child("listDish")
                .child(nameDish)
                .child("detailDish")
                .child(nameDishDetail)
                .updateChildValues(object, withCompletionBlock: { error, ref in
                    if error == nil {
                        completionBlock(true, nil)
                    } else {
                        completionBlock(false, error)
                    }
                })
        })
    }
    
    func updateStatusOrderOfRestaurant(status: String, uidUser: String, completionBlock: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let ref = Database.database().reference().child("admin")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child("allUser").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
            let user = CurrentUser (uid: uid, dictionary: dict)
            let object = ["status": status] as [String:Any]
            ref.child("restaurant")
                .child(user.typeRestaurant)
                .child(uid)
                .child("allInfoRestaurant")
                .child("CARD")
                .child(uidUser)
                .child("status")
                .child(uidUser)
                .updateChildValues(object, withCompletionBlock: { error, ref in
                    if error == nil {
                        completionBlock(true, nil)
                    } else {
                        completionBlock(false, error)
                    }
                })
        })
    }
    
    func autoDeletetheSameRestaurant(typeRestaurant: String, typeCheckRestaurant: String) {
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
    
    func deleteRestaurant(typeRestaurant: String, uid: String, completionBlock: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        Database.database().reference().child("admin")
            .child("restaurant")
            .child(typeRestaurant)
            .child(uid).removeValue() { (error, _ ) in
                if error == nil {
                    print("deleted")
                    completionBlock(true, error)
                }
            }
    }
    
    func deletePromo(codePromo: String, typeRestaurant: String, uid: String, completionBlock: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        Database.database().reference().child("admin")
            .child("restaurant")
            .child(typeRestaurant)
            .child(uid)
            .child("allInfoRestaurant")
            .child("sale")
            .child("listPromo")
            .child(codePromo).removeValue() { (error, _ ) in
                if error == nil {
                    completionBlock(true, error)
                }
            }
    }
    
    func deleteCatagory(nameDish: String, completionBlock: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let ref = Database.database().reference().child("admin")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child("allUser").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            print(uid)
            guard let dict = snapshot.value as? [String: Any] else { return }
            print(dict)
            let user = CurrentUser (uid: uid, dictionary: dict)
            print(user.typeRestaurant)
            print(nameDish)
            ref.child("restaurant")
                .child(user.typeRestaurant)
                .child(uid)
                .child("allInfoRestaurant")
                .child("catagory")
                .child("listDish")
                .child(nameDish).removeValue() { (error, _ ) in
                    if error == nil {
                        completionBlock(true, error)
                    }
                }
        })
    }
    
    func deleteDish(nameDish: String, nameDetailDish: String, completionBlock: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let ref = Database.database().reference().child("admin")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child("allUser").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            print(uid)
            guard let dict = snapshot.value as? [String: Any] else { return }
            print(dict)
            let user = CurrentUser (uid: uid, dictionary: dict)
            print(user.typeRestaurant)
            print(nameDish)
            ref.child("restaurant")
                .child(user.typeRestaurant)
                .child(uid)
                .child("allInfoRestaurant")
                .child("catagory")
                .child("listDish")
                .child(nameDish)
                .child("detailDish")
                .child(nameDetailDish)
                .removeValue() { (error, _ ) in
                    if error == nil {
                        completionBlock(true, error)
                    }
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
    
    func uploadImagetoFireBaseStorage(imageData: Data, typeImage: String, completionBlock: @escaping (_ urlImage: String, _ error: Error?) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        Storage.storage().reference().child("imageRestaurant").child(user.uid).child(typeImage).child("file.png").putData(imageData, metadata: nil, completion: { _, error in
            if error == nil {
                var urlString: String?
                self.getImageURLFromFireBaseStorage(typeImage: typeImage) { (url) in
                    urlString = url
                    guard let urlString = urlString else { return }
                    completionBlock(urlString, error)
                }
            }
        })
    }
    
    func getImageDishURL(typeImage: String, nameImageCatagory: String, completionBlock: @escaping (_ urlImage: String) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        Storage.storage().reference().child("imageRestaurant").child(user.uid).child(typeImage).child(nameImageCatagory).downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                return
            }
            let urlImage = url.absoluteString
            completionBlock(urlImage)
            // UserDefaults.standard.set(urlString, forKey: "url")
        })
    }
    
    func uploadImageDish(imageData: Data, typeImage: String, nameImageCatagory: String, completionBlock: @escaping (_ urlImage: String, _ error: Error?) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        Storage.storage().reference().child("imageRestaurant").child(user.uid).child(typeImage).child(nameImageCatagory).putData(imageData, metadata: nil, completion: { _, error in
            if error == nil {
                var urlString: String?
                self.getImageDishURL(typeImage: typeImage, nameImageCatagory: nameImageCatagory) { (url) in
                    urlString = url
                    guard let urlString = urlString else { return }
                    completionBlock(urlString, error)
                }
            }
        })
    }
    
    func getImageDishDetailURL(typeImage: String, nameDish: String, completionBlock: @escaping (_ urlImage: String) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        Storage.storage().reference().child("imageRestaurant").child(user.uid).child(typeImage).child(nameDish).downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                return
            }
            let urlImage = url.absoluteString
            completionBlock(urlImage)
        })
    }
    
    func uploadImageDishDetail(imageData: Data, typeImage: String, nameDish: String, completionBlock: @escaping (_ urlImage: String, _ error: Error?) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        Storage.storage().reference().child("imageRestaurant").child(user.uid).child(typeImage).child(nameDish).putData(imageData, metadata: nil, completion: { _, error in
            if error == nil {
                var urlString: String?
                self.getImageDishDetailURL(typeImage: typeImage, nameDish: nameDish) { (url) in
                    urlString = url
                    guard let urlString = urlString else { return }
                    completionBlock(urlString, error)
                }
            }
        })
    }
    
}
