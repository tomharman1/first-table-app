//
//  ToDosService.swift
//  FirstTableApp
//
//  Created by Thomas Harman on 10/23/16.
//  Copyright © 2016 Toms Apps. All rights reserved.
//

import Foundation
import Alamofire

class ToDosService {
 
    init () {
        fireDummyRequest()
    }
    
    func fireDummyRequest() {
        // let requestURL = "https://httpbin.org/get"
        let requestURL = "http://127.0.0.1:5000/price-changes"
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        Alamofire.request(requestURL, headers: headers)
            .validate()
            .responseJSON { response in
                switch(response.result) {
                case .success:
                    print(response.request)  // original URL request
                    print(response.response) // HTTP URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }
}
