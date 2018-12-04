//
//  InspirationalQuoteViewController.swift
//  The Mirror
//
//  Created by BC Swift Student Loan 1 on 12/3/18.
//  Copyright © 2018 BC Swift Student Loan 1. All rights reserved.
//

import UIKit

class InspirationalQuoteViewController: UIViewController {
    @IBOutlet weak var quoteText: UITextView!
    @IBOutlet weak var byLine: UILabel!
    
    var quotes: InspirationalQuotesData!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        homeButton.tintColor = UIColor(red: 240, green: 235, blue: 224, alpha: 1)
//        quoteButton.tintColor = UIColor.white
        
        
        
        quotes = InspirationalQuotesData()
        
//        print("about to get quote")

        self.quotes.getQuote() {
            self.quoteText.text = self.quotes.iQ.quote
            self.byLine.text = self.quotes.iQ.author
        }
    }
    

   

}
