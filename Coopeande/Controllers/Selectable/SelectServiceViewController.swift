//
//  SelectServiceViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 8/30/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class SelectServiceViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var services: PaymentServices? = nil
    var serviceSelected: PaymentService? = nil
    var detailServiceViewController: DetailServiceViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Mis Servicios"
        self.tableView.tableFooterView = UIView()
        self.backAction()
    }
    
    func backAction(){
        self.navigationItem.hidesBackButton = true
        let backItem = UIBarButtonItem(image: UIImage(named: "backButton"), landscapeImagePhone: UIImage(named: "backButton"), style: .plain, target: self, action: #selector(returnBack(sender:)))
        self.navigationItem.leftBarButtonItem = backItem
    }
    
    @objc func returnBack(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func checkBoxAction(_ sender: UIButton) {
        self.checkBox(index: sender.tag)
    }

    func checkBox(index: Int){
        let action: Bool = (self.services?.list[index].selected)!
        (self.services?.list.map({ (service) -> Bool in
            service.selected = false
            return true
        }))
        self.services?.list[index].selected = !action
        self.serviceSelected = nil
        if !action {
            self.serviceSelected = self.services?.list[index]
        }
        self.tableView.reloadData()
        if self.self.serviceSelected != nil{
            self.detailServiceViewController?.assignProductSelect(product: self.serviceSelected!, type: "servicio")
            self.navigationController?.popViewController(animated: true)
        }
        else{
            self.detailServiceViewController?.cleanProductSelect(type: "servicio")
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.checkBox(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.services?.count as! Int
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async() {
            if self.tableView != nil {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = 100
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3)
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath) as! ServiceCell
        let service: PaymentService = (self.services?.list[indexPath.row])!
        cell.btnCheckBox.tag = indexPath.row
        cell.show(service)
        return cell
    }

}
