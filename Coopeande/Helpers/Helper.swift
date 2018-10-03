//
//  Helper.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 24/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import MONActivityIndicatorView


class Helper {
    
    static let months: [String] = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
    
    //Validar Conexión a internet
    class  func hasConnection() -> Bool
    {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
    }
    
    ///Obtener texto segun localizacion
    class func getLocalizedText(_ key:String) -> String
    {
        let keyValue : String = Helper.parseText(key)
        var value: String = NSLocalizedString(keyValue, comment:"")
        value = value.isEmpty ? keyValue : value
        return value
        
    }
    ///Procesa los saltos de linea del proxi para ser interpretados
    class func parseText(_ data: String?) -> String{
        
        if(data == nil) {
            return ""
        }
        return data!.replacingOccurrences(of: "\\n", with: "\n", options:NSString.CompareOptions.literal, range: nil)
    }
    
    class func isNumber (_ data : String?) -> Bool
    {
        return Int(data!) != nil
    }
    
    ///Obtener un ViewController del storyboard, esta funcion ya realiza la verificacion de cual
    ///dispositivo esta ejecutando la aplicacion
    ///TODO nombres de Storyboard
    class func getViewController(_ storyBoardId: String) -> UIViewController {
        var  storyboard : UIStoryboard
        print(Bundle.main.infoDictionary?["UIMainStoryboardFile"] as Any)
        if Constants.iPhone
        {
            storyboard = UIStoryboard(name: "Main", bundle: Bundle.main);
        }
        else
        {
            //storyboard = UIStoryboard(name: "iPad_Storyboard", bundle: Bundle.main);
            storyboard = UIStoryboard(name: "Main", bundle: Bundle.main);
        }
        let  sub :UIViewController = storyboard.instantiateViewController(withIdentifier: storyBoardId) as UIViewController
        return sub
        
    }
    
    ///Retorna un Formatter con las caracteristicas requeridad para
    ///la mascara de numeros
    class func getNumberFormatter() -> NumberFormatter
    {
        if(Constants.formatter == nil)
        {
            let formatter : NumberFormatter  = NumberFormatter()
            formatter.formatterBehavior = NumberFormatter.Behavior.behavior10_4
            formatter.numberStyle = NumberFormatter.Style.decimal
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            
            formatter.roundingMode = NumberFormatter.RoundingMode.halfUp
            formatter.secondaryGroupingSize = 3
            formatter.roundingIncrement = NSNumber(value: 0.0001 as Double)
            Constants.formatter = formatter
        }
        return Constants.formatter!
    }
    ///Retorna un Formatter con las caracteristicas requeridad para
    ///la mascara de numeros
    class func getNumberFormatterInt() -> NumberFormatter
    {
        //  if(Constants.formatter == nil)
        //{
        let formatter : NumberFormatter  = NumberFormatter()
        formatter.formatterBehavior = NumberFormatter.Behavior.default
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        
        formatter.roundingMode = NumberFormatter.RoundingMode.halfUp
        formatter.secondaryGroupingSize = 3
        formatter.roundingIncrement = NSNumber(value: 0.0000 as Double)
        //  Constants.formatter = formatter
        //}
        return formatter
    }
    
    class func getNumberFormatterIntCustomGroupSize(_ groupSize : NSInteger) -> NumberFormatter
    {
        //  if(Constants.formatter == nil)
        //{
        let formatter : NumberFormatter  = NumberFormatter()
        formatter.formatterBehavior = NumberFormatter.Behavior.default
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        
        formatter.roundingMode = NumberFormatter.RoundingMode.halfUp
        formatter.secondaryGroupingSize = groupSize
        formatter.groupingSize = groupSize
        formatter.roundingIncrement = NSNumber(value: 0.0000 as Double)
        //  Constants.formatter = formatter
        //}
        return formatter
    }
    
    class func formatPhone(text: String) -> String {
        let text = text.replacingOccurrences(of: "-", with: "")
        if text.count > 4 && text.count < 9 {
            let r = text.index(text.startIndex, offsetBy: 4)..<text.index(text.endIndex, offsetBy: 0)
            return text.prefix(4) + "-" + text[r]
        }
        return text
    }
    
    class func formatAnyNumberOrAmount(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String, maxAmountDigits : NSInteger, formatIndicator : NSInteger) -> Bool
    {
        let MAX_DIGITS = maxAmountDigits;
        var numberFormatter = Helper.getNumberFormatterInt()
        
        if formatIndicator == 0
        {
            numberFormatter = Helper.getNumberFormatterInt()
        }
        
