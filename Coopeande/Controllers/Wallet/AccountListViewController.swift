//
//  AccountListViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 21/8/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class AccountListViewController: UITableViewController {
    

    var tipoCuenta : AccountType = AccountType.from
    var delegate : SelectedAccountBackDelegate?
    var dataResponse : Array<Account>?
    var ProxyManager :UtilProxyManager = UtilProxyManager()
    override func viewDidLoad() {
        super.viewDidLoad()

        getAccountsByTransferType(trasferTypeId : "01")
        BaseViewController.setNavigation(titleView: self.title!,controller: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = dataResponse
        {
            print("cantidad", data.count)
            return data.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellReturn : UITableViewCell?
        let item = dataResponse![indexPath.row]
        
        if( item.isDestination )
        {
            let cell: ToAccountCell = self.tableView.dequeueReusableCell(withIdentifier: "ToAccountsByTransferType", for: indexPath) as! ToAccountCell
            cell.show( item: item)
            cellReturn = cell
        }
        else
        {
            let cell: FromAccountCell = self.tableView.dequeueReusableCell(withIdentifier: "myAccounts", for: indexPath) as! FromAccountCell
            cell.show( item)
            cellReturn = cell
        }
        
        return cellReturn!
        
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Seleccionado: ",dataResponse![indexPath.row].account)
        delegate?.SelectedAccountBack(selectedValue: dataResponse![indexPath.row], type: self.tipoCuenta)
        if(Constants.iPhone)
        {
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            if self.navigationController?.popViewController(animated: true) == nil
            {
                self.dismiss(animated: true, completion: nil)
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func getAccountsByTransferType(trasferTypeId : String)
    {
        //print("Id Elegido1: ",transferAccounts?.accountFromCount)
        let request : TransferAccountsRequest = TransferAccountsRequest()
        request.transferTypeId = trasferTypeId
        self.showBusyIndicator( "Loading Data")
        ProxyManager.AccountsByTransferType(data: request, success: {
            (result) in
            self.hideBusyIndicator()
            DispatchQueue.main.async() {
                if result.isSuccess{
                    self.dataResponse = result.data?.destinationAccounts
                    self.tableView.reloadData()
                }
                else{
                    //if(self.sessionTimeOutDelegate!.onSessionTimeOutException(code: result.code as String) == false)
                   // {
                        self.showAlert("Error Title", messageKey: result.message as String == "" ? "Timeout Generic Exception Message" : result.message as String)
                    //}
                }
            }
            }, failure: { (error) -> Void in                //if(!self.removedFromParent)
            
                //self.refreshControl?.endRefreshing()
                self.hideBusyIndicator()
                self.showAlert("Error Title", messageKey: "Timeout Generic Exception Message")
                
        })
        
    }
    
    /*override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }*/
}
