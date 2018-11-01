//
//  PasswordCell.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 25/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation
import UIKit

class PasswordCell: UICollectionViewCell {
    
    var delegate: PasswordKeyDelegate?
    
    @IBAction func touchDown(_ sender: AnyObject) {
        if delegate != nil {
            if let btn = sender as? UIButton{
                btn.backgroundColor = UIColor.white
            }
        }
    }
    
    @IBAction func passwordKeyTap(_ sender: AnyObject) {
        if delegate != nil {
            if let btn = sender as? UIButton{
                delegate?.PasswordKey(btn.titleLabel!.text!)
                btn.backgroundColor = UIColor.white
            }
        }
    }
    
    @IBAction func deleteLastKey(_ sender: AnyObject) {
        delegate?.PasswordKey(NSString(format: "%c",13) as String)
        if let btn = sender as? UIButton{
            btn.backgroundColor = UIColor.white
        }
    }
    
}
