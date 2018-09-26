//
//  MainNewsTableViewCell.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 11/6/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class MainNewsTableViewCell: UITableViewCell {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var controller : UIViewController!
    @IBOutlet weak var btnShow: UIButton!
    
    @IBAction func showDetails(_ sender: AnyObject) {
        controller.performSegue(withIdentifier: "swNewsDetails", sender: sender)
    }
    
    func showEmpty()
    {
        lblTitle.text = ""
        //lblDate.text = ""
        //lblShortDescription.text =  ""
        self.isUserInteractionEnabled = false
        
    }
    func show(_ title: String,shortDescription: String,date:String,img: UIImage?)
    {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        
        lblTitle.text = title
        //lblDate.text = date //formatter.stringFromDate(date)
        //lblShortDescription.text =  shortDescription
        //print("Imagen: ", img!)
        if(img == nil)
        {
            self.imageNews.image = UIImage(named: "signInLogo")
        }
        else
        {
            
            self.imageNews.image = img
            
        }
    }

}
