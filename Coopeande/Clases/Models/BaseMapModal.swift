//
//  BaseMapModal.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 31/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class BaseMapModal: BaseModalViewController {

    var place : Place?
    var placeDetail : PlaceDetail?
    var userLocation : CLLocation?
    
    
    @IBAction func invokeMapAddress(_ sender: AnyObject) {
        
        let hasWaze = UIApplication.shared.canOpenURL(URL( string:"waze://")!)
        let lat = place?.latitude.floatValue
        let lon = place?.longitude.floatValue
        var urlStr : String =  ""
        
        if (hasWaze){
            urlStr =  String(format: "waze://?ll=%f,%f&navigate=yes",lat!,lon!);
        }
        else
        {
            // Waze is not installed. Launch AppStore to install Waze app
            urlStr = "https://itunes.apple.com/app/waze-social-gps-maps-traffic/id323229106?l=en&mt=8"
            //            if let myLocation = userLocation
            //            {
            //                urlStr = String(format: "https://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f&directionsmode=directionsmode", myLocation.coordinate.latitude, myLocation.coordinate.longitude, lat!,lon!);
            //            }
            //            else
            //            {
            //                urlStr = String(format: "https://maps.google.com/maps?daddr=%f,%f&directionsmode=directionsmode",  lat!,lon!);
            //            }
            
        }
        
        DispatchQueue.main.async {
            let url = URL(string: urlStr)
            UIApplication.shared.canOpenURL(url!)
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.showData()
        super.viewWillAppear(animated)
    }
    
    
    func showData()
    {
    }
    func getDistanceData()
    {
        //let request = NSURLRequest()
        let lat = place?.latitude.floatValue
        let lon = place?.longitude.floatValue
        print("Latitude: ", userLocation?.coordinate.latitude)
        print("Longitude: ", userLocation?.coordinate.longitude)
        print("Lat: ", lat)
        print("Lon: ", lon)
        let url = String(format: "https://maps.googleapis.com/maps/api/distancematrix/json?language=es&origins=%f,%f&destinations=%f,%f",userLocation!.coordinate.latitude, userLocation!.coordinate.longitude, lat!,lon!)
        // Send HTTP GET Request
        let myUrl = NSURL(string: url);
        // Creaste URL Request
        let request = NSMutableURLRequest(url:myUrl! as URL);
        // Set request HTTP method to GET. It could be POST as well
        request.httpMethod = "GET"
        // Excute HTTP Request
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            // Check for error
            if error != nil
            {
                DispatchQueue.main.async {
                    self.showDistanceData(Helper.getLocalizedText("unknown"), distanceDescription: Helper.getLocalizedText("unknown"))
                }
                print("error=\(String(describing: error))")
                return
            }
            // Print out response string
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString1 = \(String(describing: responseString))")
            // Convert server json response to NSDictionary
            do {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    // Print out dictionary
                    print(convertedJsonIntoDict)
                    //self.didReceiveResponse(convertedJsonIntoDict)
                    // Get value by key
                    //let firstNameValue = convertedJsonIntoDict["userName"] as? String
                    //print(firstNameValue!)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.showDistanceData(Helper.getLocalizedText("unknown"), distanceDescription: Helper.getLocalizedText("unknown"))
                }
            }
            
        }
        
        task.resume()
        
        
        
        /*request.delegate = self
        request.doGet(url, success: { (result) in
            self.didReceiveResponse(result as! NSDictionary)
        }) { (error) in
            DispatchQueue.main.async {
                self.showDistanceData(Helper.getLocalizedText("unknown"), distanceDescription: Helper.getLocalizedText("unknown"))
            }
        }*/
        
        /* request.doGet(url, success:{ (result) in
            self.didReceiveResponse(result)
         }, failure:
         { (error) -> Void in
             DispatchQueue.main.async {
                self.showDistanceData(Helper.getLocalizedText("unknown"), distanceDescription: Helper.getLocalizedText("unknown"))
             }
         })*/
    }
    class func getInfoView(_ selectedFilter:PlaceCategory, place: Place, userLocation : CLLocation?, success:((PlaceDetailResponse,BaseMapModal?)  -> Void )!, failure: ((NSError)  -> Void )!)
    {
        let request : PlaceDetailRequest = PlaceDetailRequest()
        request.placeId = place.placeId;
        request.latitude = NSNumber(value: place.latitude.floatValue)
        request.longitude = NSNumber(value: place.longitude.floatValue)
        request.categoryPlaceId = selectedFilter.categoryPlaceId
        request.subCategoryPlaceId = selectedFilter.subId
        
        request.typeId = place.placeId
        let ProxyManager :UtilProxyManager = UtilProxyManager()
        
        ProxyManager.GetPlaceDetail(request  ,success:{
            (result) in
            var viewToShow : BaseMapModal?
            DispatchQueue.main.async {
            if result.isSuccess
            {
                print("Categoria: ", place.categoryPlaceId)
                switch (place.categoryPlaceId) {
                case "CAJ":
                    //viewToShow = Helper.getViewController("AtmModalViewController") as!  AtmModalViewController
                    break;
                case "CONV":
                    //viewToShow = Helper.getViewController("PromotionsModalViewController") as!  PromotionsModalViewController
                    break;
                case "SUC":
                    viewToShow = Helper.getViewController("OfficeModalViewController") as!  OfficeModalViewController
                    break;
                default:
                    //viewToShow = Helper.getViewController("OthersModalViewController") as!  OthersModalViewController
                    
                    break;
                }
                //print("UserLocation: ", userLocation!)
                print("Place detail: ", result.data?.name)
                viewToShow?.userLocation = userLocation
                viewToShow?.place = place
                viewToShow?.placeDetail = result.data
                if(userLocation != nil) {
                    viewToShow?.getDistanceData()
                }
            }
            success(result,viewToShow)
            }
        },
                                    failure:
            { (error) -> Void in
                if( failure != nil)
                {
                    failure(error)
                }
                
        })
    }
    
    func showDistanceData(_ eta:String, distanceDescription:String)
    {
        
    }
    
    func didReceiveResponse(_ data: NSDictionary) {
        var eta : String = Helper.getLocalizedText("unknown")
        var distanceDescription : String = Helper.getLocalizedText("unknown")
        
        if (data["status"] as! NSString == "OK")
        {
            if let rows : NSArray = data["rows"] as? NSArray
            {
                if let row : NSDictionary = rows[0] as? NSDictionary
                {
                    if let elements : NSArray = row.allValues.first as? NSArray
                    {
                        if let detail = elements[0] as? NSDictionary
                        {
                            if let distance  = detail["distance"] as? NSDictionary
                            {
                                distanceDescription = (distance["text"] as! NSString) as String
                            }
                            if let duration : NSDictionary = detail["duration"] as? NSDictionary
                            {
                                eta = (duration["text"] as! NSString) as String
                            }
                        }
                    }
                }
            }
        }
        DispatchQueue.main.async {
            self.showDistanceData(eta, distanceDescription: distanceDescription)
        }
    }
    /*func didReceiveResponse(_ error :NSUrlErrorType){
     }*/
}
