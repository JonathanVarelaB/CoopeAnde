//
//  PlaceDetailViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 10/2/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit

class PlaceDetailViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UITextView!
    @IBOutlet weak var lblSchedule: UITextView!
    @IBOutlet weak var viewSchedule: UIView!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var lblDistanceDate: UILabel!
    @IBOutlet weak var lblDurationDate: UILabel!
    @IBOutlet weak var lblPeopleDate: UILabel!
    @IBOutlet weak var lbltimeDate: UILabel!
    @IBOutlet weak var lblPeopleLabel: UILabel!
    @IBOutlet weak var lblTimeLabel: UILabel!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnWaze: UIButton!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblDistanceLabel: UILabel!
    @IBOutlet weak var lblDurationLabel: UILabel!
    @IBOutlet weak var lblDistanceLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var lblDistanceDataHeight: NSLayoutConstraint!
    @IBOutlet weak var lblDurationLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var lblDurationDataHeight: NSLayoutConstraint!
    @IBOutlet weak var lblScheduleLabel: UILabel!
    @IBOutlet weak var viewSize: UIView!
    @IBOutlet weak var viewSizeHeight: NSLayoutConstraint!
    @IBOutlet weak var viewHourHeight: NSLayoutConstraint!
    @IBOutlet weak var lblScheduleHeight: NSLayoutConstraint!
    @IBOutlet weak var lblScheduleContentHeight: NSLayoutConstraint!
    
    var detail: PlaceDetail!
    var placeSelected: Place!
    var categorySelected: PlaceCategory!
    var latitudeUser: NSNumber = 0
    var longitudeUser: NSNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.16, green:0.44, blue:0.79, alpha:0.8)
        self.lblTitle.text = "Información de " + categorySelected.categoryName.description
        self.lblName.text = self.detail.name.description
        self.lblAddress.text = self.detail.address.description
        self.lblDistanceDate.text = self.detail.distance.description
        self.lblDurationDate.text = self.detail.duration.description
        self.lblPeopleDate.text = self.detail.peopleWaiting.description
        self.lbltimeDate.text = self.detail.timeWaiting.description
        self.lblPhone.text = self.detail.phone?.description
        self.lblSchedule.text = self.detail.scheduleAttention.description
        self.lblScheduleLabel.text = "Horario de Atención"
        self.setHeight()
        self.setDesign()
    }

    func setHeight() {
        //print("ALTURA: ", self.viewSizeHeight.constant)
        self.viewSizeHeight.constant = (Constants.iPhone) ? 525 : 750
        self.lblScheduleContentHeight.constant = (Constants.iPhone) ? 50 : 65
        self.viewHourHeight.constant = (Constants.iPhone) ? 65 : 80
        self.viewSchedule.layoutIfNeeded()
        self.lblSchedule.layoutIfNeeded()
        self.viewSize.layoutIfNeeded()
        if self.categorySelected.categoryPlaceId != "SUC" {
            self.viewSizeHeight.constant -= 115
            self.viewSize.layoutIfNeeded()
            self.lblSchedule.text = self.detail.other.description
            self.lblScheduleLabel.text = "Detalle"
            self.viewPhone.isHidden = true
            self.btnRegister.isHidden = true
            self.lbltimeDate.isHidden = true
            self.lblTimeLabel.isHidden = true
            self.lblPeopleDate.isHidden = true
            self.lblPeopleLabel.isHidden = true
            if self.detail.other.description == "" {
                self.lblScheduleHeight.constant = 0
                self.lblScheduleLabel.layoutIfNeeded()
                self.lblScheduleContentHeight.constant = 0
                self.lblSchedule.layoutIfNeeded()
                self.viewHourHeight.constant = 0
                self.viewSchedule.layoutIfNeeded()
                self.viewSizeHeight.constant -= Constants.iPhone ? 65 : 80
                self.viewSize.layoutIfNeeded()
            }
        }
        if self.detail.distance.description == "" {
            self.lblDistanceLabelHeight.constant = 0
            self.lblDistanceDataHeight.constant = 0
            self.lblDistanceDate.layoutIfNeeded()
            self.lblDistanceLabel.layoutIfNeeded()
            self.viewSizeHeight.constant -= 15
            self.viewSize.layoutIfNeeded()
        }
        if self.detail.duration.description == "" {
            self.lblDurationLabelHeight.constant = 0
            self.lblDurationDataHeight.constant = 0
            self.lblDurationDate.layoutIfNeeded()
            self.lblDurationLabel.layoutIfNeeded()
            self.viewSizeHeight.constant -= 15
            self.viewSize.layoutIfNeeded()
        }
    }
    
    func setDesign(){
        self.viewMain.layer.cornerRadius = 7
        self.btnRegister.layer.cornerRadius = 5
        self.btnWaze.layer.cornerRadius = 5
        let border = CALayer()
        border.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.2).cgColor
        border.frame = CGRect(x: 0, y: (self.viewSchedule.frame.size.height) - 1, width: UIScreen.main.bounds.width, height: 1)
        border.borderWidth = 1
        self.viewSchedule.layer.addSublayer(border)
        self.viewSchedule.layer.masksToBounds = true
        let border1 = CALayer()
        border1.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.2).cgColor
        border1.frame = CGRect(x: 0, y: Constants.iPhone ? 34 : 44, width: UIScreen.main.bounds.width, height: 1)
        border1.borderWidth = 1
        let border2 = CALayer()
        border2.borderColor = UIColor(red:0.20, green:0.67, blue:0.65, alpha:0.2).cgColor
        border2.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1)
        border2.borderWidth = 1
        self.viewPhone.layer.addSublayer(border1)
        self.viewPhone.layer.addSublayer(border2)
        self.viewPhone.layer.masksToBounds = true
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(PlaceDetailViewController.call))
        self.lblPhone.isUserInteractionEnabled = true
        self.lblPhone.addGestureRecognizer(singleTap)
    }
    
    @objc func call(){
        let p = Helper.removeFormatAmount(detail.phone?.description)
        if let url = URL(string: "tel://" + p) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func register(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        vc.detail = self.detail
        vc.categorySelected = self.categorySelected
        vc.latitudeUser = self.latitudeUser
        vc.longitudeUser = self.longitudeUser
        vc.modalPrevious = self
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func openWaze(_ sender: UIButton) {
        if UIApplication.shared.canOpenURL(URL(string: "waze://")!) {
            let lat: String = self.placeSelected!.latitude.description
            let long: String = self.placeSelected!.longitude.description
            let urlStr = "waze://?ll="+lat+","+long+"&navigate=yes"
            UIApplication.shared.open(URL(string: urlStr)!)
        } else {
            UIApplication.shared.open(URL(string: "http://itunes.apple.com/us/app/id323229106")!)
        }
    }
    
}
