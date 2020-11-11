//
//  FirebaseManager.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/10/20.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

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
}
