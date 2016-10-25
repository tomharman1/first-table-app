//
//  FPLPlayersTableViewController.swift
//  FirstTableApp
//
//  Created by Thomas Harman on 10/18/16.
//  Copyright © 2016 Toms Apps. All rights reserved.
//

import UIKit

class FPLPlayersTableViewController: UITableViewController {

    // MARK: Properties
    
    var players = [FPLPlayerModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadSamplePlayers()
        // ToDosService()
    }
    
    fileprivate func loadSamplePlayers() {
        let player1 = FPLPlayerModel(name: "Theo Walcott", team: "Arsenal", price: 8.7, netTransfersIn: 800000, targetPercentage: -78)!
        let player2 = FPLPlayerModel(name: "Alexis Sanchez", team: "Arsenal", price: 11.2, netTransfersIn: 25000, targetPercentage: 255)!
        let player3 = FPLPlayerModel(name: "Deli Ali", team: "Spurs", price: 7.8, netTransfersIn: 350000, targetPercentage: 101)!
        let player4 = FPLPlayerModel(name: "Daily Blind", team: "Man U", price: 5.5, netTransfersIn: -50000, targetPercentage: -50)!
        let player5 = FPLPlayerModel(name: "Romeleu Lukaku", team: "Everton", price: 10.2, netTransfersIn: 20000, targetPercentage: 24)!
        
        players += [player1, player2, player3, player4, player5]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "FPLPlayerTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FPLPlayerTableViewCell
        
        let player = players[(indexPath as NSIndexPath).row]

        cell.playerNameLabel.text = player.name
        cell.teamNameLabel.text = player.team
        cell.priceLabel.text = String(format:"%.2f", player.price)
        cell.netTransfersInLabel.text = String(player.netTransfersIn)
        cell.targetPercentageLabel.text = String(player.targetPercentage)

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
