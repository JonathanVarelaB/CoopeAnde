//
//  File.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/19/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class OptionMenuSinpeCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewOption: UIView!
    @IBOutlet weak var viewSelect: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewOption.layer.cornerRadius = 7
    }
    
    func show(option: OptionMenuSinpe){
        self.image.image = option.image
        self.lblTitle.text = option.name
        self.viewOption.layer.backgroundColor = option.color?.cgColor
        if option.selected {
            self.viewSelect.layer.backgroundColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.5).cgColor
        }
        else{
            self.viewSelect.layer.backgroundColor = UIColor.white.cgColor
        }
    }
    
}
