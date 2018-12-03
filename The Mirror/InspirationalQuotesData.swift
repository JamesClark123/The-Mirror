//
//  InspirationalQuotesData.swift
//  The Mirror
//
//  Created by BC Swift Student Loan 1 on 12/3/18.
//  Copyright © 2018 BC Swift Student Loan 1. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class InspirationalQuotesData {
    
    struct InspirationalQuote {
        var quote: String
        var author: String
    }
    
    var iQ: InspirationalQuote = InspirationalQuote(quote: "", author: "")
    
    
    func getQuote(completed: @escaping () -> ()) {
        print("*** in getQuote")
//        let baseURL = "https:'//healthruwords.p.mashape.com/v1/quotes/"
//        let maxNumber = "?maxR=25"
//        let keyStart = "X-Mashape-Key"
//        let key = "lJgLR6C89OmshrsS20lO9r4qtDnTp1AtdjgjsntZzrANVvlAVP"
        
        let baseURL = "http://quotes.rest/qod.json"
        
//        let totalURL = baseURL + maxNumber
//        let headers = [keyStart: key,
//                       "Accept": "application/json"]
//        Alamofire.request(totalURL, method: .get, headers: headers)
            Alamofire.request(baseURL).responseJSON {response in
            print(response)
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let quote = json["contents"]["quotes"][0]["quote"].string {
                    self.iQ.quote = quote
                    print(quote)
                } else {
                    print("Could not retrieve Quote")
                }
                if let author = json["contents"]["quotes"][0]["author"].string {
                    self.iQ.author = author
                    print(author)
                } else {
                    print("Could not retrieve Author")
                }
            case .failure(let error):
                print("***** Error: \(error)")
            }
            completed()
        }
        
        
    }
}
