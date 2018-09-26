//
//  CalculatorTypes.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 9/6/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class CalculatorTypes : EntityBase {
    
    var calculationList: Array<CalculatorType> = []
    var savingList: Array<SavingType> = []
    
    func copy(with zone: NSZone? = nil) -> Any {
        return CalculatorTypes(calculation: calculationList, saving: savingList)
    }
    
    init(calculation: Array<CalculatorType>, saving: Array<SavingType>){
        self.calculationList = calculation
        self.savingList = saving
    }
    
    override func fromJson(_ response:NSDictionary?){
        if let data = response{
            if let value1 : NSArray = data.object(forKey: "calculationTypeList") as? NSArray{
                self.calculationList = []
                for item in value1{
                    let detail = CalculatorType()
                    detail.fromJson( item as? NSDictionary)
                    self.calculationList.append(detail)
                }
            }
            if let value2 : NSArray = data.object(forKey: "savesTypeList") as? NSArray{
                self.savingList = []
                for item in value2{
                    let detail = SavingType()
                    detail.fromJson( item as? NSDictionary)
                    self.savingList.append(detail)
                }
            }
        }
    }
}
