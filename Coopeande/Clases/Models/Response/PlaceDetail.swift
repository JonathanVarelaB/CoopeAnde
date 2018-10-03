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
    var distance: NSString = ""
    var duration: NSString = ""
    
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
                self.other = (self.other == "<null>") ? "" : self.other
            }
            if let value5: AnyObject = data["distance"] as AnyObject?
            {
                self.distance = value5.description as NSString
                self.distance = (self.distance == "<null>") ? "" : self.distance
            }
            if let value5: AnyObject = data ["duration"] as AnyObject?
            {
                self.duration = value5.description as NSString
                self.duration = (self.duration == "<null>") ? "" : self.duration
            }
        }
    }
}
