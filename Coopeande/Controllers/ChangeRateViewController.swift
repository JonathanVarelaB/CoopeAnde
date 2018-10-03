//
//  TipoCambioViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 29/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit
import Lottie

class ChangeRateViewController: BaseViewController {
    
    var dataResponse : Currencies?
    let animationView = LOTAnimationView(name: "exchange_rate_start")
    @IBOutlet weak var animationContentView: UIView!
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelSalesValue: UILabel!
    @IBOutlet weak var labelpurchaseValue: UILabel!
    @IBOutlet weak var contectView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contectView.isHidden = true
        animationView.contentMode = .scaleAspectFill
        animationView.frame = CGRect(x:35, y: 0, width: 300, height: 300)
        animationContentView.addSubview(animationView)
        animationView.loopAnimation = false
        animationView.play()
        
        self.loadData()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.00, green:0.37, blue:0.78, alpha:1.0)
        /*let img = UIImage()
        self.navigationController?.navigationBar.shadowImage = img
        self.navigationController?.navigationBar.setBackgroundImage(img, for: UIBarMetrics.default)
        */
        //self.navigationController?.navigationBar.isTranslucent = true
        /*self.navigationController?.navigationBar.barTintColor = UIColor(red:0.00, green:0.33, blue:0.76, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]*/
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.20, green:0.69, blue:0.67, alpha:1.0)
        //self.navigationController?.navigationBar.isTranslucent = false
       /* self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        //self.navigationController?.navigationBar.isTranslucent = false
        //self.navigationController?.navigationBar.isOpaque = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.20, green:0.69, blue:0.67, alpha:0.85)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]*/
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData(){
        self.showBusyIndicator("Cargando datos.")
        ProxyManager.CurrencyExchange({
            (result) in
            DispatchQueue.main.async {
                if result.isSuccess{
                    self.dataResponse = result.data
                    self.hideBusyIndicator()
                    print(self.dataResponse!)
                    let item : Currency = self.dataResponse?.list[0] as! Currency
                    self.labelName.text = item.name as String
                    self.labelSalesValue.text = "₡" + item.sales.stringValue
                    self.labelpurchaseValue.text = "₡" + item.purchase.stringValue
                    self.contectView.isHidden = false
                    print(item.sales)
                    //data.list[indexPath.section] as! Currency
                }
                else{
                    self.hideBusyIndicator()
                    self.showAlert("Error Title", messageKey: result.message as String == "" ? "Timeout Generic Exception Message" : result.message as String)
                }
            }
            }, failure: { (error) -> Void in                if(!self.removedFromParent)
            {
                DispatchQueue.main.async {
                    self.hideBusyIndicator()
                    self.showAlert("Login Exception Title", messageKey: error.userInfo["message"] as! String)
                }
                }
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
