//
//  FPLPlayerService.swift
//  FirstTableApp
//
//  Created by Thomas Harman on 11/6/16.
//  Copyright © 2016 Toms Apps. All rights reserved.
//

import Foundation
import Alamofire

class FPLPlayerService {
    
    init () {
        
    }
    
    func playerPriceChanges(completionHandler: @escaping (DataResponse<Any>) -> Void) -> Self {
        // let requestURL = "http://127.0.0.1:5000/price-changes"
        let requestURL = "https://fierce-depths-10880.herokuapp.com/price-changes"
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        Alamofire.request(requestURL, headers: headers)
            .validate()
            .responseJSON { response in
                switch(response.result) {
                case .success: break
                    // print(response.request)  // original URL request
                    // print(response.response) // HTTP URL response
                    // print(response.data)     // server data
                    // print(response.result)   // result of response serialization
                case .failure(let error):
                    print("error")
                    print(error)
                }
        }.responseJSON(completionHandler: completionHandler)
        
        return self
    }
}
