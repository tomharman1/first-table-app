//
//  FPLPlayersModel.swift
//  FirstTableApp
//
//  Created by Thomas Harman on 11/6/16.
//  Copyright © 2016 Toms Apps. All rights reserved.
//

import Foundation

class FPLPlayersModel {
    
    let fplPlayerService = FPLPlayerService()
    
    var players = [FPLPlayerModel]()
    
    init () {
        
    }
    
    func refresh(complete:@escaping () -> Void) -> Bool {
        var success = false
        
        _ = fplPlayerService.playerPriceChanges(completionHandler: {
            response in
            switch(response.result) {
            case .success:
                if let JSON = response.result.value {
                    let playersArray = JSON as! Array<AnyObject>
                    self.players = [FPLPlayerModel]()
                    
                    for player in playersArray {
                        let fplPlayer = FPLPlayerModel(name: player["player_name_short"]! as! String,
                                                       team:player["short_team_name"]! as! String,
                                                       price:player["price"]! as! Double,
                                                       netTransfersIn:Int32((player["net_transfers_in"] as! NSNumber).intValue),
                                                       targetPercentage:player["target_percentage"]! as! Double)
                        self.players.append(fplPlayer!)
                    }
                    // let jsonMirror = Mirror(reflecting: JSON)
                    // print(jsonMirror.subjectType)
                    print(self.players[0])
                    success = true
                }
            case .failure(_):
                success = false
            }
            complete()
        })
        
        return success
    }
}
