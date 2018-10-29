//
//  PlaceItemList.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 10/17/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class PlaceItemList{
    
    var category: PlaceCategory!
    var name: String = ""
    var colorName: UIColor!
    var subCategory: NSString = ""
    
    init(name: String, colorName: UIColor, category: PlaceCategory! = nil, subCategory: NSString = "") {
        self.category = category
        self.name = name
        self.colorName = colorName
        self.subCategory = subCategory
    }
    
}
