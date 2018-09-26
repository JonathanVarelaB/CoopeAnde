//
//  MovementsViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 25/6/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class MovementsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblAccount: UILabel!
    @IBOutlet weak var lblAccountType: UILabel!
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tvLongAccountNumber: UILabel!
    
    
    var account : Account!
    //response
    var dataResponse : Statements?
    //Data Group by date
    var groupData: [Date : Array<AnyObject>]?
    //Sections
    var sortedKeys:[Date]?
    
    var currentPage : Int = 1
    var refreshControl : UIRefreshControl?
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Account Received: ",account.account)
        dateFormatter.dateStyle = DateFormatter.Style.short
        
        //BaseViewController.setNavigation(self.title!,controller: self)
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: Helper.getLocalizedText("Pull to refresh"))
        
        self.refreshControl?.addTarget(self, action: #selector(MovementsViewController.reload(_:)), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(self.refreshControl!)
        refresh(nil)
        showHeader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Movimientos"
        
        let img = UIImage()
        self.navigationController?.navigationBar.shadowImage = img
        self.navigationController?.navigationBar.setBackgroundImage(img, for: UIBarMetrics.default)
        
        //self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.01, green:0.39, blue:0.78, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let img = UIImage()
        self.navigationController?.navigationBar.shadowImage = img
        self.navigationController?.navigationBar.setBackgroundImage(img, for: UIBarMetrics.default)
        
        //self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    func  showHeader()
    {
        if let data = account {
            lblAccount.text = data.account as String
            lblAccountType.text = data.typeDescription as String
            lblBalance.text = Helper.formatAmount(data.availableBalance, currencySign: data.currencySign as String)
            lblDescription.text = data.name as String
            tvLongAccountNumber.text = data.sinpe as String
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = self.groupData
        {
            return data[self.sortedKeys![section]]!.count
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let data = self.groupData
        {
            return data.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovementCell = self.tableView.dequeueReusableCell(withIdentifier: "detail", for: indexPath) as! MovementCell
        
        if let data = self.groupData
        {
            let item : Statement =  data[self.sortedKeys![indexPath.section]]!.get(at: indexPath.row)! as! Statement
            let total = Helper.formatAmount(item.totalTransaction, currencySign: account!.currencySign as String)
            let date = item.transactionTime
            cell.show(time: date as String,documentNumber:item.document as String,movementType: item.transactionDesc as String, amount: total)
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = Helper.getViewController("StatementSectionHeaderViewController") as! StatementSectionHeaderViewController
        headerView.title = self.getSectionTitle(section)
        return headerView.view
    }
    
    //Solicitar datos al server cuando el scroll esta en el fondo
    func scrollViewDidEndDragging(_ aScrollView : UIScrollView, willDecelerate decelerate : Bool)
    {
        let height : CGFloat = aScrollView.frame.size.height;
        let contentYoffset : CGFloat = aScrollView.contentOffset.y;
        let distanceFromBottom : CGFloat = aScrollView.contentSize.height - contentYoffset;
        
        if(distanceFromBottom < height)
        {
            if( self.dataResponse !=  nil){
                if ((self.dataResponse?.count.intValue)! > (self.dataResponse?.list.count)!) {
                    refresh(nil)
                }
            }
        }
        
    }
    
    //Inicializar paginacion
    @objc func reload(_ sender:AnyObject?)
    {
        self.currentPage = 1
        self.dataResponse = nil
        self.groupData = nil
        
        refresh(sender)
    }
    //Solicitar datos al server
    func refresh(_ sender:AnyObject?)
    {
        self.showBusyIndicator("Loading Data")
        let request : StatementsRequest = StatementsRequest()
        
        request.account = account!.account
        request.numPage = NSNumber(value: self.currentPage)
        request.totalPage = NSNumber(value: Constants.rowsPerPage)
        self.currentPage = self.currentPage + 1
        
        ProxyManager.AccountMovements (request, success: {
            (result) in
            if(!self.removedFromParent)
            {
                self.hideBusyIndicator()
                
                if  self.refreshControl!.isHidden == false {
                    self.refreshControl?.endRefreshing()
                }
                DispatchQueue.main.async {
                if result.isSuccess
                {
                        if self.dataResponse == nil
                        {
                            self.dataResponse = result.data
                            self.CreateSections()
                            self.tableView.reloadData()
                        }
                        else
                        {
                            self.dataResponse!.count = result.data!.count
                            self.dataResponse!.list  += result.data!.list
                            self.CreateSections()
                            //var timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("appendTableView"), userInfo: nil, repeats: false)
                            self.tableView.reloadData()
                        }
                }
                else
                {
                    if(self.sessionTimeOutException(result.code as String) == false)
                    {
                        self.showAlert("Error Title", messageKey: result.message as String == "" ? "Timeout Generic Exception Message" : result.message as String)
                    }
                }
                }
            }}, failure: { (error) -> Void in                if(!self.removedFromParent)
            {
                self.refreshControl?.endRefreshing()
                self.hideBusyIndicator()
                self.showAlert("Error Title", messageKey: "Timeout Generic Exception Message")
                }
        })
    }
    
    //Agrupar los datos
    
    
    func CreateSections()
    {
        if let array = self.dataResponse?.list
        {
            groupData = array.groupBy(groupingFunction: {
                (value: AnyObject) -> Date in
                
                return ((value as? Statement)!.date! as Date)
            })
            sortedKeys = Array(groupData!.keys)
            sortedKeys!.sorted( by: {
                $0.compare($1) == ComparisonResult.orderedDescending
            })
        }
    }
    func getSectionTitle(_ section: Int) -> String?
    {
        if let data = self.sortedKeys
        {
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.string(from: data[section])
        }
        return nil
    }

}
