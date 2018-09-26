//
//  CheckBox.swift
//  Coopeande
//  Jonathan
//  Created by MacBookDesarrolloTecno on 31/8/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    // Images
    //let checkedImage = UIImage(named: "active_check_box")! as UIImage
    //let uncheckedImage = UIImage(named: "inactive_check_box")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                //self.setImage(checkedImage, for: UIControlState.normal)
                self.layer.backgroundColor = UIColor(red:0.00, green:0.58, blue:0.56, alpha:1.0).cgColor
            } else {
                //self.setImage(uncheckedImage, for: UIControlState.normal)
                self.layer.backgroundColor = UIColor.white.cgColor
            }
        }
    }
    
    override func awakeFromNib() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red:0.84, green:0.93, blue:0.93, alpha:1.0).cgColor
        self.layer.cornerRadius = 12.5
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
        self.isChecked = false
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
