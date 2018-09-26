//
//  CreditCalculatorViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit
import SideMenu

class CreditCalculatorViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var creditTableView: UITableView!
    @IBOutlet weak var btnCalcular: UIButton!
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var sldMonto: UISlider!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var monthCollection: UICollectionView!
    
    var creditInfo: CreditInfo? = nil
    var credit: CreditType? = nil
    var amount: Int = 0
    var limits: Array<CreditMonth> = []
    var monthsSelected: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.disableButton(btn: self.btnCalcular)
        self.setDesign()
        self.txtAmount.text = "0"
        self.bodyView.isHidden = true
        self.btnCalcular.isHidden = true
        self.loadCreditCatalogs()
    }
    
    func setDesign() {
        self.btnCalcular.layer.cornerRadius = 3
        self.txtAmount.layer.borderWidth = 0.7
        self.txtAmount.layer.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
        self.txtAmount.layer.cornerRadius = 4
        self.monthCollection.layer.borderWidth = 0.7
        self.monthCollection.layer.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
        self.monthCollection.layer.cornerRadius = 4
        self.sldMonto.setThumbImage(self.resizeImage(image: UIImage(named: "slideCalculator")!, newWidth: 25), for: UIControlState.normal)
    }
    
    func changeDesignAmount(){
        if self.amount > (self.credit?.minAmount)! {
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                self.txtAmount.backgroundColor = UIColor(red:0.00, green:0.44, blue:0.73, alpha:1.0)
                self.txtAmount.layer.borderColor = UIColor(red:0.00, green:0.44, blue:0.73, alpha:1.0).cgColor
                self.txtAmount.textColor = UIColor.white
                (self.txtAmount.leftView as! UILabel).textColor = self.txtAmount.textColor
            }, completion: nil )
        }
        else{
            UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                self.txtAmount.backgroundColor = UIColor.white
                self.txtAmount.layer.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
                self.txtAmount.textColor = UIColor(red:0.00, green:0.44, blue:0.73, alpha:1.0)
                (self.txtAmount.leftView as! UILabel).textColor = self.txtAmount.textColor
            }, completion: nil )
        }
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Collection View
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.creditInfo != nil {
            return (self.limits.count)
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let valor = self.limits[indexPath.row].selected
        if valor {
            self.monthsSelected = nil
        }
        else{
            for item in self.limits {
                item.selected = false
            }
            self.monthsSelected = self.limits[indexPath.row].month
        }
        self.limits[indexPath.row].selected = !valor
        self.monthCollection.reloadData()
        self.validForm()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MonthCreditCell = self.monthCollection.dequeueReusableCell(withReuseIdentifier: "monthCredit", for: indexPath) as! MonthCreditCell
        cell.show(creditMonth: self.limits[indexPath.row])
        if (cell.layer.sublayers?.count)! > 1{
            cell.layer.sublayers?.remove(at: 1)
        }
        if indexPath.row > 0 {
            let border = CALayer()
            border.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.2).cgColor
            border.frame = CGRect(x: 0, y: 0, width: 1, height: (self.monthCollection.frame.size.height))
            border.borderWidth = 0.7
            cell.layer.addSublayer(border)
            cell.layer.masksToBounds = true
        }
        return cell
    }
    
    // Table View
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        if self.creditInfo != nil {
            if ((self.creditInfo?.types.count)! < 1 || (self.creditInfo?.limits.count)! < 1) {
                self.showAlert("Atención", messageKey: "No existen tipos de crédito")
            }
            else{
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "SelectProductViewController") as! SelectProductViewController
                vc.products = (self.creditInfo?.copy() as? CreditInfo)?.types as Array<CreditType>?
                vc.mainViewController = self
                vc.productSelected = self.credit
                vc.productType = "credito"
                self.show(vc, sender: nil)
            }
        }
        else{
            self.showAlert("Atención", messageKey: "Ocurrió un error intente de nuevo")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.creditTableView.dequeueReusableCell(withIdentifier: "InfoCreditCell", for: indexPath) as! InfoCreditCell
        if self.credit != nil {
            cell.show(product: "Crédito", typeCredit: (self.credit?.name)!, interest: (self.credit?.rateShow)!, currency: (self.credit?.currencyName)!, selectCredit: "")
        }
        else{
            cell.show(product: "Crédito", typeCredit: "", interest: "", currency: "", selectCredit: "Seleccione el tipo")
        }
        if((cell.layer.sublayers?.count)! < 4) {
            let border = CALayer()
            border.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.2).cgColor
            border.frame = CGRect(x: 15, y: (cell.frame.size.height) - 1, width: (cell.frame.size.width) - 30, height: 1)
            border.borderWidth = 1
            cell.layer.addSublayer(border)
            cell.layer.masksToBounds = true
        }
        return cell
    }
    
    override func cleanProductSelect(type: String){
        self.credit = nil
        self.bodyView.isHidden = true
        self.btnCalcular.isHidden = true
        self.creditTableView.reloadData()
    }
    
    override func assignProductSelect(product: SelectableProduct, type: String){
        let credit = product as! CreditType
        self.credit = credit
        self.sldMonto.minimumValue = Float((self.credit?.minAmount)!)
        self.sldMonto.maximumValue = Float((self.credit?.maxAmount)!)
        self.sldMonto.value = Float((self.credit?.minAmount)!)
        self.amount = (self.credit?.minAmount)!
        self.txtAmount.leftViewMode = UITextFieldViewMode.always
        let labelFrame = CGRect(x: 0, y: 0, width: 15, height: 40)
        let label = UILabel(frame: labelFrame)
        label.text = (self.credit?.currencySign == "COL") ? "  ¢" : "  $"
        label.font = self.txtAmount.font
        label.textColor = self.txtAmount.textColor
        self.txtAmount.leftView = label
        self.txtAmount.text = Helper.formatAmountInt(self.amount as NSNumber)
        self.monthsSelected = nil
        self.limits = []
        (self.creditInfo?.limits.map({(creditMonth) -> Bool in
            creditMonth.selected = false
            if (creditMonth.month >= (self.credit?.minPeriod)! && creditMonth.month <= (self.credit?.maxPeriod)!) {
                self.limits.append(creditMonth)
            }
            return true
        }))
        self.monthCollection.reloadData()
        self.changeDesignAmount()
        self.bodyView.isHidden = false
        self.btnCalcular.isHidden = false
        self.creditTableView.reloadData()
        self.validForm()
    }
    
    func loadCreditCatalogs(){
        self.showBusyIndicator("Loading Data")
        ProxyManager.GetCreditCatalogs(success: {
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess {
                    self.creditInfo = result.info
                    self.hideBusyIndicator()
                    if ((self.creditInfo?.types.count)! < 1 || (self.creditInfo?.limits.count)! < 1) {
                        self.showAlert("Atención", messageKey: "No existen tipos de crédito")
                    }
                }
                else {
                    self.hideBusyIndicator()
                    if(self.sessionTimeOutException(result.code as String) == false){
                        self.showAlert("Error Title", messageKey: result.message as String == "" ? "Timeout Generic Exception Message" : result.message as String)
                    }
                }
            })
        }, failure: { (error) -> Void in
            self.hideBusyIndicator()
            self.showAlert("Error Title", messageKey: "Timeout Generic Exception Message")
        })
    }
    
    @IBAction func changeAmount(_ sender: UISlider) {
        self.view.endEditing(true)
        self.amount = Int(sender.value)
        self.txtAmount.text = Helper.formatAmountInt(self.amount as NSNumber)
        self.changeDesignAmount()
        self.validForm()
    }
    
    @IBAction func changeAmountText(_ sender: UITextField) {
        self.maxLenght(textField: sender, maxLength: 11)
        let amountWithoutFormat = Helper.removeFormatAmount(self.txtAmount.text)
        self.sldMonto.value = (amountWithoutFormat as NSString).floatValue
        let amountSender = Int(amountWithoutFormat)
        let amountCheck = (amountSender == nil) ? 0 : amountSender
        self.amount = amountCheck!
        self.changeDesignAmount()
        self.txtAmount.text = Helper.formatAmountInt(self.amount as NSNumber)
        self.validForm()
    }
    
    func getCreditCalc(){
        self.showBusyIndicator("Loading Data")
        let request : CreditCalculatorRequest = CreditCalculatorRequest()
        request.amount = self.amount as NSNumber
        request.creditTypeId = (self.credit?.id)!
        request.currencyTypeId = (self.credit?.currencyId)!
        request.interest = (self.credit?.rate)!
        request.term = self.monthsSelected! as NSNumber
        ProxyManager.GetCreditCalc(data: request, success: {
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess {
                    self.prepareReceipt(calc: result.data!)
                }
                else {
                    self.hideBusyIndicator()
                    if(self.sessionTimeOutException(result.code as String) == false){
                        self.showAlert("Error Title", messageKey: result.message as String == "" ? "Timeout Generic Exception Message" : result.message as String)
                    }
                }
            })
        }, failure: { (error) -> Void in
            self.hideBusyIndicator()
            self.showAlert("Error Title", messageKey: "Timeout Generic Exception Message")
        })
    }
    
    func prepareReceipt(calc: CreditCalculatorResult){
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "ReceiptCalculatorViewController") as! ReceiptCalculatorViewController
        vc.titleScreen = "Calculadora de Crédito"
        vc.typeCalc = calc.creditTypeName
        vc.amountTotal = Helper.formatAmount(calc.quota, currencySign: calc.currencySign)
        vc.desc = "Cuota Mensual Aproximada"
        vc.firstDetail = calc.rateShow + " / Moneda: " + calc.currencyName
        vc.secondDetail = "Monto: " + Helper.formatAmount(calc.amount, currencySign: calc.currencySign)
        vc.thirdDetail = "Plazo: " + calc.periodDescription
        vc.infoCalc = calc.noteTitle + " " + calc.note
        self.hideBusyIndicator()
        self.present(vc, animated: true)
    }
    
    @IBAction func calcular(_ sender: UIButton) {
        self.getCreditCalc()
    }
    
    func validForm(){
        self.disableButton(btn: self.btnCalcular)
        if self.monthsSelected != nil {
            if self.amount >= (self.credit?.minAmount)! {
                if self.amount <= (self.credit?.maxAmount)! {
                    self.enableButton(btn: self.btnCalcular)
                }
            }
        }
    }
    
}
