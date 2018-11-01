//
//  NotificationsCell.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/26/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class NotificationsCell: UITableViewCell {
    
    @IBOutlet weak var switchNotifications: UISwitch!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var viewSwitch: UIView!
    
    var borderTop = CALayer()
    var borderBottom = CALayer()
    
    override func awakeFromNib(){
        super.awakeFromNib()
        self.txtEmail.layer.borderWidth = 0.7
        self.txtEmail.layer.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
        self.txtEmail.layer.cornerRadius = 4
        self.txtEmail.leftViewMode = UITextFieldViewMode.always
        let labelFrame = CGRect(x: 0, y: 0, width: 20, height: 40)
        let label = UILabel(frame: labelFrame)
        self.refreshBorders()
        self.txtEmail.leftView = label
        self.viewSwitch.layer.masksToBounds = true
    }
    
    func refreshBorders(){
        self.borderTop.removeFromSuperlayer()
        self.borderTop = CALayer()
        self.borderTop.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
        self.borderTop.frame = CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width), height: 1)
        self.borderTop.borderWidth = 1
        self.borderBottom.removeFromSuperlayer()
        self.borderBottom = CALayer()
        self.borderBottom.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.3).cgColor
        self.borderBottom.frame = CGRect(x: 0, y: (self.viewSwitch.frame.size.height) - 1, width: (UIScreen.main.bounds.width), height: 1)
        self.borderBottom.borderWidth = 1
        self.viewSwitch.layer.addSublayer(self.borderTop)
        self.viewSwitch.layer.addSublayer(self.borderBottom)
    }
    
}
