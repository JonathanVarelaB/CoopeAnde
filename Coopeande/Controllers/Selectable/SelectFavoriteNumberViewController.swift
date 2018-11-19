//
//  SelectFavoriteNumberViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/21/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit
import ContactsUI

class SelectFavoriteNumberViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, CNContactPickerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewController: BaseViewController?
    var sectionType: String = ""
    var favorites: Array<Contact> = []
    var favoriteSelected: Contact! = nil
    var indexToDelete: Int = -1
    var newFavoriteNumber: String = ""
    var newFavoriteName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favoritos"
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = 100
        self.tableView.estimatedRowHeight = 100
        self.backAction()
        self.buttonAddFavorite()
        self.loadFavorites()
    }
    
    func loadFavorites(){
        self.showBusyIndicator("Loading Data")
        ProxyManager.GetFavoriteContacts(success: {
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess {
                    self.favorites = (result.data?.list)!
                    if self.favoriteSelected != nil {
                        for item in self.favorites {
                            if item.phoneNumber == self.favoriteSelected.phoneNumber{
                                item.selected = true
                            }
                        }
                    }
                    self.tableView.reloadData()
                    self.hideBusyIndicator()
                }
                else {
                    self.favorites = []
                    self.tableView.reloadData()
                    self.hideBusyIndicator()
                    if(!self.sessionTimeOutException(result.code.description, message: result.message.description)){
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
    
    func backAction(){
        self.navigationItem.hidesBackButton = true
        let backItem = UIBarButtonItem(image: UIImage(named: "backButton"), landscapeImagePhone: UIImage(named: "backButton"), style: .plain, target: self, action: #selector(returnBack(sender:)))
        self.navigationItem.leftBarButtonItem = backItem
    }
    
    func buttonAddFavorite(){
        let addItem = UIBarButtonItem(image: UIImage(named: "plusWhite"), landscapeImagePhone: UIImage(named: "plusWhite"), style: .plain, target: self, action: #selector(addAction(sender:)))
        self.navigationItem.rightBarButtonItem = addItem
    }
    
    @objc func returnBack(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func addAction(sender: UIBarButtonItem){
        let controller = CNContactPickerViewController()
        controller.delegate = self
        controller.predicateForEnablingContact = NSPredicate(format: "phoneNumbers.@count > 0", argumentArray: nil)
        controller.predicateForSelectionOfProperty = NSPredicate(format: "key == 'phoneNumbers'", argumentArray: nil)
        navigationController?.present(controller, animated: true, completion: nil)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty){
        self.newFavoriteName = contactProperty.contact.givenName + " " + contactProperty.contact.familyName
        if let phone: CNPhoneNumber = contactProperty.value as? CNPhoneNumber {
            self.newFavoriteNumber = Helper.formatPhone(text: phone.stringValue)
            self.showAlert("Agregar Contacto", messageKey: "¿Desea agregar este contacto como favorito?", acceptType: false, controller: self, sectionType: "agregarFavorito")
        }
    }
    
    func addFavorite(){
        self.assignProductSelect()
    }
    
    func dontAddFavorite(){
        self.newFavoriteNumber = ""
        self.newFavoriteName = ""
    }
    
    //override func assignProductSelect(product: SelectableProduct, type: String){
    func assignProductSelect(){
        self.showBusyIndicator("Loading Data")
        //let newFavorite = product as! Contact
        let request: FavoriteRequest = FavoriteRequest()
        request.name = NSString(string: self.newFavoriteName)
        request.phoneNumber = NSString(string: self.newFavoriteNumber.replacingOccurrences(of: "-", with: ""))
        //request.name = newFavorite.name as NSString
        //request.phoneNumber = newFavorite.phoneNumber as NSString
        ProxyManager.AddFavoriteContact(data: request, success: {
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess {
                    self.loadFavorites()
                }
                else {
                    self.hideBusyIndicator()
                    if(!self.sessionTimeOutException(result.code.description, message: result.message.description)){
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
    
    @IBAction func deleteAction(_ sender: UIButton) {
        self.indexToDelete = sender.tag
        self.showAlert("Eliminar Favorito", messageKey: "¿Desea eliminar este contacto como favorito?", acceptType: false, controller: self, sectionType: "eliminarFavorito")
    }
    
    @IBAction func checkBoxAction(_ sender: UIButton) {
        self.checkBox(index: sender.tag)
    }
    
    func checkBox(index: Int){
        let action: Bool = (self.favorites[index].selected)
        (self.favorites.map({ (favorite) -> Bool in
            favorite.selected = false
            return true
        }))
        self.favorites[index].selected = !action
        self.favoriteSelected = nil
        if !action {
            self.favoriteSelected = self.favorites[index]
        }
        self.tableView.reloadData()
        if self.favoriteSelected != nil{
            switch self.sectionType {
            case "sinpeAfiliacion":
                (self.viewController as! AffiliationViewController).assignProductSelect(product: self.favorites[index], type: "contacto")
                self.navigationController?.popViewController(animated: true)
                break
            case "sinpeTransaccion":
                (self.viewController as! SinpeTransactionsViewController).assignProductSelect(product: self.favorites[index], type: "contacto")
                self.navigationController?.popViewController(animated: true)
                break
            default:
                print("default")
            }
        }
        else{
            switch self.sectionType {
            case "sinpeAfiliacion":
                (self.viewController as! AffiliationViewController).cleanProductSelect(type: "contacto")
                break
            case "sinpeTransaccion":
                (self.viewController as! SinpeTransactionsViewController).cleanProductSelect(type: "contacto")
                break
            default:
                print("default")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.checkBox(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favorites.count
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
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3)
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        cell.btnCheckBox.tag = indexPath.row
        cell.btnDelete.tag = indexPath.row
        cell.set(contact: self.favorites[indexPath.row])
        /*
        let border = CALayer()
        border.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.2).cgColor
        border.frame = CGRect(x: 15, y: (cell.frame.size.height) - 1, width: UIScreen.main.bounds.width - 30, height: 1)
        border.borderWidth = 1
        cell.layer.addSublayer(border)
        cell.layer.masksToBounds = true*/
        return cell
    }

    override func alertActionSi() {
        self.showBusyIndicator("Loading Data")
        let deleteFavorite = self.favorites[self.indexToDelete]
        let request: FavoriteRequest = FavoriteRequest()
        request.phoneNumber = deleteFavorite.phoneNumber as NSString
        request.name = deleteFavorite.name as NSString
        ProxyManager.DeleteFavoriteContact(data: request, success: {
            (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess {
                    self.loadFavorites()
                }
                else {
                    self.hideBusyIndicator()
                    if(!self.sessionTimeOutException(result.code.description, message: result.message.description)){
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
    
    override func alertActionNo() {
        self.indexToDelete = -1
    }
    
}
