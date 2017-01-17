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
    var price_formatted: String
    var netTransfersIn: Int32
    var targetPercentage: Double
    var targetPercentageFormatted: String
    
    // MARK: Initialization
    init?(name: String, team: String, price: Double, price_formatted: String, netTransfersIn: Int32, targetPercentage: Double, targetPercentageFormatted: String) {
        self.name = name
        self.team = team
        self.price = price
        self.price_formatted = price_formatted
        self.netTransfersIn = netTransfersIn
        self.targetPercentage = targetPercentage
        self.targetPercentageFormatted = targetPercentageFormatted
        
        if name.isEmpty || team.isEmpty || price < 0 {
            return nil
        }
    }
}
