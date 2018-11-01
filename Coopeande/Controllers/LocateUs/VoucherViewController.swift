//
//  VoucherViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno01 on 10/2/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit
import AVFoundation

class VoucherViewController: UIViewController {

    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblAddress: UITextView!
    @IBOutlet weak var lblConfirm: UITextView!
    @IBOutlet weak var viewTotal: UIView!
    @IBOutlet weak var btnWaze: UIButton!
    @IBOutlet weak var viewLogoHeight: NSLayoutConstraint!
    @IBOutlet weak var viewButtonsHeight: NSLayoutConstraint!
    
    var number: String = ""
    var name: String = ""
    var address: String = ""
    var modalPrevious: RegisterViewController!
    var confirmation: String = ""
    var player: AVAudioPlayer?
    var latitudeSelected: String = ""
    var longitudeSelected: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblNumber.text = "#" + self.number
        self.lblName.text = self.name
        self.lblAddress.text = self.address
        self.lblConfirm.text = self.confirmation
        self.btnClose.layer.cornerRadius = 5
        self.btnWaze.layer.cornerRadius = 5
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async() {
            self.viewButtonsHeight.constant = UIApplication.shared.statusBarOrientation.isLandscape ? 110 : 150
            self.viewLogoHeight.constant = UIApplication.shared.statusBarOrientation.isLandscape ? 140 : 180
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let moveUp = CGAffineTransform(translationX: 0, y: (self.viewTotal.frame.height * -2))
        self.viewTotal.transform = moveUp
        if UIApplication.shared.statusBarOrientation.isLandscape {
            DispatchQueue.main.async() {
                self.viewButtonsHeight.constant = 110
                self.viewLogoHeight.constant = 140
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.playSound()
        UIView.animate(withDuration: 2, delay: 0, options: [], animations: {
            let moveDown = CGAffineTransform(translationX: 0, y: 0)
            self.viewTotal.transform = moveDown
        }, completion: nil )
    }
    
    func playSound(){
        guard let url = Bundle.main.url(forResource: "printBill", withExtension: "wav") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            player.play()
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            self.modalPrevious.dismiss(animated: false, completion: nil)
        })
    }
    
    @IBAction func waze(_ sender: UIButton) {
        if UIApplication.shared.canOpenURL(URL(string: "waze://")!) {
            let lat: String = self.latitudeSelected
            let long: String = self.longitudeSelected
            let urlStr = "waze://?ll="+lat+","+long+"&navigate=yes"
            UIApplication.shared.open(URL(string: urlStr)!)
        } else {
            UIApplication.shared.open(URL(string: "http://itunes.apple.com/us/app/id323229106")!)
        }
    }
    
}
