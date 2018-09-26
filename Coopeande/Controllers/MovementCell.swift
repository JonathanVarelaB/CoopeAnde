//
//  MovementCell.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 25/6/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class MovementCell: UITableViewCell {

    @IBOutlet weak var lblDocumentNumber: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblMovementSite: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    /*func show(_ time: String,documentNumber: String, movementType: String, amount:String){
        
        lblTime.text = time
        lblDocumentNumber.text = documentNumber
        if((lblMovementSite.text?.count)! > 3)
        {
            //let index = advance(movementType.startIndex, 3)
            let index = movementType.index(movementType.startIndex, offsetBy: 3)
            lblMovementSite.text = movementType.substring(to: index) //movementType
        }
        else
        {
            lblMovementSite.text = movementType
        }
        lblAmount.text = amount
    }*/
    
    func show(time: String,documentNumber: String, movementType: String, amount:String){
        
        lblTime.text = time
        lblDocumentNumber.text = documentNumber
        lblMovementSite.text = movementType
       /* if(movementType.count > 3)
        {
            let index = movementType.index(movementType.endIndex, offsetBy: 3)
            
            //text.substring(from: index) // "4567890"   [Swift 3]
            //String(text[index...])      // "4567890"   [Swift 4]
            lblMovementSite.text = String(movementType[index...])
        }
        else
        {
            lblMovementSite.text = movementType
        }*/
        lblAmount.text = amount
    }

}
