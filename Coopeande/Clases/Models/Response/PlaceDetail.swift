//
//  PlaceDetail.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 31/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation

class PlaceDetail: EntityBase {
    
    var address: NSString = ""
    var name: NSString = ""
    var peopleWaiting: NSString = ""
    var placeId: NSString = ""
    var scheduleAttention: NSString = ""
    var timeWaiting: NSString = ""
    var phone:NSString?
    var promo: NSString = ""
    var other: NSString = ""
    
    override func fromJson(_ response: NSDictionary?) {
        if let data = response
        {
            if let value1: AnyObject = data ["address"] as AnyObject?
            {
                self.address = value1.description as NSString
            }
            if let value2: AnyObject = data ["name"] as AnyObject?
            {
                self.name = value2.description as NSString
            }
            if let value3: AnyObject = data ["peopleWaiting"] as AnyObject?
            {
                self.peopleWaiting = value3.description as NSString
            }
            if let value4: AnyObject = data ["placeId"] as AnyObject?
            {
                self.placeId = value4.description as NSString
            }
            if let value5: AnyObject = data ["scheduleAttention"] as AnyObject?
            {
                self.scheduleAttention = value5.description as NSString
            }
            if let value6: AnyObject = data ["timeWaiting"] as AnyObject?
            {
                self.timeWaiting = (value6.description + " min") as NSString
            }
            if let value7: AnyObject = data ["phoneNumber"] as AnyObject?
            {
                self.phone = value7.description as NSString?
            }
            if let value5: AnyObject = data ["discount"] as AnyObject?
            {
                self.promo = value5.description as NSString
            }
            if let value5: AnyObject = data ["observation"] as AnyObject?
            {
                self.other = value5.description as NSString
            }
        }
    }
}
