//
//  SavingCalculatorViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class SavingCalculatorViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var savingTableView: UITableView!
    @IBOutlet weak var btnCalcular: UIButton!
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var sldAmount: UISlider!
    @IBOutlet weak var txtInitialDate: UITextField!
    @IBOutlet weak var txtFinalDate: UITextField!
    @IBOutlet weak var lblAmountTypeSave: UILabel!
    @IBOutlet weak var lblNoteTypeSave: UILabel!
    
    var calculatorTypes: CalculatorTypes? = nil
    var calculator: CalculatorType? = nil
    var saving: SavingType? = nil
    var amount: Int = 0
    let initialDatePicker = MonthYearPickerView()
    let finalDatePicker = MonthYearPickerView()
    var initialMonth: Int = 0
    var initialYear: Int = 0
    var finalMonth: Int = 0
    var finalYear: Int = 0
    var actualMonth: Int = 0
    var actualYear: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (Constants.iPhone) ? self.keyboardEvents() : nil
        self.txtAmount.delegate = self
        self.disableButton(btn: self.btnCalcular)
        self.actualMonth = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.month, from: NSDate() as Date)
        self.actualYear = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: NSDate() as Date)
        self.txtAmount.text = "0"
        self.txtInitialDate.inputView = self.initialDatePicker
        self.txtFinalDate.inputView = self.finalDatePicker
        self.setDesign()
        self.hideBody()
        self.loadCalculatorTypes()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func keyboardEvents(){
        NotificationCenter.default.addObserver(self, selector: #selector(SavingCalculatorViewController.keyShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SavingCalculatorViewController.keyHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyShow(sender: NSNotification) {
        if self.txtAmount.isFirstResponder {
            var keyboardHeight : CGFloat! = nil
             if let keyboardFrame: NSValue = sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                keyboardHeight = keyboardFrame.cgRectValue.height
             }
             self.view.frame.origin.y = ((keyboardHeight - 60) * -1)
        }
    }
    
    @objc func keyHide(sender: NSNotification) {
        if self.txtAmount.isFirstResponder {
            self.view.frame.origin.y = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func setDesign() {
        self.btnCalcular.layer.cornerRadius = 3
        self.txtAmount.layer.borderWidth = 0.7
        self.txtAmount.layer.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
        self.txtAmount.layer.cornerRadius = 4
        self.txtInitialDate.layer.borderWidth = 0.7
        self.txtInitialDate.layer.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
        self.txtInitialDate.layer.cornerRadius = 4
        self.txtFinalDate.layer.borderWidth = 0.7
        self.txtFinalDate.layer.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
        self.txtFinalDate.layer.cornerRadius = 4
        self.txtFinalDate.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 30))
        self.txtFinalDate.leftViewMode = .always
        self.txtInitialDate.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 30))
        self.txtInitialDate.leftViewMode = .always
        self.sldAmount.setThumbImage(self.resizeImage(image: UIImage(named: "slideCalculator")!, newWidth: 25), for: UIControlState.normal)
    }
    
    func changeDesignAmount(){
        if self.amount > (self.saving?.minAmount)! {
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
    
    // Table View
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "SelectProductViewController") as! SelectProductViewController
        if self.calculatorTypes != nil {
            if indexPath.row > 0 {
                if (self.calculatorTypes?.savingList.count)! < 1 {
                    self.showAlert("Atención", messageKey: "No existen tipos de ahorro")
                }
                else{
                    vc.products = (self.calculatorTypes?.copy() as? CalculatorTypes)?.savingList as! Array<SavingType>
                    vc.mainViewController = self
                    vc.productSelected = self.saving
                    vc.productType = "ahorro"
                    self.show(vc, sender: nil)
                }
            }
            else{
                if (self.calculatorTypes?.calculationList.count)! < 1 {
                    self.showAlert("Atención", messageKey: "No existen tipos de cálculo")
                }
                else{
                    vc.products = (self.calculatorTypes?.copy() as? CalculatorTypes)?.calculationList as! Array<CalculatorType>
                    vc.mainViewController = self
                    vc.productSelected = self.calculator
                    vc.productType = "calculo"
                    self.show(vc, sender: nil)
                }
            }
        }
        else{
            self.showAlert("Atención", messageKey: "Ocurrió un error, intente de nuevo")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.savingTableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoCreditCell
        var typeProduct: String = "Cálculo"
        if indexPath.row > 0 {
            typeProduct = "Ahorro"
            if self.saving != nil {
                cell.show(product: typeProduct, typeCredit: (self.saving?.typeName)!, interest: (self.saving?.interestShow)!, currency: (self.saving?.currencyTypeName)!, selectCredit: "")
            }
            else{
                cell.show(product: typeProduct, typeCredit: "", interest: "", currency: "", selectCredit: "Seleccione el tipo")
            }
        }
        else{
            if self.calculator != nil {
                cell.show(product: typeProduct, typeCredit: "", interest: (self.calculator?.name)!, currency: "", selectCredit: "")
            }
            else{
                cell.show(product: typeProduct, typeCredit: "", interest: "", currency: "", selectCredit: "Seleccione el tipo")
            }
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
    
    override func assignProductSelect(product: SelectableProduct, type: String){
        if type == "calculo"{
            self.calculator = product as? CalculatorType
            self.lblAmountTypeSave.text = "Cuota Mensual"
            self.lblNoteTypeSave.text = "Calcule el monto final de ahorro de acuerdo a la cuota mensual meta"
            if self.calculator?.code == "M" {
                self.lblAmountTypeSave.text = "Ahorro Meta"
                self.lblNoteTypeSave.text = "Calcule cuánto debe ahorrar mensualmente para alcazar su ahorro meta"
            }
            if(self.saving != nil) {
                self.showBody()
            }
        }
        else{
            self.saving = product as? SavingType
            self.sldAmount.minimumValue = Float((self.saving?.minAmount)!)
            self.sldAmount.maximumValue = Float((self.saving?.maxAmount)!)
            self.sldAmount.value = Float((self.saving?.minAmount)!)
            self.amount = (self.saving?.minAmount)!
            self.initialMonth = 0
            self.initialYear = 0
            self.finalMonth = 0
            self.finalYear = 0
            self.txtAmount.leftViewMode = UITextFieldViewMode.always
            let labelFrame = CGRect(x: 0, y: 0, width: 20, height: 40)
            let label = UILabel(frame: labelFrame)
            label.text = (self.saving?.currencySign == "COL") ? "   ¢" : "   $"
            label.font = self.txtAmount.font
            label.textColor = self.txtAmount.textColor
            self.txtAmount.leftView = label
            self.txtAmount.text = Helper.formatAmountInt(self.amount.description)
            self.changeDesignAmount()
            self.txtInitialDate.text = ""
            self.txtFinalDate.text = ""
            self.initialDatePicker.commonSetup()
            self.finalDatePicker.commonSetup()
            if self.saving?.observations != "" {
                self.showAlert((self.saving?.typeName)!, messageKey: (self.saving?.observations)!)
            }
            if(self.calculator != nil) {
                self.showBody()
            }
        }
        self.savingTableView.reloadData()
        self.validForm()
    }
    
    func showBody(){
        self.bodyView.isHidden = false
        self.btnCalcular.isHidden = false
    }
    
    func hideBody(){
        self.bodyView.isHidden = true
        self.btnCalcular.isHidden = true
    }
    
    override func cleanProductSelect(type: String){
        if type == "calculo"{
            self.calculator = nil
        }
        else{
            self.saving = nil
        }
        self.hideBody()
        self.savingTableView.reloadData()
    }
    
    @IBAction func changeAmountTxt(_ sender: UITextField) {
        self.maxLenght(textField: sender, maxLength: 11)
        let amountWithoutFormat = Helper.removeFormatAmount(self.txtAmount.text)
        self.sldAmount.value = (amountWithoutFormat as NSString).floatValue
        let amountSender = Int(amountWithoutFormat)
        let amountCheck = (amountSender == nil) ? 0 : amountSender
        self.amount = amountCheck!
        self.changeDesignAmount()
        self.txtAmount.text = Helper.formatAmountInt(self.amount.description)
        self.validForm()
    }
    
    @IBAction func changeAmount(_ sender: UISlider) {
        self.view.endEditing(true)
        self.amount = Int(sender.value)
        self.txtAmount.text = Helper.formatAmountInt(self.amount.description)
        self.changeDesignAmount()
        self.validForm()
    }
    
    @IBAction func selectInitialDate(_ sender: UITextField) {
        self.initialDatePicker.onDateSelected = { (month: Int, monthName: String, year: Int) in
            if ((year == self.actualYear) && (month <= self.actualMonth)){
                self.initialMonth = 0
                self.initialYear = 0
                self.txtInitialDate.text = ""
                self.showAlert("Atención", messageKey: "El mes indicado es incorrecto")
            }
            else{
                let string = String(format: "%@ %d", monthName, year)
                self.initialMonth = month
                self.initialYear = year
                self.txtInitialDate.text = string
            }
            self.validForm()
        }
    }
    
    @IBAction func selectFinalDate(_ sender: UITextField) {
        self.finalDatePicker.onDateSelected = { (month: Int, monthName: String, year: Int) in
            if ((year == self.actualYear) && (month <= self.actualMonth)){
                self.finalMonth = 0
                self.finalYear = 0
                self.txtFinalDate.text = ""
                self.showAlert("Atención", messageKey: "El mes indicado es incorrecto")
            }
            else{
                self.finalMonth = month
                self.finalYear = year
                let string = String(format: "%@ %d", monthName, year)
                self.txtFinalDate.text = string
            }
            self.validForm()
        }
    }
    
    func loadCalculatorTypes(){
        self.showBusyIndicator("Loading Data")
        ProxyManager.GetCalculatorCatalogs (success: {
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess {
                    self.calculatorTypes = result.data
                    self.hideBusyIndicator()
                    if (self.calculatorTypes?.savingList.count)! < 1 {
                        self.showAlert("Atención", messageKey: "No existen tipos de ahorro")
                    }
                    else{
                        if (self.calculatorTypes?.calculationList.count)! < 1 {
                            self.showAlert("Atención", messageKey: "No existen tipos de cálculo")
                        }
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
            DispatchQueue.main.async {
                self.hideBusyIndicator()
                self.showAlert("Login Exception Title", messageKey: error.userInfo["message"] as! String)
            }
        })
    }
    
    func getSavingCalculator(){
        self.showBusyIndicator("Loading Data")
        let request : SavingCalculatorRequest = SavingCalculatorRequest()
        request.amount = self.amount
        request.beginMonth = self.initialMonth
        request.beginYear = self.initialYear
        request.calculatorTypeId = (self.calculator?.code)!
        request.currencyTypeId = (self.saving?.currencyTypeId)!
        request.endMonth = self.finalMonth
        request.endYear = self.finalYear
        request.interest = (self.saving?.interest.intValue)!
        request.saveTypeId = (self.saving?.typeId)!
        ProxyManager.getSavingCalculator(data: request, success: {
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess {
                    self.prepareReceipt(sav: result.data!)
                }
                else {
                    self.hideBusyIndicator()
                    if(self.sessionTimeOutException(result.code as String) == false){
                        self.showAlert("Error Title", messageKey: result.message as String == "" ? "Timeout Generic Exception Message" : result.message as String)
                    }
                }
            })
        }, failure: { (error) -> Void in
            DispatchQueue.main.async {
                self.hideBusyIndicator()
                self.showAlert("Login Exception Title", messageKey: error.userInfo["message"] as! String)
            }
        })
    }
    
    func prepareReceipt(sav: SavingCalculatorResult){
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "ReceiptCalculatorViewController") as! ReceiptCalculatorViewController
        vc.titleScreen = "Calculadora de Ahorros"
        vc.typeCalc = sav.savingTypeName
        vc.amountTotal = Helper.formatAmount(sav.totalSaving, currencySign: sav.currencySign)
        vc.desc = "Monto Final Aproximado"
        vc.thirdDetail = "Monto Cuota Mensual: " + Helper.formatAmount(sav.quota, currencySign: sav.currencySign)
        if self.calculator?.code == "M" {
            vc.amountTotal = Helper.formatAmount(sav.quota, currencySign: sav.currencySign)
            vc.desc = "Cuota Mensual Aproximada"
            vc.thirdDetail = "Monto Meta: " + Helper.formatAmount(sav.totalSaving, currencySign: sav.currencySign)
        }
        vc.firstDetail = "Inicio: " + sav.initPeriod + " / Fin: " + sav.endPeriod
        vc.secondDetail = sav.rateShow + " / Moneda: " + sav.currencyName
        vc.bottomDetail = (self.saving?.observations)!
        vc.infoCalc = sav.noteTitle + " " + sav.note
        self.hideBusyIndicator()
        self.present(vc, animated: true)
    }
    
    @IBAction func calcular(_ sender: UIButton) {
        self.getSavingCalculator()
    }
    
    func validDates() -> Bool {
        if self.initialYear > self.finalYear {
            return false
        }
        else{
            if self.initialYear == self.finalYear {
                if self.initialMonth > self.finalMonth {
                    return false
                }
            }
        }
        return true
    }
    
    func validForm(){
        self.disableButton(btn: self.btnCalcular)
        if self.initialYear > 0 {
            if self.finalYear > 0 {
                if self.validDates() {
                    if self.amount >= (self.saving?.minAmount)! {
                        if self.amount <= (self.saving?.maxAmount)! {
                            self.enableButton(btn: self.btnCalcular)
                        }
                    }
                }
            }
        }
    }
    
}
