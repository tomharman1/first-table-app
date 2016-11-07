//
//  FPLPlayerModel.swift
//  FirstTableApp
//
//  Created by Thomas Harman on 10/18/16.
//  Copyright © 2016 Toms Apps. All rights reserved.
//

import UIKit

class FPLPlayerModel {
    
    // Mark: Properties
    var name: String
    var team: String
    var price: Double
    var netTransfersIn: Int32
    var targetPercentage: Double
    
    // MARK: Initialization
    init?(name: String, team: String, price: Double, netTransfersIn: Int32, targetPercentage: Double) {
        self.name = name
        self.team = team
        self.price = price
        self.netTransfersIn = netTransfersIn
        self.targetPercentage = targetPercentage
        
        if name.isEmpty || team.isEmpty || price < 0 {
            return nil
        }
    }
}
