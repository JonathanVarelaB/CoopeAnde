//
//  OfficeModalViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 19/6/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class OfficeModalViewController: BaseMapModal{


    @IBOutlet weak var tvAddress: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblQueueTime: UILabel!
    @IBOutlet weak var lblPeopleQueue: UILabel!
    @IBOutlet weak var lblETA: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var tvPhone: UITextView!
    @IBOutlet weak var tvSchedule: UITextView!
    
    var showTicket = false
    var oldFrame : CGRect = CGRect(x: 0,y: 0,width: 0,height: 0)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutableRawPointer) {
        print(keyPath)
        print(change)
        if(showTicket)
        {
            if let viewController : OfficeModalViewController = object as? OfficeModalViewController
            {
                //showTicket = false
                if( viewController.view.frame != oldFrame)
                {
                    viewController.view.frame = oldFrame
                }
            }
        }
    }
    override func showData()
    {
        if let detail = self.placeDetail
        {
            
            tvAddress.text = detail.address as String
            lblQueueTime.text = detail.timeWaiting as String
            lblPeopleQueue.text = detail.peopleWaiting as String
            tvPhone.text = Helper.parseText(detail.phone! as String)
            tvSchedule.text = Helper.parseText(detail.scheduleAttention as String)
            lblName.text = detail.name as String
            
            
        }
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var controller =  segue.destination as? TicketModalViewController
        controller?.placeDetail = self.placeDetail
        controller?.latitude = self.place?.latitude
        controller?.longitude = self.place?.longitude
        showTicket = true
        oldFrame = self.view.frame
    }
    
    override func showDistanceData(_ eta:String, distanceDescription:String)
    {
        lblETA.text = eta
        lblDistance.text = distanceDescription
        
    }
}
