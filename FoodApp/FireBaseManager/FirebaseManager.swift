//
//  FirebaseManager.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/10/20.
//

import Foundation
import FirebaseAuth

class FirebaseManager {
    
    public static let shared = FirebaseManager()
    
    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool, _ error: Error) -> Void) {
            Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
                if let user = authResult?.user {
                    print(user)
                    completionBlock(true, error as! Error)
                } else {
                    completionBlock(false, error!)
                }
            }
        }
}
