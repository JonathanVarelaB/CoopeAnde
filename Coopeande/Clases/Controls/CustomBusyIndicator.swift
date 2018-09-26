//
//  CustomBusyIndicator.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 25/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation
import UIKit
import MONActivityIndicatorView

class CustomBusyIndicator : UIView, MONActivityIndicatorViewDelegate
{
    
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private func config()
    {
        self.isOpaque = false
        
    }
    
    func activityIndicatorView( activityIndicatorView : MONActivityIndicatorView,
                                circleBackgroundColorAtIndex index : UInt )-> UIColor
    {
        switch (index) {
        case 0:
            return Style.mainColor4
        case 1:
            return Style.mainColor5
        case 2:
            return Style.mainColor6
        case 3:
            return Style.mainColor7
        default:
            return Style.mainColor3
        }
    }
}
/*
 struct CustomBusyIndicatorSingleton
 {
 private static var instance : CustomBusyIndicator?
 static var Instance : CustomBusyIndicator
 {
 get{
 var result : CustomBusyIndicator
 if let already = instance
 {
 result = already
 }
 else {
 instance = CustomBusyIndicator()
 result = instance!
 }
 return result
 }
 }
 }*/
