//
//  BaseAccountViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 19/6/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class BaseAccountViewController: BaseViewController {

    var dataResponse : Accounts?
    var mainControl : UIScrollView?
    var refreshControl : UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: Helper.getLocalizedText("Pull to refresh"))
        
        self.refreshControl?.addTarget(self, action: #selector(BaseAccountViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        if let table = self.view as? UITableView
        {
            self.mainControl = table
        }
        else
        {
            self.mainControl = self.view as? UICollectionView
        }
        
        self.mainControl!.addSubview(refreshControl!)
        refresh(nil)
        
    }
    
    @objc func refresh(_ sender:AnyObject?)
    {
        self.showBusyIndicator("Loading Data")
        ProxyManager.AllBalances ({
            (result) in
            if(!self.removedFromParent)
            {
                if  self.refreshControl!.isHidden == false {
                    self.refreshControl?.endRefreshing()
                }
                OperationQueue.main.addOperation({
                    if result.isSuccess{
                        self.dataResponse = result.data
                        if let tableView = self.mainControl as? UITableView{
                            tableView.reloadData()
                        }
                        else {
                            if let collectionView = self.mainControl as? UICollectionView{
                                collectionView.reloadData()
                            }
                        }
                        self.hideBusyIndicator()
                    }
                    else{
                        self.hideBusyIndicator()
                        if(self.sessionTimeOutException(result.code as String) == false){
                            self.showAlert("Error Title", messageKey: result.message as String == "" ? "Timeout Generic Exception Message" : result.message as String)
                        }
                    }
                })
            }}, failure: { (error) -> Void in                if(!self.removedFromParent)
            {
                self.refreshControl?.endRefreshing()
                self.hideBusyIndicator()
                self.showAlert("Error Title", messageKey: "Timeout Generic Exception Message")
                }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let data = dataResponse
        {
            var row  : Int = 0
            if let tableView = mainControl as? UITableView
            {
                if let indexPath : IndexPath = tableView.indexPathForSelectedRow
                {
                    row = (indexPath as NSIndexPath).row
                }
            }
            else
            {
                if let collectionView = mainControl as? UICollectionView
                {
                    let  indexPathArray  = collectionView.indexPathsForSelectedItems
                    if let indexPath = indexPathArray?.first as IndexPath?
                    {
                        row = indexPath.row
                    }
                }
            }
            let  detailViewController : MovementsViewController = segue.destination as! MovementsViewController
            detailViewController.account = data.list[row]
        }
        
    }
}