        if formatIndicator == 1
        {
            numberFormatter = Helper.getNumberFormatterIntCustomGroupSize(maxAmountDigits)
        }
        
        var stringMaybeChanged = string
        
        if (stringMaybeChanged.count > 1)
        {
            let stringPasted = NSMutableString(string: stringMaybeChanged)
            stringPasted.replaceOccurrences(of: numberFormatter.groupingSeparator,with:"",options:NSString.CompareOptions.literal,
                                            range:NSMakeRange(0,stringPasted.length))
            let number = NSDecimalNumber(string: stringPasted as String)
            stringMaybeChanged = numberFormatter.string(from: number)!
        }
        
        let selectedRange = textField.selectedTextRange
        let start = textField.beginningOfDocument
        let cursorOffset = textField.offset(from: start, to: selectedRange!.start)
        let textFieldTextStr = NSMutableString(string: textField.text!)
        let textFieldTextStrLength = textFieldTextStr.length
        
        textFieldTextStr.replaceCharacters(in: range,with: stringMaybeChanged)
        textFieldTextStr.replaceOccurrences(of: numberFormatter.groupingSeparator, with: "", options: NSString.CompareOptions.literal, range: NSMakeRange(0,textFieldTextStr.length))
        //textFieldTextStr.replaceOccurrencesOfString(numberFormatter.groupingSeparator,withString:"",options:NSString.CompareOptions.LiteralSearch, range:NSMakeRange(0,textFieldTextStr.length))
        textFieldTextStr.replaceOccurrences(of: numberFormatter.decimalSeparator!, with: "", options: NSString.CompareOptions.literal, range: NSMakeRange(0,textFieldTextStr.length))
        //textFieldTextStr.replaceOccurrencesOfString(numberFormatter.decimalSeparator!,withString:"",options:NSString.CompareOptions.LiteralSearch, range:NSMakeRange(0,textFieldTextStr.length))
        
        
        if (textFieldTextStr.length <= MAX_DIGITS)
        {
            if(textFieldTextStr.length>0)
            {
                let textFieldTextNumNullabel = NSDecimalNumber(string:textFieldTextStr as String);
                if textFieldTextNumNullabel.floatValue >= 0
                {
                    let textFieldTextNum = textFieldTextNumNullabel
                    var divideByNum = NSDecimalNumber(value: 10 as Float).raising(toPower: numberFormatter.maximumFractionDigits)
                    let textFieldTextNewNum = textFieldTextNum
                    let textFieldTextNewStr = numberFormatter.string(from: textFieldTextNewNum)
                    if(textFieldTextNewNum != NSDecimalNumber.notANumber)
                    {
                        textField.text = textFieldTextNewStr
                        
                        if (cursorOffset != textFieldTextStrLength)
                        {
                            let lengthDelta = textFieldTextNewStr!.count - textFieldTextStrLength;
                            let newCursorOffset = max(0, min(textFieldTextNewStr!.count, cursorOffset + lengthDelta));
                            let newPosition = textField.position(from: textField.beginningOfDocument, offset: newCursorOffset);
                            let newRange = textField.textRange(from: newPosition!, to: newPosition!);
                            textField.selectedTextRange = newRange
                        }
                    }
                    else
                    {
                        textField.text = ""
                    }
                }
            }
            else
            {
                textField.text = ""
            }
        }
        
        return false;
        
    }
    
    
    ///retorna un string con el monto con separadores de miles y la moneda
    class func formatAmount(_ amount: NSNumber?, currencySign : String) -> String
    {
        let currency : String = currencySign == "COL" ?  "¢" : "$"

        if let amountData = amount
        {
            //return  String(format:"%@ %@",Helper.getNumberFormatter().string(from: amount!)!,Helper.getLocalizedText(currencySign))
            return  String(format:"%@ %@",Helper.getLocalizedText(currency),Helper.getNumberFormatter().string(from: amount!)!)
        }
        return ""
    }
    
    class func removeFormatAmount(_ amount: String?) -> String {
        return (amount?.replacingOccurrences(of: ",", with: ""))!
    }
    
    class func formatAmount(_ amount: NSNumber?) -> String
    {
        return Helper.getNumberFormatter().string(from: amount!)!
    }
    class func formatAmountInt(_ amount: NSNumber?) -> String
    {
        return Helper.getNumberFormatterInt().string(from: amount!)!
    }
   /* class func isNumber (_ data : String?) -> Bool
    {
        return Int(data!) != nil
    }
    
    class func now()-> String
    {
        let todaysDate:Date = Date()
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss.SSS"
        let DateInFormat:String = dateFormatter.string(from: todaysDate)
        return DateInFormat
    } */

}

