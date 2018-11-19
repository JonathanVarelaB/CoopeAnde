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
    @IBOutlet weak var viewLbl: UIView!
    
    
    @IBAction func showDetails(_ sender: AnyObject) {
        controller.performSegue(withIdentifier: "swNewsDetails", sender: sender)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.background.layer.cornerRadius = 5
        self.header.layer.cornerRadius = 5
        self.imageNews.layer.cornerRadius = 5
        self.viewLbl.layer.cornerRadius = 5
    }
    
    func showEmpty(){
        lblTitle.text = ""
        //lblDate.text = ""
        //lblShortDescription.text =  ""
        self.isUserInteractionEnabled = false
    }
    
    func show(_ title: String,shortDescription: String,date:String,img: String){
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        lblTitle.text = title
        //lblDate.text = date //formatter.stringFromDate(date)
        //lblShortDescription.text =  shortDescription
        
        if img.range(of: ".gif") != nil{
            self.imageNews.image = UIImage.gifImageWithURL(gifUrl: img)
        }
        else{
            if img.range(of: ".png") != nil || img.range(of: ".jpg") != nil || img.range(of: ".jpeg") != nil{
                let url = URL(string: img)
                let data = try? Data(contentsOf: url!)
                if let imageData = data {
                    self.imageNews.image = UIImage(data: imageData)
                }
            }
            else{
                if let decodedData = NSData(base64Encoded: img, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters){
                    self.imageNews.image = UIImage(data: decodedData as Data)
                }
                else{
                    self.imageNews.image = UIImage(named: "Logo-horizontal-blanco")
                    self.imageNews.contentMode = .scaleAspectFit
                }
            }
        }
        
        /*
        if(img == nil){
            self.imageNews.image = UIImage(named: "Logo-horizontal-blanco")
            self.imageNews.contentMode = .scaleAspectFit
        }
        else{
            print(img)
            self.imageNews.image = img
        }*/
    }

}
