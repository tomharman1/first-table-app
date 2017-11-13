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
    let STATUS_BAR_Y_OFFSET = 0
    
    // MARK: Properties
    let fplPlayersModel = FPLPlayersModel()
    var players = [FPLPlayerModel]()
    var activityIndicatorContainer: UIView
    
    required init?(coder aDecoder: NSCoder) {
        self.activityIndicatorContainer = UIView()
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.navigationController?.setToolbarHidden(true, animated: true)
        self.navigationController?.isNavigationBarHidden = true
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.rowHeight = 35
        
        self.setupToolbar(lastUpdatedTitle: "Just Now")
        self.setupActivityIndicator()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        loadSamplePlayers()
        loadPlayersFromService()
    }
    
//    override public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        self.navigationController?.setToolbarHidden(true, animated: true)
//    }
//    
//    override public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        
//        let delayInSeconds = 1.5
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
//            // here code perfomed with delay
//            self.navigationController?.setToolbarHidden(false, animated: true)
//            
//        }
//    }
    
    func onClickedSortButton(sender: UIBarButtonItem) {
        showSortByMenu()
//        self.tableView.reloadData()
//        self.tableView.setContentOffset(CGPoint.init(x: 0, y: -20), animated: true)
    }
    
    func onClickedRefreshButton(sender: UIBarButtonItem) {
        loadPlayersFromService()
    }
    
    private func setupActivityIndicator() {
        self.activityIndicatorContainer.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicatorContainer.frame = self.tableView.frame
        self.activityIndicatorContainer.center = self.tableView.center
        self.activityIndicatorContainer.backgroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.3)
        
        let loadingView: UIView = UIView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = self.tableView.center
        loadingView.backgroundColor = UIColor(red:0.02, green:0.27, blue:0.27, alpha:0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2.0, y: loadingView.frame.size.height / 2.0)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        
        loadingView.addSubview(activityIndicator)
        self.activityIndicatorContainer.addSubview(loadingView)
        self.tableView.addSubview(self.activityIndicatorContainer)
        
        
//        let horizontalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
//        view.addConstraint(horizontalConstraint)
//        
//        let verticalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
//        view.addConstraint(verticalConstraint)
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
    
    private func setupToolbar(lastUpdatedTitle: String) {
        var items = [UIBarButtonItem]()
        
        items.append(UIBarButtonItem(image: UIImage(named: "refresh_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onClickedRefreshButton(sender:))))
        
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        )
        
        items.append(
            TitleUIBarButtonItem(text: "Last updated: \(lastUpdatedTitle)", font: UIFont.systemFont(ofSize: 10.0), color: UIColor.black)
        )
        
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        )
        
        items.append(UIBarButtonItem(image: UIImage(named: "sort_image"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onClickedSortButton(sender:))))
        
        
        self.setToolbarItems(items, animated: false)
    }

    private func sortNetTransfersIn() {
        players.sort() { $0.netTransfersIn > $1.netTransfersIn }
        self.tableView.reloadData()
        self.tableView.setContentOffset(CGPoint.init(x: 0, y: STATUS_BAR_Y_OFFSET), animated: true)
    }
    
    private func sortNetTransfersOut() {
        players.sort() { $0.netTransfersIn < $1.netTransfersIn }
        self.tableView.reloadData()
        self.tableView.setContentOffset(CGPoint.init(x: 0, y: STATUS_BAR_Y_OFFSET), animated: true)
    }
    
    private func sortAscending() {
        players.sort() { $0.targetPercentage > $1.targetPercentage }
        self.tableView.reloadData()
        self.tableView.setContentOffset(CGPoint.init(x: 0, y: STATUS_BAR_Y_OFFSET), animated: true)
    }

    private func sortDescending() {
        players.sort() { $0.targetPercentage < $1.targetPercentage }
        self.tableView.reloadData()
        self.tableView.setContentOffset(CGPoint.init(x: 0, y: STATUS_BAR_Y_OFFSET), animated: true)
    }
    
    private func loadPlayersFromService() {
//        self.tableView.isHidden = true
        self.activityIndicatorContainer.isHidden = false
        _ = self.fplPlayersModel.refresh(complete: {
            self.players = self.fplPlayersModel.players
            self.activityIndicatorContainer.isHidden = true
            self.sortAscending()
            self.tableView.reloadData()
            self.tableView.isHidden = false
            self.setupToolbar(lastUpdatedTitle: self.fplPlayersModel.timeSinceLastRefresh())
//            self.navigationController?.setToolbarHidden(false, animated: true)
//            self.navigationController?.isNavigationBarHidden = false
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
//            cell.priceLabel.text = String(format:"%.2f", player.price)
            cell.priceLabel.text = String(player.price_formatted)
            cell.netTransfersInLabel.text = String(player.netTransfersIn)
//            cell.targetPercentageLabel.text = String(player.targetPercentage)
            cell.targetPercentageLabel.text = String(player.targetPercentageFormatted)
        
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
        let player1 = FPLPlayerModel(name: "Walcott", team: "Arsenal", price: 8.7, price_formatted: "8.7m", netTransfersIn: 800000, targetPercentage: -78, targetPercentageFormatted: "-78%")!
        let player2 = FPLPlayerModel(name: "Sanchez", team: "Arsenal", price: 11.2, price_formatted: "8.7m", netTransfersIn: 25000, targetPercentage: 255, targetPercentageFormatted: "-78%")!
        let player3 = FPLPlayerModel(name: "Ali", team: "Spurs", price: 7.8, price_formatted: "8.7m", netTransfersIn: 350000, targetPercentage: 101, targetPercentageFormatted: "-78%")!
        let player4 = FPLPlayerModel(name: "Blind", team: "Man U", price: 5.5, price_formatted: "8.7m", netTransfersIn: -50000, targetPercentage: -50, targetPercentageFormatted: "-78%")!
        let player5 = FPLPlayerModel(name: "Lukaku", team: "Everton", price: 10.2, price_formatted: "8.7m", netTransfersIn: 20000, targetPercentage: 24, targetPercentageFormatted: "-78%")!
        
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
