//
//  Style.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 17/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import Foundation
import UIKit

struct Style
{
    static let mainColor1 = UIColor(red:185.0/255.0, green:201.0/255.0, blue:213.0/255.0, alpha:1.0)
    static let mainColor2 = UIColor(red:0.0/255.0, green:149.0/255.0, blue:142/255.0, alpha:1.0)
    //static let modalBackgroundColor = UIColor(red:1, green:1, blue:1, alpha:0.80)
    static let modalBackgroundColor = UIColor(red:0.01, green:0.39, blue:0.78, alpha:0.75)
    
    static let mainColor3 = UIColor(red:64/255.0, green:65/255.0, blue:66/255.0, alpha:1)// negro
    static let mainColor4 = UIColor(red:0 / 255.0, green: 83/255.0, blue:159/255.0, alpha:1)//azul
    static let mainColor5 = UIColor(red:237/255.0, green:28/255.0, blue:46/255.0, alpha:1)//rojo
    static let mainColor6 = UIColor(red:144/255.0, green:65/255.0, blue:153/255.0, alpha:1)//morado
    static let mainColor7 = UIColor(red:247/255.0, green:146/255.0, blue:40/255.0, alpha:1)//amarillo
    static let mainColor8 = UIColor(red:64/255.0, green:174/255.0, blue:73/255.0, alpha:1)//verde
    
    
    static let mainColor9 = UIColor(red:255/255.0, green:255/255.0, blue:255/255.0, alpha:0.65)//rojo
    static let mainColor10 = UIColor(red:64/255.0, green:174/255.0, blue:73/255.0, alpha:0.65)//verde
    
    static let navBackButtonImage:UIImage = UIImage()
    static let navBackgroundImage:UIImage = UIImage()
    static let navShadowImage:UIImage = UIImage()
    
    static let navBarTintColor : UIColor?  = nil
    static let navBarButtonImage:UIImage  = UIImage(named:"menuBtn")!
    static let navFont:UIFont = UIFont( name: "Helvetica", size: 17.0)!
    static let navTextAttributes:NSDictionary = NSDictionary(
        objects:
        [navFont,mainColor1],
        forKeys:
        [kCTFontAttributeName as! NSCopying,kCTForegroundColorAttributeName as! NSCopying])
    
    static let navButtonTextAttributes:NSDictionary = NSDictionary(
        objects:
        [navFont,mainColor2],
        forKeys:
        [kCTFontAttributeName as! NSCopying,kCTForegroundColorAttributeName as! NSCopying])
    
    static let textFieldPadding: UIEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5)
    static var isLoginBarStyleApply : Bool = true;
    static func applyAll()
    {
        UIBarButtonItem.appearance().setTitleTextAttributes(Style.navTextAttributes as? [NSAttributedStringKey : Any], for: UIControlState.normal)
        //if Constants.iPad
        //{
        //UITableView.appearance().backgroundColor = UIColor.clearColor()
        //}
        
    }
    static func navBarStyleForLogin(_ bar : UINavigationBar?)
    {
        isLoginBarStyleApply=true
        var appearance  = UINavigationBar.appearance()
        
        if(bar != nil){
            appearance = bar!
        }
        appearance.setBackgroundImage (Style.navBackgroundImage, for: .any, barMetrics: .default )
        appearance.shadowImage = Style.navShadowImage;
        appearance.titleTextAttributes = Style.navTextAttributes as? [NSAttributedStringKey : Any]
        appearance.barTintColor = mainColor2
        appearance.tintColor = mainColor1
        appearance.backgroundColor = nil
        if(Constants.iOS8) {
            appearance.isTranslucent = true
        }
        else
        {
            appearance.barStyle = UIBarStyle.blackTranslucent
        }
    }
    static func navBarStyle(_ bar : UINavigationBar?)
    {
        isLoginBarStyleApply = false
        var appearance  = UINavigationBar.appearance()
        
        if(bar != nil){
            appearance = bar!
        }
        
        appearance.setBackgroundImage (Style.navBackgroundImage, for: .any, barMetrics: .default )
        appearance.shadowImage = Style.navShadowImage;
        appearance.titleTextAttributes = Style.navTextAttributes as? [NSAttributedStringKey : Any]
        appearance.barTintColor = mainColor2
        appearance.backgroundColor=mainColor2
        appearance.tintColor = mainColor1
        if(Constants.iOS8) {
            appearance.isTranslucent = false
        }
        else
        {
            appearance.barStyle = UIBarStyle.black
        }
    }
    static func navBarStyleForMain(_ bar : UINavigationBar?)
    {
        isLoginBarStyleApply = true
        var appearance  = UINavigationBar.appearance()
        
        if(bar != nil){
            appearance = bar!
        }
        appearance.setBackgroundImage (Style.navBackgroundImage, for: .any, barMetrics: .default )
        appearance.shadowImage = Style.navShadowImage;
        appearance.titleTextAttributes = Style.navTextAttributes as? [NSAttributedStringKey : Any]
        appearance.barTintColor = mainColor2
        appearance.tintColor = mainColor1
        if(Constants.iOS8) {
            appearance.isTranslucent = true
        }
        else
        {
            appearance.barStyle = UIBarStyle.blackTranslucent
        }
        appearance.backgroundColor=nil
        
        
    }
    
    //MAPS
    static let mapMarkerImage :UIImage = UIImage(named:"pinMap")!
    
    
}
