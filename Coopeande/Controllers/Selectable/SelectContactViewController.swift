//
//  SelectContactViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/21/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit
import Contacts

class SelectContactViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var lblSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var dictionaryNames: [String: Array<Contact>] = [:]
    var sectionType: String = ""
    var controller: BaseViewController?
    var titleScreen: String = ""
    var contactsToShow: Array<Contact> = []
    var contactsOriginal: Array<Contact> = []
    var selected: IndexPath?
    
    struct Objects {
        var sectionName: String!
        var sectionObjects: [Contact]!
    }
    
    var objectArray: [Objects] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.titleScreen
        self.lblSearch.delegate = self
        self.backAction()
        self.hideKeyboardWhenTappedAround()
        self.setDesign()
        self.loadContacts()
    }

    func setDictionary(){
        self.dictionaryNames = ["A": [], "B": [], "C": [], "D": [], "E": [], "F": [], "G": [], "H": [], "I": [], "J": [], "K": [], "L": [], "M": [], "N": [],
                                "Ñ": [], "O": [], "P": [], "Q": [], "R": [], "S": [], "T": [], "U": [], "V": [], "W": [], "X": [], "Y": [], "Z": []]
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func backAction(){
        self.navigationItem.hidesBackButton = true
        let backItem = UIBarButtonItem(image: UIImage(named: "backButton"), landscapeImagePhone: UIImage(named: "backButton"), style: .plain, target: self, action: #selector(returnBack(sender:)))
        self.navigationItem.leftBarButtonItem = backItem
    }
    
    @objc func returnBack(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadContacts(){
        let status = CNContactStore.authorizationStatus(for: .contacts)
        if status == .denied || status == .restricted {
            presentSettingsActionSheet()
            return
        }
        let store = CNContactStore()
        
        store.requestAccess(for: .contacts) { granted, error in
            guard granted else {
                DispatchQueue.main.async {
                    self.presentSettingsActionSheet()
                }
                return
            }
            var contacts = [CNContact]()
            let request = CNContactFetchRequest(keysToFetch: [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey as CNKeyDescriptor])
            do {
                try store.enumerateContacts(with: request) { contact, stop in
                    contacts.append(contact)
                }
                for contact in contacts {
                    if contact.phoneNumbers.count > 0 {
                        self.contactsOriginal.append(Contact(
                            name: CNContactFormatter.string(from: contact, style: .fullName)!,
                            number: contact.phoneNumbers[0].value.stringValue))
                    }
                }
                self.contactsToShow = self.contactsOriginal
            } catch {
                print(error)
            }
            OperationQueue.main.addOperation({
                self.alphabeticalGroup()
            })
        }
    }
    
    func alphabeticalGroup(){
        self.setDictionary()
        var inicial = ""
        (self.contactsToShow.map({ (contact) -> Bool in
            inicial = (contact.name.uppercased().first?.description)!
            self.dictionaryNames[inicial]?.append(contact)
            return true
        }))
        let sortedBreeds = self.dictionaryNames.sorted{ $0.key < $1.key }
        self.objectArray = []
        for (key, value) in sortedBreeds {
            if value.count > 0 {
                self.objectArray.append(Objects(sectionName: key, sectionObjects: value))
            }
        }
        self.tableView.reloadData()
    }
    
    func presentSettingsActionSheet() {
        let alert = UIAlertController(title: "Acceso a Contactos", message: "CoopeAnde requiere acceder a tus contactos", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ir a Configuración", style: .default) { _ in
            let url = URL(string: UIApplicationOpenSettingsURLString)!
            UIApplication.shared.open(url)
        })
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }
    
    func setDesign(){
        self.lblSearch.layer.borderWidth = 0.7
        self.lblSearch.layer.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
        self.lblSearch.layer.cornerRadius = 4
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Lupa")
        imageView.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        self.lblSearch.leftViewMode = UITextFieldViewMode.always
        self.lblSearch.addSubview(imageView)
        self.lblSearch.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: self.lblSearch.frame.height))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func search(_ sender: UITextField) {
        self.maxLenght(textField: sender, maxLength: 30)
        let txt = self.lblSearch.text
        if txt == "" {
            self.contactsToShow = (self.contactsOriginal)
        }
        else{
            self.contactsToShow = (self.contactsOriginal.filter({(contact) -> Bool in
                let name: NSString = contact.name as NSString
                return (name.range(of: txt!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
            }))
        }
        self.alphabeticalGroup()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.objectArray.count > 0 {
            return self.objectArray[section].sectionObjects.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor(red:0.85, green:0.93, blue:0.93, alpha:1.0)
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor(red:0.00, green:0.58, blue:0.56, alpha:1.0)
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return self.objectArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactCell
        cell.lblName.text = self.objectArray[indexPath.section].sectionObjects[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.objectArray.count > 0 {
            return objectArray[section].sectionName
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.sectionType {
        case "agregarFavorito":
            self.selected = indexPath
            self.showAlert("Agregar Contacto", messageKey: "¿Desea agregar este contacto como favorito?", acceptType: false, controller: self, sectionType: "agregarFavorito")
            break
        case "seleccionarContactoAfil":
            self.selected = indexPath
            (self.controller as! AffiliationViewController).assignProductSelect(product: self.objectArray[(self.selected?.section)!].sectionObjects[(self.selected?.row)!], type: "contacto")
            self.navigationController?.popViewController(animated: true)
            break
        case "seleccionarContactoTrans":
            self.selected = indexPath
            (self.controller as! SinpeTransactionsViewController).assignProductSelect(product: self.objectArray[(self.selected?.section)!].sectionObjects[(self.selected?.row)!], type: "contacto")
            self.navigationController?.popViewController(animated: true)
            break
        default:
            print("default")
            break
        }
    }
    
    override func alertActionSi() {
        if self.selected != nil {
            (self.controller as! SelectFavoriteNumberViewController).assignProductSelect(product: self.objectArray[(self.selected?.section)!].sectionObjects[(self.selected?.row)!], type: "contacto")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func alertActionNo() {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 60.0
    }
    
}
