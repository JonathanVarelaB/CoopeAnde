//
//  PlaceCategory.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 17/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class PlaceCategory: EntityBase {
    var categoryName:NSString = ""
    var categoryPlaceId:NSString = ""
    var subCategories:Array<PlaceCategory> = []
    var subId:NSString = ""

    override func fromJson(_ response: NSDictionary?) {
        if let data = response
        {
            if let value2: AnyObject = data ["categoryName"] as AnyObject?
            {
                self.categoryName = value2.description as NSString
            }
            if let value3: AnyObject = data ["categoryPlaceId"] as AnyObject?
            {
                self.categoryPlaceId = value3.description as NSString
            }
            if let value2: AnyObject = data ["subCategoryPlaceId"] as AnyObject?
            {
                self.categoryPlaceId = value2.description as NSString
            }
            if let value2: AnyObject = data ["subCategoryName"] as AnyObject?
            {
                self.categoryName = value2.description as NSString
            }
            if let value2: AnyObject = data ["subCategoryPlaceId"] as AnyObject?
            {
                self.subId = value2.description as NSString
            }
            if let value4 : NSArray = data.object(forKey: "subCategoryPlaceList") as? NSArray
            {
                for item in value4
                {
                    let detail = PlaceCategory()
                    detail.fromJson( item as? NSDictionary)
                    detail.categoryPlaceId = self.categoryPlaceId
                    subCategories.append(detail)
                }
                if(subCategories.count == 1)
                {
                    subId = subCategories[0].subId
                    subCategories = []
                }
            }
        }
    }
}
