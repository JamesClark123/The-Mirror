//
//  YourNameVC.swift
//  The Mirror
//
//  Created by BC Swift Student Loan 1 on 12/3/18.
//  Copyright © 2018 BC Swift Student Loan 1. All rights reserved.
//

import UIKit

class YourNameVC: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    
    var newName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        newName = nameField.text
    }
    
    
    @IBAction func goBackHome(_ sender: UIButton) {
        
//        let name = nameField.text
//        if name == "" || name == "NAME" {
//            
//        } else {
//            performSegue(withIdentifier: "unwindToHome", sender: self)
//        }
    }
    
}
