//
//  OptionMenuSinpe.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/19/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class OptionMenuSinpe: SelectableProduct {
    
    var name: String = ""
    var image: UIImage? = nil
    var color: UIColor? = nil
    
    init(name: String, image: UIImage, color: UIColor){
        self.name = name
        self.image = image
        self.color = color
    }
    
}
