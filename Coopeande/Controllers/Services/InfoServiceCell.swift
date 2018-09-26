//
//  FromAccountCell.swift
//  Coopeande
//  Jonathan Varela
//  Created by MacBookDesarrolloTecno on 21/8/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class InfoServiceCell: UITableViewCell {
    
    @IBOutlet weak var lblTypeProduct: UILabel!
    @IBOutlet weak var lblSelectProduct: UILabel!
    @IBOutlet weak var lblFirstDetail: UILabel!
    @IBOutlet weak var lblSecondDetail: UILabel!
    @IBOutlet weak var lblThirdDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func show(type: String, select: String, firstDetail: String, secondDetail: String, thirdDetail: String){
        self.lblTypeProduct.text = type
        self.lblSelectProduct.text = select
        self.lblFirstDetail.text = firstDetail
        self.lblSecondDetail.text = secondDetail
        self.lblThirdDetail.text = thirdDetail
    }
    
}