protocol PasswordKeyDelegate
{
    func PasswordKey(_ key:String)
}


public extension UIViewController
{
    func getKeyboardToolbar() -> UIToolbar
    {
        return getKeyboardToolbarForTextField(nil);
    }
    
    func getKeyboardToolbarForTextField(_ textField:UITextField?) -> UIToolbar
    {
        let  keyboardDoneButtonView = UIToolbar()
        keyboardDoneButtonView.sizeToFit()
        //var btns :Array<AnyObject> = []
        var btns :Array<UIBarButtonItem> = []
        let doneButton = UIBarButtonItem(
            title:Helper.getLocalizedText("Done"),
            style:UIBarButtonItemStyle.plain, target:self,
            action:Selector(("doneClicked:")))
        
        
        let next = UIBarButtonItem(
            title:Helper.getLocalizedText(">"),
            style:UIBarButtonItemStyle.plain, target:self,
            action:Selector(("nextClicked:")))
        
        let prev = UIBarButtonItem(
            title:Helper.getLocalizedText("<"),
            style:UIBarButtonItemStyle.plain, target:self,
            action:Selector(("prevClicked:")))
        
        doneButton.setTitleTextAttributes(Style.navButtonTextAttributes as? [NSAttributedStringKey: Any], for: [])
        btns += [doneButton]
        if let t = textField
        {
            /*if(t.prev != nil)
                
            {
                btns += [prev]
            }*/
            
            if(t.next != nil)
                
            {
                btns += [next]
            }
        }
        
        keyboardDoneButtonView.setItems(btns, animated: true);
        return keyboardDoneButtonView
        
    }
    
    func showAlert(_ titleKey: String?, messageKey: String)
    {
        if(self.isViewLoaded)
        {
            let m : String = messageKey == nil ?  "Generic Error Message" : messageKey
            let t : String = titleKey == nil ? "Error Title" : titleKey!
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.definesPresentationContext = true
            vc.titleAlert = Helper.getLocalizedText(t)
            vc.descAlert = Helper.getLocalizedText(m)
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    class func formatAmount(_ amount: NSNumber?, currencySign : String) -> String
    {
        if let amountData = amount
        {
            return  String(format:"%@ %@",Helper.getNumberFormatter().string(from: amount!)!,Helper.getLocalizedText(currencySign))
        }
        return ""
    }
    class func formatAmount(_ amount: NSNumber?) -> String
    {
        return Helper.getNumberFormatter().string(from: amount!)!
    }
    class func formatAmountInt(_ amount: NSNumber?) -> String
    {
        return Helper.getNumberFormatterInt().string(from: amount!)!
    }
    class func isNumber (_ data : String?) -> Bool
    {
        return Int(data!) != nil
    }
    
    class func now()-> String
    {
        let todaysDate:Date = Date()
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss.SSS"
        let DateInFormat:String = dateFormatter.string(from: todaysDate)
        return DateInFormat
    }
    
    
    
    
    ///Mostrar el indicador de ocupado
    func showBusyIndicator(_ title : String)
    {
        OperationQueue.main.addOperation( {
            let instance : CustomBusyIndicator = CustomBusyIndicator()
            var uiViewHost : UIView?
            //            if self.view.superview !=  nil {
            //                if self.navigationController?.view != nil
            //                {
            //                    uiViewHost = self.navigationController!.view
            //
            //                }
            //                else
            //                {
            //                    //uiViewHost = self.view.superview!
            //                 uiViewHost = self.view
            //                }
            //
            //            }
            //            else
            //            {
            uiViewHost = self.view
            
            //            }
            
            instance.frame = uiViewHost!.frame
            instance.backgroundColor = Style.modalBackgroundColor
            let indicatorView : MONActivityIndicatorView  = MONActivityIndicatorView();
            indicatorView.delegate = instance;
            indicatorView.center = instance.center;
            //indicatorView.title = Helper.getLocalizedText(title);
            instance.tag = 999
            instance.frame.origin  = CGPoint(x: 0,y: 0)
            instance.isHidden = true

            indicatorView.startAnimating();
            instance.addSubview(indicatorView)
            
            //self.configureNavBar(false)
            instance.isUserInteractionEnabled = false
            instance.isHidden=true
            uiViewHost!.isUserInteractionEnabled = false
            uiViewHost!.addSubview(instance);
            uiViewHost!.bringSubview(toFront: instance)
            var timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UIViewController.showBusyIndicatorWindow(_:)), userInfo: instance, repeats: false)
        })
    }
    @objc func showBusyIndicatorWindow(_ timer: Timer) {
        if let viewAnimated = timer.userInfo as? CustomBusyIndicator
        {
            viewAnimated.isHidden=false
        }
    }
    
