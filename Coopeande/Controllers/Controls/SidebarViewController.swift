//
//  SidebarViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 8/8/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class SidebarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var imgClose: UIImageView!
    
    internal var menuOrder : Array<Int>=[]
    
    /*
    override func removeFromParentViewController() {
        super.removeFromParentViewController()
    }*/
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(SidebarViewController.menuClose(sender:)))
        self.imgClose.isUserInteractionEnabled = true
        self.imgClose.addGestureRecognizer(singleTap)
        if(menuOrder.count == 0){
            menuOrder = Constants.loginMenuOrder
        }
        self.lblUsername.text = ProxyManagerData.tokenData?.data?.name.description
        self.tableView.backgroundView = nil
        self.tableView.backgroundColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func menuClose(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func exit(_ sender: UIButton) {
        if let vc = ProxyManagerData.actualController {
            self.dismiss(animated: true, completion: {vc.logoutAlert()})
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier = "menu"+menuOrder[(indexPath as NSIndexPath).row].description
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as UITableViewCell
        if indexPath.row < (self.menuOrder.count - 1) {
            let border = CALayer()
            border.borderColor = UIColor.white.cgColor
            border.frame = CGRect(x: 20, y: (cell.frame.size.height) - 1, width: (cell.frame.size.width) - 40, height: 0.4)
            border.borderWidth = 1
            cell.layer.addSublayer(border)
            cell.layer.masksToBounds = true
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 55
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any!){
        if let cell :UITableViewCell = sender as? UITableViewCell{
            let destViewController:UIViewController = segue.destination as UIViewController
            if let value = cell.textLabel?.text{
                destViewController.title = value
            }
            switch cell.tag {
            case 9991:
                //self.showBusyIndicator("Logging Out")
                ProxyManager.Logout( {
                    (result) in
                    if(!self.removedFromParent)
                    {
                        //self.hideBusyIndicator()
                        DispatchQueue.main.async {
                            
                            if( (result.isSuccess) || (Constants.loggoutCode.range(of: (result.code as String) + "|") != nil))
                            {
                                ProxyManagerData.baseRequestData = nil
                                ProxyManagerData.tokenData = nil
                                self.performSegue(withIdentifier: "swLogout", sender: self)
                            }
                            else
                            {
                                
                                self.showAlert("Error Title", messageKey: result.message == "" ? "Timeout Generic Exception Message" : result.message as String)
                            }
                        }
                    }}, failure: { (error) -> Void in                        if(!self.removedFromParent)
                    {
                        //self.hideBusyIndicator()
                        DispatchQueue.main.async {
                            
                            self.showAlert("Error Title", messageKey: "Timeout Generic Exception Message")
                        }
                        }
                })
                break;
            default:
                configureSegue(segue)
                break;
            }
        }
        else
        {
            configureSegue(segue)
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let id = identifier
        {
            if( id == "swLogout")
            {
                return true
            }
        }
        if let sideBar : SWRevealViewController = self.revealViewController()
        {
            if let v = sideBar.rightViewController
            {
                if( v.view.viewWithTag(999) != nil)
                {
                    return false
                }
            }
        }
        return true;
    }
    
    func configureSegue(_ segue: UIStoryboardSegue)
    {
        if ( segue  is SWRevealViewControllerSeguePushController) {
            let swSegue: SWRevealViewControllerSeguePushController = segue as! SWRevealViewControllerSeguePushController
            
            
            /*swSegue.performBlock =
                {
                    (rvc_segue, svc,dvc) in
                    
                    let navController:UINavigationController = self.revealViewController().frontViewController as! UINavigationController
                    navController.setViewControllers([dvc!], animated: false)
                    self.revealViewController().setFrontViewPosition(FrontViewPositionLeft, animated: false)
            };*/
            
        }
        
    }*/
    


}
