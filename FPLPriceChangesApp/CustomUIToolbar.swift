//
//  CustomUIToolbar.swift
//  FantasyPremierLeaguePlayerPriceChanges
//
//  Created by Thomas Harman on 12/22/16.
//  Copyright © 2016 Toms Apps. All rights reserved.
//

import UIKit

class CustomUIToolbar: UIToolbar {

    private var sortByLabel: UILabel
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        self.sortByLabel = UILabel()
        super.init(coder: aDecoder)
        
//        self.translatesAutoresizingMaskIntoConstraints = false
//        self.sortByLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let font = UIFont.systemFont(ofSize: 10.0, weight: 0.25)
        self.sortByLabel.text = "sorted by:"
        self.sortByLabel.textAlignment = NSTextAlignment.center
        self.sortByLabel.font = font
//        self.addSubview(sortByLabel)
        
//        let lastRefreshedLabel = UILabel()
//        lastRefreshedLabel.text = "last updated: 2 days ago"
//        lastRefreshedLabel.font = font
//        lastRefreshedLabel.sizeToFit()
//        self.addSubview(lastRefreshedLabel)
        
//        let widthConstraint = NSLayoutConstraint(item: sortByLabel, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0)
//        widthConstraint.isActive = true
//        let centerXSortByLabel = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: sortByLabel, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0)
//        centerXSortByLabel.isActive = true
//        let centerYSortByLabel = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: sortByLabel, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0)
//        centerYSortByLabel.isActive = true
        
//        NSLayoutConstraint.activate([widthConstraint, centerXSortByLabel, centerYSortByLabel])
//        NSLayoutConstraint.activate([centerYSortByLabel])
        
//        self.sortByLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        self.sortByLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }

}
