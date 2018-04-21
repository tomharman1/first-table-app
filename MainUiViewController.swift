//
//  MainUiViewController.swift
//  FPLPriceChangesApp
//
//  Created by Thomas Harman on 4/21/18.
//  Copyright © 2018 Toms Apps. All rights reserved.
//

import UIKit

class MainUiViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
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
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.rowHeight = 35
        
        self.setupToolbar(lastUpdatedTitle: "Just Now")
        self.setupActivityIndicator()
        
        self.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
//        loadSamplePlayers()
        loadPlayersFromService()
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count // for the header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "FPLPlayerTableViewCell"
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
        cell.priceLabel.text = String(player.price_formatted)
        cell.netTransfersInLabel.text = String(player.netTransfersIn)
        cell.targetPercentageLabel.text = String(player.targetPercentageFormatted)
        
        if (player.targetPercentage > 100) {
            cell.targetPercentageLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
            //  https://www.ralfebert.de/snippets/ios/swift-uicolor-picker/
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
    }
    
    func onClickedSortButton(sender: UIBarButtonItem) {
        showSortByMenu()
    }
    
    func onClickedRefreshButton(sender: UIBarButtonItem) {
        loadPlayersFromService()
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
    
    private func sortNetTransfersIn() {
        players.sort() { $0.netTransfersIn > $1.netTransfersIn }
        self.tableView.reloadData()
    }
    
    private func sortNetTransfersOut() {
        players.sort() { $0.netTransfersIn < $1.netTransfersIn }
        self.tableView.reloadData()
    }
    
    private func sortAscending() {
        players.sort() { $0.targetPercentage > $1.targetPercentage }
        self.tableView.reloadData()
    }
    
    private func sortDescending() {
        players.sort() { $0.targetPercentage < $1.targetPercentage }
        self.tableView.reloadData()
    }
    
    // MARK: toolbar
    
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
    
    private func loadSamplePlayers() {
        let player1 = FPLPlayerModel(name: "Walcott", team: "Arsenal", price: 8.7, price_formatted: "8.7m", netTransfersIn: 800000, targetPercentage: -78, targetPercentageFormatted: "-78%")
        let player2 = FPLPlayerModel(name: "Sanchez", team: "Arsenal", price: 11.2, price_formatted: "8.7m", netTransfersIn: 25000, targetPercentage: 255, targetPercentageFormatted: "-78%")
        let player3 = FPLPlayerModel(name: "Ali", team: "Spurs", price: 7.8, price_formatted: "8.7m", netTransfersIn: 350000, targetPercentage: 101, targetPercentageFormatted: "-78%")
        let player4 = FPLPlayerModel(name: "Blind", team: "Man U", price: 5.5, price_formatted: "8.7m", netTransfersIn: -50000, targetPercentage: -50, targetPercentageFormatted: "-78%")
        let player5 = FPLPlayerModel(name: "Lukaku", team: "Everton", price: 10.2, price_formatted: "8.7m", netTransfersIn: 20000, targetPercentage: 24, targetPercentageFormatted: "-78%")
        
        players += [player1, player2, player3, player4, player5]
    }
    

    
}
