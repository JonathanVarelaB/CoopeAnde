//
//  ReceiptCalculatorViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/10/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class ReceiptCalculatorViewController: BaseViewController {

    @IBOutlet weak var lblTitleScreen: UILabel!
    @IBOutlet weak var lblTypeCalc: UILabel!
    @IBOutlet weak var lblAmountTotal: UILabel!
    @IBOutlet weak var viewDesc: UIView!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblFirstDetail: UILabel!
    @IBOutlet weak var lblSecondDetail: UILabel!
    @IBOutlet weak var lblThirdDetail: UILabel!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var viewInfoCalc: UIView!
    @IBOutlet weak var lblBottomDetail: UITextView!
    @IBOutlet weak var lblInfoCalc: UITextView!
    @IBOutlet weak var viewInfoCalcHeight: NSLayoutConstraint!
    
    
    var titleScreen: String = ""
    var typeCalc: String = ""
    var amountTotal: String = ""
    var desc: String = ""
    var firstDetail: String = ""
    var secondDetail: String = ""
    var thirdDetail: String = ""
    var bottomDetail: String = ""
    var infoCalc: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblTitleScreen.text = self.titleScreen
        self.lblTypeCalc.text = self.typeCalc
        self.lblAmountTotal.text = self.amountTotal
        self.lblDesc.text = self.desc
        self.lblFirstDetail.text = self.firstDetail
        self.lblSecondDetail.text = self.secondDetail
        self.lblThirdDetail.text = self.thirdDetail
        self.lblBottomDetail.text = self.bottomDetail
        if self.bottomDetail == "" && self.infoCalc != "" {
            DispatchQueue.main.async() {
                self.viewInfoCalcHeight.constant = 120
                self.view.layoutIfNeeded()
            }
        }
        self.lblInfoCalc.text = self.infoCalc
        self.setDesign()
        let borderTop = CALayer()
        borderTop.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.5).cgColor
        borderTop.frame = CGRect(x: 0, y: 0, width: self.viewInfoCalc.bounds.width, height: 1)
        borderTop.borderWidth = 1
        let borderBottom = CALayer()
        borderBottom.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.5).cgColor
        borderBottom.frame = CGRect(x: 0, y: self.viewInfoCalc.bounds.height - 1, width: self.viewInfoCalc.bounds.width, height: 1)
        borderBottom.borderWidth = 1
        self.viewInfoCalc.layer.addSublayer(borderTop)
        //self.viewInfoCalc.layer.addSublayer(borderBottom)
        self.viewInfoCalc.layer.masksToBounds = true
    }
    
    func setDesign(){
        self.viewDesc.layer.cornerRadius = 12.5
        self.btnAccept.layer.cornerRadius = 3
        self.viewBody.layer.cornerRadius = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func acept(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
