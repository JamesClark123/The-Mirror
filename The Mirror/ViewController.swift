//
//  ViewController.swift
//  The Mirror
//
//  Created by BC Swift Student Loan 1 on 12/2/18.
//  Copyright © 2018 BC Swift Student Loan 1. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseFacebookAuthUI

class ViewController: UIViewController {
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var statisticsBarButton: UIBarButtonItem!
    @IBOutlet weak var settingsBarButton: UIBarButtonItem!
    @IBOutlet weak var homeTabBarButton: UITabBarItem!
    
    var authUI: FUIAuth!
    var user: MirrorUser!

    override func viewDidLoad() {
        super.viewDidLoad()
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        
        
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 80)
        
        self.tabBarController?.tabBar.selectedItem = homeTabBarButton
        self.tabBarController?.tabBar.tintColor = UIColor(displayP3Red: 255, green: 255, blue: 255, alpha: 1)
        self.tabBarController?.tabBar.selectedItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        self.tabBarController?.tabBar.unselectedItemTintColor = UIColor(displayP3Red: 240, green: 235, blue: 224, alpha: 1)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signIn()
    }
    
    func signIn() {
        let providers: [FUIAuthProvider] = [
        FUIFacebookAuth(),
        ]
        let currentUser = authUI.auth?.currentUser
        if currentUser == nil {
            self.authUI?.providers = providers
            present(authUI.authViewController(), animated: true, completion: nil)
        } else {
            user = MirrorUser(user: currentUser!)
            user.isNewUser()
        }
    }


}

extension ViewController: FUIAuthDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        return false
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let user = user {
            print("*** We signed in with the user \(user.email ?? "unknown email")")
        }
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        let loginViewController = FUIAuthPickerViewController(authUI: authUI)
        
//        loginViewController.view.backgroundColor = UIColor.init(red: 240.0, green: 235.0, blue: 224.0, alpha: 1.0)
        
        
        return loginViewController
    }
}

///Users/bcswiftstudentloan1/Desktop/The Mirror - Final Project/The Mirror/Podfile
