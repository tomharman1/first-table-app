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
    var lastRefreshed = Date()
    
    func timeSinceLastRefresh() -> String {
//        return "\(lastRefreshed.seconds(from: Date())) seconds"
        return "Just Now"
    }
    
    func refresh(complete:@escaping () -> Void) -> Bool {
        var success = false
        
        _ = fplPlayerService.playerPriceChanges(completionHandler: {
            response in
            switch(response.result) {
            case .success:
                if let JSON = response.result.value {
                    self.lastRefreshed = Date()
                    let playersArray = JSON as! Array<AnyObject>
                    self.players = [FPLPlayerModel]()
                    
                    for player in playersArray {
                        let fplPlayer = FPLPlayerModel(name: player["player_name_short"]! as! String,
                                                       team:player["short_team_name"]! as! String,
                                                       price:player["price"]! as! Double,
                                                       price_formatted:player["price_formatted"] as! String,
                                                       netTransfersIn:Int32((player["net_transfers_in"] as! NSNumber).intValue),
                                                       targetPercentage:player["target_percentage"]! as! Double,
                                                       targetPercentageFormatted:player["target_percentage_formatted"] as! String)
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

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}
