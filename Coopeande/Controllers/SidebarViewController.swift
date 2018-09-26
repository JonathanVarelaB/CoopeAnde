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
    @IBOutlet weak var lblUserLastname: UILabel!
    var ProxyManager :UtilProxyManager = UtilProxyManager()
    internal var menuOrder : Array<Int>=[]
    var removedFromParent :Bool = false
    
    override func removeFromParentViewController() {
        removedFromParent = true
        super.removeFromParentViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let img = UIImage()
        self.navigationController?.navigationBar.shadowImage = img
        self.navigationController?.navigationBar.setBackgroundImage(img, for: UIBarMetrics.default)
        
        self.navigationItem.hidesBackButton = true
        let menuItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.plain, target: self, action: #selector(menuClose(sender:)))
        self.navigationItem.leftBarButtonItem = menuItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(menuOrder.count == 0)
        {
            menuOrder = Constants.loginMenuOrder
        }
        if(lblUserLastname != nil) {
            lblUsername.text = ProxyManagerData.tokenData?.data?.name as String?
            lblUserLastname.text = ""
        }
        self.tableView.backgroundView = nil
        self.tableView.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func menuClose(sender: UIBarButtonItem) {
        print("Entro aqui")
        dismiss(animated: true, completion: nil)
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CellIdentifier = "menu"+menuOrder[(indexPath as NSIndexPath).row].description
        
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as UITableViewCell
        return cell;
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // Instantiate or retrieve the controller to push
       /* let controller = self.storyboard?.instantiateViewController(withIdentifier: "YourControllerIdentifier") as? UIViewController
        
        // Push it
        revealViewController().pushFrontViewController(controller, animated:true)*/
        
    }
    override  func prepare(for segue: UIStoryboardSegue, sender: Any!)
    {
        if let cell :UITableViewCell = sender as? UITableViewCell
        {
            
            // Set the title of navigation bar by using the menu items
            
            let destViewController:UIViewController = segue.destination as UIViewController
            
            
            if let value = cell.textLabel?.text
            {
                destViewController.title = value
            }
            switch  cell.tag
            {
                
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
        
    }
    


}
