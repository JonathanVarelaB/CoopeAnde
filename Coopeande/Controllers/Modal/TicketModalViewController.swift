//
//  TicketModalViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 21/8/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class TicketModalViewController: BaseModalViewController, ConfirmActionViewDelegate,UITextFieldDelegate
{
    let keyboadHeight:CGFloat = 100
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tvAddress: UITextView!
    @IBOutlet weak var lblPeopleQueue: UILabel!
    @IBOutlet weak var lblQueueTime: UILabel!
    
    @IBOutlet weak var btbSolicitar: UIButton!
    
    var placeDetail: PlaceDetail?
    var ticketId : String?
    var ticketMessage : String?
    var latitude: NSNumber?
    var longitude: NSNumber?
    var movedY : CGFloat = 0
    @IBOutlet weak var getTicketButton: UIButton!
    
    @IBOutlet weak var txtId: UITextField!
    @IBAction func getTicket(sender: AnyObject) {
        getTicketButton.isEnabled = false;
        
        //getTicketCRM()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        txtId.delegate = self
        btbSolicitar.isEnabled = false
        addToolButtonToKeyboard()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.showData()
        if(self.view.superview != nil ) && (Constants.iPhone)
        {
            self.view.frame.size.width =  self.view.superview!.frame.width
        }
    }
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        /*if (segue.identifier == "swTicket")
        {
            var controller =  segue.destinationViewController as ResultViewController
            var resultView = Helper.getViewController("TicketResultViewController") as TicketResultViewController
            resultView.placeDetail = self.placeDetail
            resultView.ticketId = self.ticketId
            resultView.ticketMessage = self.ticketMessage!
            controller.invoiceDetail = resultView
            controller.delegate = self
        }*/
    }
    
    
    
    ///UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        // if (self.txtId.text.length == 6)
        //{
        btbSolicitar.isEnabled = (self.txtId.text?.count)! > 0
        //}
        self.moveViewBack()
    }
    func addToolButtonToKeyboard()
    {
        let myToolbar : UIToolbar =  UIToolbar();
        //myToolbar.barStyle = UIBarStyle.Black
        myToolbar.isTranslucent = true;
        myToolbar.isUserInteractionEnabled = true;
        myToolbar.sizeToFit();
        let btnOK = UIBarButtonItem(title:Helper.getLocalizedText("Ok"), style: .plain, target: self, action:#selector(doneClicked))
        btnOK.setTitleTextAttributes(Style.navButtonTextAttributes as? [NSAttributedStringKey : Any], for: UIControlState.normal)
        myToolbar.setItems([btnOK], animated: true);
        
        txtId.inputAccessoryView = myToolbar;
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        movedY = (self.txtId.frame.height + self.keyboadHeight)
        if(Constants.iOS8)
        {
            self.view.center.y -= movedY
        }
        else
        {
            if( Constants.orientation == UIInterfaceOrientation.landscapeRight)
            {
                movedY = movedY * -1
            }
            self.view.center.x -= movedY
            
        }
    }
    ///MARK HElPER
    func hideKeyboard()
    {
        
        txtId.endEditing(true)
        self.moveViewBack()
        
    }
    func moveViewBack()
    {
        if(Constants.iOS8)
        {
            self.view.center.y += movedY
        }
        else
        {
            
            self.view.center.x += movedY
        }
        movedY = 0
        
    }
    @objc func doneClicked (sender : UIBarButtonItem)
    {
        self.hideKeyboard()
    }
    func showData()
    {
        if let detail = self.placeDetail
        {
            tvAddress.text = detail.address as String
            lblQueueTime.text = detail.timeWaiting as String
            lblPeopleQueue.text = detail.peopleWaiting as String
            lblName.text = detail.name as String
        }
    }
    /*func getTicketCRM()
    {
        var ticketRequest : TicketCRMRequest = TicketCRMRequest()
        ticketRequest.latitude = self.latitude!
        ticketRequest.customerId = txtId.text
        ticketRequest.longitude = self.longitude!
        ticketRequest.placeId = self.placeDetail!.placeId
        self.showBusyIndicator("Loading Data")
        ProxyManager.GetTicketCRM(ticketRequest, success: {
            (result) in
            if result.isSuccess
            {
                NSOperationQueue.mainQueue().addOperationWithBlock({() in
                    self.hideBusyIndicator()
                    self.PrintResults(result)
                })
            }
            else
            {
                self.hideBusyIndicator()
                self.getTicketButton.enabled = true
                self.showAlert("Login Exception Title", messageKey: result.message)
                
            }
        },
                                  failure: { (error) -> Void in
                                    self.getTicketButton.enabled = true
                                    self.hideBusyIndicator()
                                    self.showAlert("Login Exception Title", messageKey: "Login Generic Exception Message")
        })
    }
    func PrintResults(result : TicketCRMResponse)
    {
        self.ticketId = result.data?.ticketId
        self.ticketMessage = result.data?.confirmationMessage
        self.performSegue(withIdentifier: "swTicket", sender: self)
        //self.dismissViewControllerAnimated(true, completion:nil)
        self.view.isHidden = true
    }*/
    
    ///MARK ConfirmActionViewDelegate
    func confirmActionViewOk(alertController:UIViewController?)
    {
        self.dismiss(animated: true, completion:nil)
    }
    func confirmActionViewCancel(alertController:UIViewController?)
    {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        return Helper.formatAnyNumberOrAmount(textField, shouldChangeCharactersInRange: range, replacementString: string, maxAmountDigits: 30, formatIndicator: 1);
    }
    
    
}
