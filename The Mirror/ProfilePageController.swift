//
//  ProfilePageController.swift
//  The Mirror
//
//  Created by BC Swift Student Loan 1 on 12/3/18.
//  Copyright © 2018 BC Swift Student Loan 1. All rights reserved.
//

import UIKit
import FirebaseAuthUI

class ProfilePageController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        do {
            try FUIAuth.defaultAuthUI()?.signOut()
        } catch  {
        print("*** Error when trying to sign out")
        }
        
        self.performSegue(withIdentifier: "justSignedOut", sender: self)
        
//        let isPresentingInAddMode = presentingViewController is UINavigationController
//        if isPresentingInAddMode {
//            dismiss(animated: true, completion: nil)
//        } else {
//            navigationController?.popViewController(animated: true)
//        }
        
    }
    

}
