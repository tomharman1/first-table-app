//
//  FPLPlayersTableViewController.swift
//  FirstTableApp
//
//  Created by Thomas Harman on 10/18/16.
//  Copyright © 2016 Toms Apps. All rights reserved.
//

import UIKit

class FPLPlayersTableViewController: UITableViewController {

    // MARK: static strings
    let SORT_LABEL = "Sort"
    
    // MARK: Properties
    let fplPlayersModel = FPLPlayersModel()
    var players = [FPLPlayerModel]()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.rowHeight = 35
        
        self.tableView.delegate = self
        
        self.addSortButtons()
        self.navigationController?.setToolbarHidden(true, animated: true)
        
        self.view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        
        let horizontalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        view.addConstraint(horizontalConstraint)
        
        let verticalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        view.addConstraint(verticalConstraint)
        
//        loadSamplePlayers()
        loadPlayersFromService()
    }
    
    override public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let delayInSeconds = 1.5
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
            // here code perfomed with delay
            self.navigationController?.setToolbarHidden(false, animated: true)
            
        }
    }
    
    func onClickedSortButton(sender: UIBarButtonItem) {
        showSortByMenu()
//        self.tableView.reloadData()
//        self.tableView.setContentOffset(CGPoint.init(x: 0, y: -20), animated: true)
    }
    
    private func showSortByMenu() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            // do something
        })
        alertController.addAction(cancelAction)
        
        let sortByRising = UIAlertAction(title: "Rising", style: .default, handler: { action in
            // sort by rising
            self.sortAscending()
        })
        alertController.addAction(sortByRising)
        
        let sortByFalling = UIAlertAction(title: "Falling", style: .default, handler: { action in
            // sort by falling
            self.sortDescending()
        })
        alertController.addAction(sortByFalling)
        
        let sortByNetTransfersIn = UIAlertAction(title: "Net Transfers In", style: .default, handler: { action in
            // sort by NTI
            self.sortNetTransfersIn()
        })
        alertController.addAction(sortByNetTransfersIn)
        
        let sortByNetTransfersOut = UIAlertAction(title: "New Transfers Out", style: .default, handler: { action in
            // sort by NTO
            self.sortNetTransfersOut()
        })
        alertController.addAction(sortByNetTransfersOut)
        
        self.present(alertController, animated: true, completion: {})
        
    }
    
    private func addSortButtons() {
        var items = [UIBarButtonItem]()
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        )
        
        items.append(UIBarButtonItem(image: UIImage(named: "sort_image"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onClickedSortButton(sender:))))
        
        self.setToolbarItems(items, animated: false)
    }

    private func sortNetTransfersIn() {
        players.sort() { $0.netTransfersIn > $1.netTransfersIn }
        self.tableView.reloadData()
        self.tableView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
    }
    
    private func sortNetTransfersOut() {
        players.sort() { $0.netTransfersIn < $1.netTransfersIn }
        self.tableView.reloadData()
        self.tableView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
    }
    
    private func sortAscending() {
        players.sort() { $0.targetPercentage > $1.targetPercentage }
        self.tableView.reloadData()
        self.tableView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
    }

    private func sortDescending() {
        players.sort() { $0.targetPercentage < $1.targetPercentage }
        self.tableView.reloadData()
        self.tableView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
    }
    
    private func loadPlayersFromService() {
        self.activityIndicator.startAnimating()
        _ = self.fplPlayersModel.refresh(complete: {
            self.players = self.fplPlayersModel.players
            self.activityIndicator.stopAnimating()
            self.sortAscending()
            self.tableView.isHidden = false
            self.navigationController?.setToolbarHidden(false, animated: true)
        })
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
        return players.count // for the header
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cellIdentifier = indexPath.row == 0 ? "FPLPlayerHeaderTableViewCell" : "FPLPlayerTableViewCell"
        let cellIdentifier = "FPLPlayerTableViewCell"
        
//        if (indexPath.row == 0) { // table head
//            return self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! FPLPlayerHeaderTableViewCell
//        }
//        else {
//            let index = (indexPath as NSIndexPath).row - 1
            let index = (indexPath as NSIndexPath).row
            let isEvenIndex = (index % 2) == 0
            let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FPLPlayerTableViewCell
            let player = players[index]
            let lightGray = UIColor.lightGray.withAlphaComponent(0.1)
            
            if (isEvenIndex) {
                cell.backgroundColor = lightGray
            }
            else {
                cell.backgroundColor = UIColor.clear
            }
            
            cell.playerNameLabel.text = player.name
            cell.teamNameLabel.text = player.team
            cell.priceLabel.text = String(format:"%.2f", player.price)
            cell.netTransfersInLabel.text = String(player.netTransfersIn)
            cell.targetPercentageLabel.text = String(player.targetPercentage)
            
            if (player.targetPercentage > 100) {
                cell.targetPercentageLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
//                # https://www.ralfebert.de/snippets/ios/swift-uicolor-picker/
                let greenColor = UIColor(red: 0, green: 0.8392, blue: 0.2353, alpha: 1.0)
                cell.targetPercentageLabel.textColor = greenColor
            }
            else if (player.targetPercentage < -100) {
                cell.targetPercentageLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
                cell.targetPercentageLabel.textColor = UIColor.red
            }
            else {
                cell.targetPercentageLabel.font = UIFont.systemFont(ofSize: 12.0, weight: 0)
                cell.targetPercentageLabel.textColor = UIColor.black
            }
            
            return cell
//        }
    }
    
    private func loadSamplePlayers() {
        let player1 = FPLPlayerModel(name: "Theo Walcott", team: "Arsenal", price: 8.7, netTransfersIn: 800000, targetPercentage: -78)!
        let player2 = FPLPlayerModel(name: "Alexis Sanchez", team: "Arsenal", price: 11.2, netTransfersIn: 25000, targetPercentage: 255)!
        let player3 = FPLPlayerModel(name: "Deli Ali", team: "Spurs", price: 7.8, netTransfersIn: 350000, targetPercentage: 101)!
        let player4 = FPLPlayerModel(name: "Daily Blind", team: "Man U", price: 5.5, netTransfersIn: -50000, targetPercentage: -50)!
        let player5 = FPLPlayerModel(name: "Romeleu Lukaku", team: "Everton", price: 10.2, netTransfersIn: 20000, targetPercentage: 24)!
        
        players += [player1, player2, player3, player4, player5]
    }
    
    /*
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
     */

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
