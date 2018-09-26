//
//  StatementSectionHeaderViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 25/6/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class StatementSectionHeaderViewController: UIViewController {

    
    @IBOutlet weak var lblHeaderTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblHeaderTitle.text = self.title
    }

}
