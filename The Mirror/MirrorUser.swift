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
    var happySadDictionary: [String: [Double]]
    
    var dictionary: [String: Any] {
        return ["email": email, "realName": realName, "displayName": displayName, "documentID": documentID, "happySadDictionary": happySadDictionary]
    }
    
    init(email: String, realName: String, displayName: String, documentID: String, exists: Bool, happySadDictionary: [String: [Double]]) {
        self.email = email
        self.realName = realName
        self.displayName = displayName
        self.documentID = documentID
        self.exists = exists
        self.happySadDictionary = happySadDictionary
    }
    
    convenience init(user: User) {
        self.init(email: user.email ?? "", realName: "", displayName: user.displayName ?? "", documentID: user.uid, exists: false, happySadDictionary: [:])
    }
    
    
    func isNewUser(completed: @escaping () -> ()) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(documentID)
        userRef.getDocument { (document, error) in
            guard error == nil else {
                print("Error: could not access user document")
                self.exists = false
                return
            }
            
            guard document?.exists == false else {
                print("the document already exists for this user")
                self.realName = document?.get("realName") as? String ?? ""
                self.happySadDictionary = document?.get("happySadDictionary") as? [String: [Double]] ?? [:]
                print(self.realName)
                print(self.happySadDictionary)
                self.exists = true
                completed()
                return
            }
//            self.saveData()
            completed()
        }
    }
    
    func saveData() {
        print("What goes through saveData" + email + displayName + realName + documentID)
        let db = Firestore.firestore()
        let dataToSave: [String: Any] = self.dictionary
        db.collection("users").document(documentID).setData(dataToSave) { error in
            if let error = error {
                print("Error: could not save data for this user \(error.localizedDescription)")
            }
        }
    }
}
