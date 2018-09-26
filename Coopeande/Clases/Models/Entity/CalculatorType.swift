//
//  CalculatorType.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/6/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class CalculatorType: SelectableProduct {
    
    var code : String = ""
    var name : String = ""
    
    override func fromJson(_ response:NSDictionary?){
        if let data = response{
            if let value = data["code"] as? String{
                self.code = value
            }
            if let value = data ["name"] as? String{
                self.name = value
            }
        }
    }
    
}
