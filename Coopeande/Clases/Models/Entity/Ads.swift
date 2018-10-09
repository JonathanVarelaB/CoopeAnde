//
//  Ads.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 11/6/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation
import UIKit

class Ads:EntityBase {
    
    //var imageUrl: UIImage?
    var imageUrl: String = ""
    var title: NSString = ""
    var description: NSString = ""
    var date: NSString = ""
    var dateTime: Date?
    
    override func fromJson(_ response:NSDictionary?){
        if let data = response{
            if let value: NSString  = data["imageURL"] as? NSString{
                self.imageUrl = value.description
                /*
                if value.description.range(of: ".gif") != nil{
                    imageUrl = UIImage.gifImageWithURL(gifUrl: value.description)
                }
                else{
                    if let decodedData = NSData(base64Encoded: value as String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters){
                        imageUrl = UIImage(data: decodedData as Data)
                    }
                }
                */
            }
            if let value: AnyObject  = data["title"] as AnyObject?{
                self.title = value.description as NSString
            }
            if let value: AnyObject  = data["description"] as AnyObject?{
                self.description = value.description as NSString
            }
            if let value: AnyObject  = data["date"] as AnyObject?{
                self.date = value.description as NSString
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss";
                self.dateTime = dateFormat.date(from: self.date as String);
                dateFormat.dateFormat = "dd/MM/yyyy hh:mm a";
                if(self.dateTime != nil){
                    self.date = dateFormat.string(from: self.dateTime!) as NSString
                }
            }
        }
    }
    
}
