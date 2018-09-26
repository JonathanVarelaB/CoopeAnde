//
//  AccountTransferViewController1.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 22/8/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class AccountTransferViewController1: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, ConfirmActionViewDelegate,InputDataChangeDelegate,SessionTimeOutDelegate {

    @IBOutlet weak var typeTransferCollection: UICollectionView!
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var optionsTableView: UITableView!
    
    var clearAfterViewDidAppear : Bool = false
    var transferFormController : TransferFormViewController?
    //var resultView : TranferResultViewController?
    
    var delegate : SelectedTrasferTypeBackDelegate?
    var sessionTimeOutDelegate : SessionTimeOutDelegate?
    var dataResponse : TransferTypes?
    var SelectedTransferTypeId : NSString = ""
    //var ProxyManager :UtilProxyManager = UtilProxyManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(clearAfterViewDidAppear)
        {
            clearAfterViewDidAppear = false
            if transferFormController != nil
            {
                transferFormController!.cleanData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData()
    {
        self.showBusyIndicator( "Loading Data")
        ProxyManager.TransferTypes (success: {
            (result) in
            self.hideBusyIndicator()
            DispatchQueue.main.async {
            if result.isSuccess
            {
                    self.dataResponse = result.data
                    self.typeTransferCollection.reloadData()
            }
            else
            {
                if(self.sessionTimeOutDelegate!.onSessionTimeOutException(code: result.code as String) == false)
                {
                    self.showAlert("Error Title", messageKey: result.message as String == "" ? "Timeout Generic Exception Message" : result.message as String)
                }
            }
            }
        }, failure: { (error) -> Void in                 if(!self.removedFromParent)
        {
            //self.refreshControl?.endRefreshing()
            self.hideBusyIndicator()
            self.showAlert("Error Title", messageKey: "Timeout Generic Exception Message")
            }
        })
    }
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let data = dataResponse
        {
            return data.list.count //data.list.count.integerValue
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let CellIdentifier = "detail"
        
        let colorArray = [UIColor(red:0.00, green:0.44, blue:0.73, alpha:1.0), UIColor(red:0.95, green:0.76, blue:0.09, alpha:1.0), UIColor(red:0.93, green:0.11, blue:0.18, alpha:1.0), UIColor(red:0.56, green:0.25, blue:0.60, alpha:1.0)]
        let imgArray = ["SInpePosterior","SInpeColones","SInpeDolares","SInpePosterior"]
        
        let cell:TipoTransferenciaCell = typeTransferCollection.dequeueReusableCell(withReuseIdentifier: CellIdentifier, for: indexPath) as! TipoTransferenciaCell
        if let data = dataResponse?.list[indexPath.row]
        {
            cell.show(id: data.id, name: data.name, commission: data.commission!, currencySign: data.currencySign)
            cell.backgroundColor = colorArray[indexPath.row]
            cell.imgTipoTrasnferencia.image = UIImage(named: imgArray[indexPath.row])
            /*if(data.id == self.SelectedTransferTypeId)
             {
             cell.accessoryType = UITableViewCellAccessoryType.Checkmark
             }*/
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //var CellIdentifier = "detail"
        // var cell: TipoTransferenciaCell = self.tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as TipoTransferenciaCell
        
        
        if let cell = dataResponse?.list[indexPath.row]
        {
            print("ID Servicio",cell.id)
            delegate?.SelectedTransferTypeBack(selectedTransferType: cell)
        }
        
        //self.navigationController?.popViewController(animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionsTableView.dequeueReusableCell(withIdentifier: "originAccount", for: indexPath)
        return cell
    }
    
    func isRequiredDataReady() -> (Bool,String)
    {
        
        let result = (true,"")
        if  let  formData = transferFormController
        {
            
            if( formData.selectedTransferType == nil)
            {
                return   (false,"Select type of transfer")
            }
            if( formData.selectedAccountFrom == nil)
            {
                return  (false,"Select source account")
            }
            if( formData.selectedAccountTo == nil)
            {
                return (false,"Select destination account")
            }
            if( formData.selectedAccountTo!.aliasName == formData.selectedAccountFrom?.aliasName)
            {
                return (false,"From account and to account must be different")
            }
            
            //if( formData.transferToSubmit.reason.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet).count == 0)
            if( formData.transferToSubmit.reason.trimmingCharacters(in: NSCharacterSet.whitespaces).count == 0)
            {
                return   (false,"Input the reason to transfer")
            }
            //            if( formData.transferToSubmit.reason.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).length < 15)
            //            {
            //                return   (false,"Input the reason to transfer greatter than 15")
            //            }
            if let amount = formData.transferToSubmit.total
            {
                if amount.doubleValue <= 0
                {
                    return   (false,"Input the amout to transfer")
                }
            }
            else
            {
                return  (false,"Input only number for the amount")
            }
        }
        return result
    }
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "swTransferenciaFormulario")
        {
            transferFormController =  segue.destination as? TransferFormViewController
            transferFormController!.inputDataChangeDelegate = self
            transferFormController!.sessionTimeOutDelegate = self
        }
        
        /*if (segue.identifier == "swResult")
         {
         var controller =  segue.destinationViewController as ResultViewController
         self.resultView!.header =  Helper.getLocalizedText("Transfer Applied Successfully Title")
         self.resultView!.subHeader = Helper.getLocalizedText("Transfer Applied Successfully Subtitle")
         
         controller.invoiceDetail = resultView
         }*/
    }
    ///MARK Helper
    
    func doTransfer()
    {
        self.btnPay.isEnabled = false
        if  let  data = transferFormController
        {
            
            self.showBusyIndicator("Loading Data")
            ProxyManager.ApplyTransfer(data: data.transferToSubmit, success: {
                (result) in
                if(!self.removedFromParent)
                {
                    DispatchQueue.main.async {
                    if result.isSuccess
                    {
                        self.clearAfterViewDidAppear = true
                            self.hideBusyIndicator()
                            //self.resultView!.items = result.data!.detail!.list
                            self.performSegue(withIdentifier: "swResult", sender: self)
                            //self.dataResponse = result.data
                            //self.tableView.reloadData()
                    }
                    else
                    {
                        self.hideBusyIndicator()
                        if(self.sessionTimeOutException(result.code as String) == false)
                        {
                            self.clearAfterViewDidAppear = false
                            self.btnPay.isEnabled = true
                            
                            self.showAlert("Error Title", messageKey: result.message as String == "" ? "Timeout Generic Exception Message" : result.message as String)
                        }
                    }
                    }
                }}, failure: { (error) -> Void in                    if(!self.removedFromParent)
                {
                    self.clearAfterViewDidAppear = false
                    self.btnPay.isEnabled = true
                    self.hideBusyIndicator()
                    self.showAlert("Error Title", messageKey: "Timeout Generic Exception Message")
                    }
            })
        }
    }
    
    ///MARK ConfirmActionViewDelegate
    
    func confirmActionViewCancel(alertController:UIViewController?)
    {
        self.btnPay.isEnabled = true
        alertController?.dismiss(animated: true, completion: nil)
    }
    func confirmActionViewOk(alertController:UIViewController?)
    {
        alertController?.dismiss(animated: true, completion:
            {
                self.doTransfer()
        })
    }
    
    ///MARK InputDataChangeDelegate
    
    func inputDataChange() {
        
        if let inputControls = transferFormController
        {
            OperationQueue.main.addOperation({
                self.btnPay.isEnabled = inputControls.isRequiredDataReady().0
            })
            
        }
    }
    ///MARK SessionTimeOutException
    
    func onSessionTimeOutException(code:String) -> Bool
    {
        return super.sessionTimeOutException(code)
    }
    
}