    ///Ocultar el indicador de ocupado
    func hideBusyIndicator()
    {
        OperationQueue.main.addOperation( {
            
            
            var uiViewHost : UIView?
            //            if self.view.superview !=  nil {
            //                if self.navigationController?.view != nil
            //                {
            //                    uiViewHost = self.navigationController!.view
            //
            //                }
            //                else
            //                {
            //                    //uiViewHost = self.view.superview!
            //                     uiViewHost = self.view
            //                }
            //            }
            //            else
            //            {
            uiViewHost = self.view
            //            }
            uiViewHost!.isUserInteractionEnabled = true
            while(true)
            {
                if let  instance = uiViewHost!.viewWithTag(999) as? CustomBusyIndicator{
                    if (instance.superview != nil)
                    {
                        uiViewHost!.willRemoveSubview(instance)
                        instance.removeFromSuperview()
                    }
                }
                else
                {
                    break
                }
            }
            //self.configureNavBar(true)
        })
    }
    
    
    func modalAlertCompleted()
    {
    }
    func modalAlertOk(_ action:UIAlertAction)
    {
    }
}

enum AccountType
{
    case from
    case to
    case afilliate
}
/*
protocol SelectedPageDelegate: class
{
    func selectedPage(pageControl:PagesViewController, selectItem:EntityBase)
}*/
protocol SelectedAccountBackDelegate {
    func SelectedAccountBack(selectedValue: Account, type : AccountType)
}
protocol SelectedTrasferTypeBackDelegate {
    //func SelectedTransferTypeBack(typeId: NSString,selectedValue: String, commission: NSNumber)
    func SelectedTransferTypeBack(selectedTransferType : TransferType)
}
protocol ConfirmActionViewDelegate{
    func confirmActionViewCancel(alertController:UIViewController?)
    func confirmActionViewOk(alertController:UIViewController?)
}
protocol InputDataChangeDelegate
{
    func inputDataChange()
    
}
protocol SessionTimeOutDelegate
{
    func onSessionTimeOutException(code:String) -> Bool
}


public extension UIImageView
{
    func imageWithColor(color: UIColor, animate: Bool)
    {
        if(animate)
        {
            animateChangedValue(color: color)
        }
        else
        {
            let  newImage = UIImage (named: "bullet")
            //self.image = newImage!.imageWithColor(color)
            self.image = newImage
        }
    }
    func imageWithColor(color: UIColor)
    {
        imageWithColor(color: color,animate: true)
    }
    func animateChangedValue(color: UIColor)
    {
        let animation = CABasicAnimation(keyPath: "transform.rotation.y")
        animation.fromValue = NSNumber(value: 0)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.fillMode = kCAFillModeForwards;
        
        animation.toValue = NSNumber(value: 3.1415 )
        animation.duration = 0.5
        animation.repeatCount = 1.0
        
        // Add perspective
        var mt : CATransform3D = CATransform3DIdentity;
        mt.m34 = 1.0 / 1000 * -1;
        self.layer.transform = mt;
        
        self.layer.add(animation, forKey: nil)
        UIView.animate(withDuration: 0.5, animations:{ () -> Void in
            self.imageWithColor(color: color, animate: false)
        });
        
    }
}
/*public extension UIImage
{
    func imageWithColor(color: UIColor) -> UIImage
    {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
        var context : CGContext = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, 0, self.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, kCGBlendModeNormal);
        var rect : CGRect = CGRectMake(0, 0, self.size.width, self.size.height);
        CGContextClipToMask(context, rect, self.CGImage);
        color.setFill();
        CGContextFillRect(context, rect);
        var newImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return newImage;
    }
}*/
public extension String
{
    func isNumber () -> Bool
    {
        return Helper.getNumberFormatter().number(from: self) != nil
    }
    func characterAtIndex(index:Int) -> unichar
    {
        let utf16view = String(self).utf16
        return utf16view[utf16view.startIndex]
        //return self.utf16[index]
    }
    
    // Allows us to use String[index] notation
    subscript(index:Int) -> unichar
    {
        return characterAtIndex(index: index)
    }
}
