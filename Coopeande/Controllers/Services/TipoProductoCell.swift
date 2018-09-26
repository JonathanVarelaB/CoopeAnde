//
//  TipoProductoCell.swift
//  Coopeande
//  Jonathan Varela
//  Created by MacBookDesarrolloTecno on 20/8/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class TipoProductoCell: UICollectionViewCell {
    
    @IBOutlet weak var viewService: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var btnConsultar: UIButton!
    var aliasTypeId: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
