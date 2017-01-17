//
//  TitleUIBarButtonItem.swift
//  FantasyPremierLeaguePlayerPriceChanges
//
//  Created by Thomas Harman on 12/29/16.
//  Copyright © 2016 Toms Apps. All rights reserved.
//

import UIKit

class TitleUIBarButtonItem: UIBarButtonItem {

    var label: UILabel
    
    init(text: String, font: UIFont, color: UIColor) {
        
        label =  UILabel(frame: UIScreen.main.bounds)
        label.text = text
        label.sizeToFit()
        label.font = font
        label.textColor = color
        label.textAlignment = .center
        
        super.init()
        
        customView = label
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
