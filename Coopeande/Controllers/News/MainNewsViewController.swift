//
//  MainNewsViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 11/6/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit
import MCMHeaderAnimated
import SideMenu

class MainNewsViewController: UITableViewController {
    
    private let transitionManager = MCMHeaderAnimated()
    private var elements: NSArray! = []
    private var lastSelected: NSIndexPath! = nil
    
    var ProxyManager: UtilProxyManager = UtilProxyManager()
    var dataResponse: Array<Ads> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Anuncios"
        /*self.elements = [
            ["color": UIColor(red: 25/255.0, green: 181/255.0, blue: 254/255.0, alpha: 1.0)],
            ["color": UIColor(red: 54/255.0, green: 215/255.0, blue: 183/255.0, alpha: 1.0)],
            ["color": UIColor(red: 210/255.0, green: 77/255.0, blue: 87/255.0, alpha: 1.0)],
            ["color": UIColor(red: 236/255.0, green: 236/255.0, blue: 236/255.0, alpha: 1.0)]
        ]*/
        
        if(ProxyManagerData.tokenData == nil){
            self.backAction()
            self.loadNews()
        }
        else{
            self.setMenu()
        }
        self.loadNews()
    }
    
    func setMenu(){
        self.navigationItem.hidesBackButton = true
        let menuItem = UIBarButtonItem(image: UIImage(named: "menuCustom"), landscapeImagePhone: UIImage(named: "menuCustom"), style: .plain, target: self, action: #selector(menuSide(sender:)))
        self.navigationItem.leftBarButtonItem = menuItem
        let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        menuLeftNavigationController.menuWidth = view.frame.width * 0.80
        SideMenuManager.default.menuAddPanGestureToPresent(toView: menuLeftNavigationController.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: menuLeftNavigationController.view)
    }
    
    @objc func menuSide(sender: UIBarButtonItem) {
        let menu = SideMenuManager.default.menuLeftNavigationController!
        self.parent?.present(menu, animated: true, completion: nil)
    }
    
    func backAction(){
        self.navigationItem.hidesBackButton = true
        let backItem = UIBarButtonItem(image: UIImage(named: "backButton"), landscapeImagePhone: UIImage(named: "backButton"), style: .plain, target: self, action: #selector(returnBack(sender:)))
        self.navigationItem.leftBarButtonItem = backItem
    }
    
    @objc func returnBack(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataResponse.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataResponse[(indexPath as NSIndexPath).row]
        //print("item: ",item)
        let cell: MainNewsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "mainCell" , for: indexPath) as! MainNewsTableViewCell
        cell.show(item.title as String,shortDescription: item.description as String, date:item.date as String, img: item.imageUrl)
        //print("Título: ",item.title)
        cell.background.clipsToBounds = true
        //set contentView frame and autoresizingMask
        cell.btnShow.tag = (indexPath as NSIndexPath).row
        cell.controller = self
        
       // cell.contentView.frame = cell.bounds;
       // cell.contentView.autoresizingMask = //UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin| UIViewAutoresizing.flexibleWidth
        return cell;
        
        
        /*let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath as IndexPath) as! MainNewsTableViewCell
        
        cell.background.layer.cornerRadius = 10;
        cell.background.clipsToBounds = true
        cell.header.backgroundColor = (self.elements[indexPath.row] as! [String: AnyObject])["color"] as? UIColor
        
        return cell*/
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detail = segue.destination as? NewsViewController{
            detail.data = self.dataResponse[(sender! as AnyObject).tag]
        }
        /*if segue.identifier == "viewDetail" {
            self.lastSelected = self.tableView.indexPathForSelectedRow! as NSIndexPath
            let element = self.elements.object(at: self.tableView.indexPathForSelectedRow!.row)
            
            let destination = segue.destination as! NewsViewController
            destination.element = element as! NSDictionary
            destination.transitioningDelegate = self.transitionManager
            
            self.transitionManager.destinationViewController = destination
        }*/
    }
    
    func loadNews(){
        self.showBusyIndicator("Loading Data")
        ProxyManager.GetNews({
            (result) in
            DispatchQueue.main.async {
                if result.isSuccess{
                    self.dataResponse = result.data!.list
                    self.tableView!.reloadData()
                    self.hideBusyIndicator()
                }
                else{
                    self.hideBusyIndicator()
                    self.showAlert("Error Title", messageKey: result.message as String == "" ? "Timeout Generic Exception Message" : result.message as String)
                }
            }
        }, failure: { (error) -> Void in
            self.hideBusyIndicator()
            self.showAlert("Error Title", messageKey: "Timeout Generic Exception Message")
        })
    }

}
