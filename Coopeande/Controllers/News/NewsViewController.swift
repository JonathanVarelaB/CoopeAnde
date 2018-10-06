//
//  NewsViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 11/6/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit
import MCMHeaderAnimated

class NewsViewController: UIViewController {
    
    @IBOutlet weak var header: UIView!
    
    var data: Ads?
    
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var tvData:UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Anuncios"
        show(data!.title as String,shortDescription: data!.description as String ,date:data!.date as String,img: data!.imageUrl)
        // Do any additional setup after loading the view.
        let border = CALayer()
        border.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.4).cgColor
        border.frame = CGRect(x: 5, y: (self.lblTitle.frame.size.height) - 1, width: (self.view.frame.size.width) - 60, height: 1)
        border.borderWidth = 1
        self.lblTitle.layer.addSublayer(border)
        self.lblTitle.layer.masksToBounds = true
        self.backAction()
    }
    
    func backAction(){
        self.navigationItem.hidesBackButton = true
        let backItem = UIBarButtonItem(image: UIImage(named: "backButton"), landscapeImagePhone: UIImage(named: "backButton"), style: .plain, target: self, action: #selector(returnBack(sender:)))
        self.navigationItem.leftBarButtonItem = backItem
    }
    
    @objc func returnBack(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.navigationBar.tintColor = UIColor.white
        //self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    func showEmpty()
    {
        lblTitle.text = ""
        tvData.text =  ""
    }
    
    func show(_ title: String,shortDescription: String,date:String,img: UIImage?)
    {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        
        lblTitle.text = title
        tvData.text =  shortDescription
        
        //let data  = tvData.textStorage
        //let additionalAttrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body )]// [NSFontAttributeName : UIFont.preferredFont(forTextStyle: UIFontTextStyle.body )]
        //data.addAttributes(additionalAttrs, range: NSRange(location: 0,length: tvData.text.count ))
        var topCorrect : CGFloat = CGFloat((tvData.bounds.size.height - tvData.contentSize.height * tvData.zoomScale))
        topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
        tvData.contentOffset = CGPoint(x:0, y: -topCorrect);
        
        
        if(img == nil){
            self.titleImage.image = UIImage(named: "Logo-horizontal-blanco")
            self.titleImage.contentMode = .scaleAspectFit
        }
        else{
            self.titleImage.image = img
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
