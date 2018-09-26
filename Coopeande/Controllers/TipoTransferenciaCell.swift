//
//  TipoTransferenciaCell.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 20/8/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class TipoTransferenciaCell: UICollectionViewCell {
    
    @IBOutlet weak var lblTipoTransferencia: UILabel!
    @IBOutlet weak var lbComission: UILabel!
    @IBOutlet weak var imgTipoTrasnferencia: UIImageView!
    
    var commission: NSNumber?
    var id: NSString?
    var name: NSString?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func show(id: NSString, name : NSString, commission: NSNumber, currencySign : NSString){
        self.id = id
        self.name = name
        self.commission = commission
        //self.lbComission.text = "Comisión: " + Helper.formatAmount(commission, currencySign: currencySign)
        self.lbComission.text =  Helper.formatAmount(commission, currencySign: currencySign as String)
        lblTipoTransferencia.text = name as String
        
    }
}
