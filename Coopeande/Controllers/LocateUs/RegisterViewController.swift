//
//  RegisterViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 10/2/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController {

    @IBOutlet weak var txtId: UITextField!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UITextView!
    @IBOutlet weak var lblPeople: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var btnRequest: UIButton!
    @IBOutlet weak var viewMain: UIView!
    
    var detail: PlaceDetail!
    var categorySelected: PlaceCategory!
    var latitudeUser: NSNumber = 0
    var longitudeUser: NSNumber = 0
    var modalPrevious: PlaceDetailViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.16, green:0.44, blue:0.79, alpha:0.8)
        self.lblName.text = self.detail.name.description
        self.lblAddress.text = self.detail.address.description
        self.lblPeople.text = self.detail.peopleWaiting.description
        self.lblTime.text = self.detail.timeWaiting.description
        self.lblPhone.text = self.detail.phone?.description
        self.txtId.delegate = self
        self.setDesign()
    }
    
    func setDesign(){
        self.disableButton(btn: self.btnRequest)
        self.viewMain.layer.cornerRadius = 7
        self.btnRequest.layer.cornerRadius = 5
        let border = CALayer()
        border.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.2).cgColor
        border.frame = CGRect(x: 0, y: (self.viewAddress.frame.size.height) - 1, width: self.viewAddress.frame.size.width, height: 1)
        border.borderWidth = 1
        self.viewAddress.layer.addSublayer(border)
        self.viewAddress.layer.masksToBounds = true
        let border1 = CALayer()
        border1.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.2).cgColor
        border1.frame = CGRect(x: 0, y: (self.viewPhone.frame.size.height) - 1, width: self.viewPhone.frame.size.width, height: 1)
        border1.borderWidth = 1
        let border2 = CALayer()
        border2.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.2).cgColor
        border2.frame = CGRect(x: 0, y: 0, width: self.viewPhone.frame.size.width, height: 1)
        border2.borderWidth = 1
        self.viewPhone.layer.addSublayer(border1)
        self.viewPhone.layer.addSublayer(border2)
        self.viewPhone.layer.masksToBounds = true
        self.txtId.layer.borderWidth = 0.7
        self.txtId.layer.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
        self.txtId.layer.cornerRadius = 4
        self.txtId.leftViewMode = UITextFieldViewMode.always
        self.txtId.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.txtId.frame.height))
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(PlaceDetailViewController.call))
        self.lblPhone.isUserInteractionEnabled = true
        self.lblPhone.addGestureRecognizer(singleTap)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.modalPrevious.dismiss(animated: false, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @objc func call(){
        let p = Helper.removeFormatAmount(detail.phone?.description)
        if let url = URL(string: "tel://" + p) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func changeId(_ sender: UITextField) {
        self.txtId.text = Helper.validNumber(sender.text)
        self.maxLenght(textField: sender, maxLength: 30)
        self.validId()
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func request(_ sender: UIButton) {
        self.showBusyIndicator("Loading Data")
        let request = TicketCRMRequest()
        request.customerId = NSString(string: self.txtId.text!)
        request.latitude = self.latitudeUser
        request.longitude = self.longitudeUser
        request.placeId = self.detail.placeId
        ProxyManager.GetTicketCRM(data: request ,success:{
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess{
                    let vc = self.storyboard!.instantiateViewController(withIdentifier: "VoucherViewController") as! VoucherViewController
                    vc.number = (result.data?.ticketId.description)!
                    vc.name = self.detail.name.description
                    vc.address = self.detail.address.description
                    vc.confirmation = (result.data?.confirmationMessage.description)!
                    vc.modalPrevious = self
                    vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                    self.hideBusyIndicator()
                    self.present(vc, animated: true, completion: nil)
                }
                else{
                    self.hideBusyIndicator()
                    self.showAlert("Error Title", messageKey: result.message as String)
                }
            })
        },
        failure: { (error) -> Void in
            DispatchQueue.main.async {
                self.hideBusyIndicator()
                self.showAlert("Login Exception Title", messageKey: error.userInfo["message"] as! String)
            }
        })
    }
    
    func validId(){
        self.disableButton(btn: self.btnRequest)
        if (self.txtId.text?.count)! > 8 {
            self.enableButton(btn: self.btnRequest)
        }
    }
    
}
