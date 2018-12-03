//
//  MirrorUser.swift
//  The Mirror
//
//  Created by BC Swift Student Loan 1 on 12/3/18.
//  Copyright © 2018 BC Swift Student Loan 1. All rights reserved.
//

import Foundation
import Firebase

class MirrorUser {
    var email: String
    var displayName: String
    var realName: String
    var documentID: String
    var exists: Bool
    
    var dictionary: [String: Any] {
        return ["email": email, "realName": realName, "displayName": displayName, "documentID": documentID]
    }
    
    init(email: String, realName: String, displayName: String, documentID: String, exists: Bool) {
        self.email = email
        self.realName = realName
        self.displayName = displayName
        self.documentID = documentID
        self.exists = exists
    }
    
    convenience init(user: User) {
        self.init(email: user.email ?? "", realName: "", displayName: user.displayName ?? "", documentID: user.uid, exists: false)
    }
    
    
    func isNewUser() {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(documentID)
        userRef.getDocument { (document, error) in
            guard error == nil else {
                print("Error: could not access user document")
                self.exists = true
                return
            }
            
            guard document?.exists == false else {
                print("the document already exists for this user")
                self.realName = document?.get("realName") as? String ?? ""
                self.exists = true
                return
            }
            self.saveData()
            self.exists = false
            return
        }
    }
    
    func saveData() {
        let db = Firestore.firestore()
        let dataToSave: [String: Any] = self.dictionary
        db.collection("users").document(documentID).setData(dataToSave) { error in
            if let error = error {
                print("Error: could not save data for this user \(error.localizedDescription)")
            }
        }
    }
}
