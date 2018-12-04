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
import FirebaseGoogleAuthUI
import Charts

class ViewController: UIViewController {
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pieChart: PieChartView!
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    } ()
    
    let blueColor = UIColor(red: CGFloat(81.0/255), green: CGFloat(157.0/255), blue: CGFloat(148.0/255), alpha: 1.0)
    let redColor = UIColor(red: CGFloat(172.0/255), green: CGFloat(62.0/255), blue: CGFloat(22.0/255), alpha: 1.0)
    let armyGreenColor = UIColor(red: CGFloat(70.0/255), green: CGFloat(51.0/255), blue: CGFloat(20/255), alpha: CGFloat(1.0))
    
    var todaysValues = [Double]()
    var happy = PieChartDataEntry(value: 0)
    var sad = PieChartDataEntry(value: 0)
    var pieChartEntries = [PieChartDataEntry] ()
    
    var authUI: FUIAuth!
    var user: MirrorUser!

    override func viewDidLoad() {
        super.viewDidLoad()
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        
        
        happy.label = "Happy"
        sad.label = "Sad"
        pieChart.entryLabelColor = armyGreenColor
        pieChart.entryLabelFont = UIFont(name: "Cormorant-Bold", size: CGFloat(12.0))
        pieChartEntries = [happy, sad]
        pieChart.holeColor = pieChart.backgroundColor
        updatePieChart()
        
        
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 80)
        
//        self.tabBarController?.tabBar.selectedItem = homeTabBarButton
//        self.tabBarController?.tabBar.tintColor = UIColor(displayP3Red: 255, green: 255, blue: 255, alpha: 1)
//        self.tabBarController?.tabBar.selectedItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
//        self.tabBarController?.tabBar.unselectedItemTintColor = UIColor(displayP3Red: 240, green: 235, blue: 224, alpha: 1)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signIn()
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        user.saveData()
        if segue.identifier == "ToCalendar" {
            let destination = segue.destination as! CalendarViewController
            destination.user = user
        }
    }
    
    func updatePieChart() {
        let chartDataSet = PieChartDataSet(values: pieChartEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        let colors = [blueColor, redColor   ]
        chartDataSet.colors = colors
        chartDataSet.valueFont = UIFont(name: "Cormorant-Regular", size: CGFloat(12.0)) ?? UIFont.systemFont(ofSize: CGFloat(12.0))
        
        
        pieChart.entryLabelFont = UIFont(name: "Cormorant-Regular", size: CGFloat(12.0))
        chartData.setValueFont(UIFont(name: "Cormorant-Regular", size: CGFloat(12.0)) ?? UIFont.systemFont(ofSize: CGFloat(12.0)))
        pieChart.accessibilityElementsHidden = true
        
        
        pieChart.data = chartData
    }
    
    func signIn() {
        let providers: [FUIAuthProvider] = [
        FUIFacebookAuth(), FUIGoogleAuth()
        ]
        let currentUser = authUI.auth?.currentUser
        if currentUser == nil {
            self.authUI?.providers = providers
            present(authUI.authViewController(), animated: true, completion: nil)
        } else {
            user = MirrorUser(user: currentUser!)
            user.isNewUser() {
                if self.user.exists == false {
                    self.performSegue(withIdentifier: "StartUpProcess", sender: self)
                } else {
                    self.nameLabel.text = "Hi " + self.user.realName + "!"
                    if let tv = self.user.happySadDictionary[self.formatter.string(from: Date())] {
                        print("**** \(tv[0]) \(tv[1])")
                        self.happy.value = tv[0]
                        self.sad.value = tv[1]
                        self.updatePieChart()
                    } else {
                        self.user.happySadDictionary[self.formatter.string(from: Date())] = [0, 0]
                        self.happy.value = 0
                        self.sad.value = 0
                    }
                }
            }
            
        }
        
    }
    @IBAction func sadButtonPressed(_ sender: UIButton) {
        sad.value = sad.value + 1.0
        updatePieChart()
        user.happySadDictionary[formatter.string(from: Date())] = [happy.value, sad.value]
        user.saveData()
    }
    
    @IBAction func happyButtonPressed(_ sender: UIButton) {
        happy.value = happy.value + 1.0
        updatePieChart()
        user.happySadDictionary[formatter.string(from: Date())] = [happy.value, sad.value]
        user.saveData()
    }
    
    @IBAction func unwindToHome(seque: UIStoryboardSegue) {
        
        if seque.source is YourNameVC {
            if let senderVC = seque.source as? YourNameVC {
                if let name = senderVC.newName {
                    user.realName = name
                    print(name)
                }
                
                
                nameLabel.text = "Hi " + senderVC.newName + "!"
                user.saveData()
            }
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
