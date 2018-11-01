//
//  BillViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/3/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit
import AVFoundation

class BillViewController: BaseViewController {

    @IBOutlet weak var lblTitleBill: UILabel!
    @IBOutlet weak var lblConfirmDesc: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblActionDesc: UILabel!
    @IBOutlet weak var viewActionDesc: UIView!
    @IBOutlet weak var btnCerrar: UIButton!
    @IBOutlet weak var viewMainDetails: UIView!
    @IBOutlet weak var viewTotal: UIView!
    @IBOutlet weak var viewMainDetailsHeight: NSLayoutConstraint!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var viewShare: UIView!
    @IBOutlet weak var viewLogo: UIView!
    @IBOutlet weak var viewLogoHeight: NSLayoutConstraint!
    @IBOutlet weak var viewTop: NSLayoutConstraint!
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var viewButtonsHeight: NSLayoutConstraint!
    
    var titleBill: String = ""
    var confirmDesc: String = ""
    var actionDesc: String = ""
    var accountToUse: Account! = nil
    var contactToUse: Contact! = nil
    var serviceToPay: ReceiptService! = nil
    var mainViewController: BaseViewController!
    var modalReceipt: BaseViewController!
    var player: AVAudioPlayer?
    var sectionType: String = ""
    var amount: String = ""
    var info1: String = ""
    var info2: String = ""
    var info3: String = ""
    var info4: String = ""
    // TRANSFER
    var fromAccount: Account! = nil
    var amountFinal: String = ""
    var transferType: TransferType! = nil
    var exchangeRate: String = ""
    var debitAmount: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblTitleBill.text = self.titleBill
        self.lblConfirmDesc.text = self.confirmDesc
        self.lblActionDesc.text = self.actionDesc
        self.lblTotal.text = self.amount
        self.setDesign()
        if UIScreen.main.bounds.size.height < 600 {
            self.viewLogoHeight.constant = 90
            self.viewLogo.layoutIfNeeded()
        }
        self.addSubViewController()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async() {
            self.viewButtonsHeight.constant = UIApplication.shared.statusBarOrientation.isLandscape ? 50 : 150
            self.viewLogoHeight.constant = UIApplication.shared.statusBarOrientation.isLandscape ? 140 : 180
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let moveUp = CGAffineTransform(translationX: 0, y: (self.viewTotal.frame.height * -2))
        self.viewTotal.transform = moveUp
        if UIApplication.shared.statusBarOrientation.isLandscape {
            DispatchQueue.main.async() {
                self.viewButtonsHeight.constant = 50
                self.viewLogoHeight.constant = 140
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.playSound()
        UIView.animate(withDuration: 2, delay: 0, options: [], animations: {
            let moveDown = CGAffineTransform(translationX: 0, y: 0)
            self.viewTotal.transform = moveDown
        }, completion: nil )
    }
    
    func playSound(){
        guard let url = Bundle.main.url(forResource: "printBill", withExtension: "wav") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            player.play()
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    func setDesign(){
        self.viewActionDesc.layer.cornerRadius = 12.5
        self.btnCerrar.layer.cornerRadius = 3
    }
    
    func addSubViewController(){
        if self.accountToUse != nil {
            switch self.sectionType {
            case "servicios":
                if self.serviceToPay != nil {
                    self.viewMainDetailsHeight.constant = 168
                    self.viewMainDetails.layoutIfNeeded()
                    let subViewController = storyboard!.instantiateViewController(withIdentifier: "DetailReceiptServiceSubViewController") as! DetailReceiptServiceSubViewController
                    addChildViewController(subViewController)
                    subViewController.view.frame = self.viewMainDetails.bounds
                    subViewController.set(service: self.serviceToPay, account: self.accountToUse, voucher: self.info1, date: self.info2, type: self.info3, bill: true)
                    self.viewMainDetails.addSubview(subViewController.view)
                }
                break
            case "creditos":
                if self.serviceToPay != nil {
                    let subViewController = storyboard!.instantiateViewController(withIdentifier: "DetailReceiptCreditSubViewController") as! DetailReceiptCreditSubViewController
                    addChildViewController(subViewController)
                    subViewController.view.frame = self.viewMainDetails.bounds
                    subViewController.set(service: self.serviceToPay, account: self.accountToUse, type: self.info1, alias: self.info2, bill: true)
                    self.viewMainDetails.addSubview(subViewController.view)
                }
                break
            case "sinpe":
                self.btnShare.isHidden = false
                self.viewMainDetailsHeight.constant = 154
                self.viewMainDetails.layoutIfNeeded()
                let subViewController = storyboard!.instantiateViewController(withIdentifier: "DetailReceiptSinpeSubViewController") as! DetailReceiptSinpeSubViewController
                addChildViewController(subViewController)
                subViewController.view.frame = self.viewMainDetails.bounds
                subViewController.set(account: self.accountToUse, description: self.info1, contact: self.contactToUse, bill: true, voucher: self.info2, date: self.info3)
                self.viewMainDetails.addSubview(subViewController.view)
                break
            case "transferencias":
                //self.viewMainDetailsHeight.constant = (self.transferType.id.description.range(of:"1") != nil) ? 182 : 210
                self.viewMainDetailsHeight.constant = (self.transferType.id.description.range(of:"1") != nil)
                    ? ((self.fromAccount.currencySign == self.accountToUse.currencySign) ? 182 : 210) // cuando es Entre Cuentas con cambio de moneda o no
                    : 210
                self.viewMainDetails.layoutIfNeeded()
                let subViewController = storyboard!.instantiateViewController(withIdentifier: "DetailReceiptTransferSubViewController") as! DetailReceiptTransferSubViewController
                addChildViewController(subViewController)
                subViewController.view.frame = self.viewMainDetails.bounds
                subViewController.set(fromAccount: self.fromAccount, originAccount: self.accountToUse, description: self.info1,
                                      amountFinal: self.amountFinal, transferType: self.transferType, bill: true, exchangeRate: self.exchangeRate,
                                      debitAmount: self.debitAmount, voucher: info2, date: info3)
                self.viewMainDetails.addSubview(subViewController.view)
                break
            default:
                print("default")
                break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func closeBill(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            self.modalReceipt.dismiss(animated: false, completion: {
                switch self.sectionType {
                case "servicios":
                    (self.mainViewController as! DetailServiceViewController).backAction()
                    break
                case "creditos":
                    (self.mainViewController as! CreditDetailViewController).backAction()
                    (self.mainViewController as! CreditDetailViewController).backAction()
                    break
                case "sinpe":
                    (self.mainViewController as! SinpeTransactionsViewController).transactionSuccess()
                    break
                case "transferencias":
                    (self.mainViewController as! TransactionsViewController).cleanScreen()
                    break
                default:
                    print("default")
                    break
                }
            })
        })
    }

    @IBAction func share(_ sender: UIButton) {
        let imageToShare = [self.asImage()]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: self.viewShare.bounds)
        return renderer.image { rendererContext in
            self.viewShare.layer.render(in: rendererContext.cgContext)
        }
    }
    
}
