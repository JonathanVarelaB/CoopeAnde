//
//  MapViewController.swift
//  Coopeande
//
//  Created by MacBookDesarrolloTecno on 31/5/18.
//  Copyright © 2018 Tecnosistemas Pridessa SA. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Floaty
import SCLAlertView

class MapViewController: BaseViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var gmaps: MKMapView!
    
    let floaty = Floaty()
    //let popUpController = mapPopUpViewController()
    var timer: Timer?
    var selectedPlace: Place?
    var selectedSubCategory: NSString = ""
    var selectedCategory: PlaceCategory = PlaceCategory() { didSet{ _ = self.loadMarkers() } }
    var mapcenter: CLLocationCoordinate2D?
    var annotationLoaded: Bool = false
    var userLocation: CLLocation?
    let locationManager = CLLocationManager()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //popUpController.crateInstanceOfPopUp(senderView: self.view, theViewController: self, sizeOfPopUpViewContainer: Int(self.view.frame.height))
        self.title = "Agencias"
        self.backAction()
        self.loadPlacesCategories()
        self.locationManager.delegate = self
        Constants.iOS8 ? locationManager.requestWhenInUseAuthorization() : startListeningLocation()
        self.floaty.DeviceVersion = DeviceVersion.modelName as NSString
        self.contentView.addSubview(floaty)
        self.gmaps.delegate = self
        self.gmaps.isZoomEnabled = true
        self.gmaps.showsUserLocation = true
    }
    
    func backAction(){
        self.navigationItem.hidesBackButton = true
        let backItem = UIBarButtonItem(image: UIImage(named: "backButton"), landscapeImagePhone: UIImage(named: "backButton"), style: .plain, target: self, action: #selector(returnBack(sender:)))
        self.navigationItem.leftBarButtonItem = backItem
        let findItem = UIBarButtonItem(image: UIImage(named: "find"), landscapeImagePhone: UIImage(named: "find"), style: .plain, target: self, action: #selector(findMe(sender:)))
        self.navigationItem.rightBarButtonItem = findItem
    }
    
    @objc func returnBack(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func findMe(sender: UIBarButtonItem) {
        switch self.checkLocation() {
        case 1:
            self.startListeningLocation()
            break
        case 0:
            self.showAlert("Atención", messageKey: "Debe de activar los servicios de ubicación")
            break
        default:
            self.showAlert("Atención", messageKey: "Debe de permitir el uso de los servicios de ubicación")
            break
        }
    }

    func checkLocation() -> Int{
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                return 1 // activo, con permisos
            default:
                return -1 // activo, sin permisos
            }
        }
        return 0 // desactivado
    }
    
    func getLatitude() -> NSNumber{
        //return self.checkLocation() == 1 ? NSNumber(value: (self.userLocation?.coordinate.latitude)!) : NSNumber(value: 9.93283107948426)
        return NSNumber(value: 9.93283107948426)
    }
    
    func getLongitude() -> NSNumber{
        //return self.checkLocation() == 1 ? NSNumber(value: (self.userLocation?.coordinate.longitude)!) : NSNumber(value: -84.07657233644923)
        return NSNumber(value: -84.07657233644923)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mapcenter = self.gmaps.region.center;
    }
    
    func startListeningLocation(){
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            startListeningLocation();
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latDelta:CLLocationDegrees = 0.08
            let longDelta:CLLocationDegrees = 0.08
            let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
            let theRegion:MKCoordinateRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude), theSpan)
            self.gmaps.setRegion(theRegion, animated: true)
            userLocation = location
            locationManager.stopUpdatingLocation()
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        self.showModal(sender: view)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        let reuseId = "place"
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            let aSelector : Selector = #selector(MapViewController.showModal(sender:))
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
            tapGesture.numberOfTapsRequired = 2
            anView?.addGestureRecognizer(tapGesture)
            let left = UIImageView(image: UIImage(named: "mapLogo1")!)
            let right = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            left.contentMode = UIViewContentMode.scaleAspectFit
            left.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            left.isUserInteractionEnabled = true
            right.isUserInteractionEnabled = true
            right.setImage(UIImage(named: "info"), for: UIControlState())
            right.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            right.tag = 537
            anView?.isUserInteractionEnabled = true
            anView?.image = UIImage(named:"CoopeAndeMarker")
            anView?.canShowCallout = true
            anView?.leftCalloutAccessoryView = left
            anView?.rightCalloutAccessoryView = right
        }
        else {
            anView?.annotation = annotation
        }
        return anView
    }
    
    @IBAction func showModal(sender: AnyObject) {
        var target: AnyObject = sender
        if let gesture = sender  as? UITapGestureRecognizer {
            target = gesture.view!
        }
        if let view = target as? MKAnnotationView {
            self.gmaps.deselectAnnotation(view.annotation, animated: true)
            if let anotation = view.annotation as? PlaceMarker {
                self.getDetails(place: anotation.place)
            }
        }
    }
    
    func getDetails(place: Place){
        self.showBusyIndicator("Loading Data")
        let request = PlaceDetailRequest()
        request.placeId = place.placeId;
        request.latitude = NSNumber(value: place.latitude.floatValue)
        request.longitude = NSNumber(value: place.longitude.floatValue)
        request.categoryPlaceId = self.selectedCategory.categoryPlaceId
        request.subCategoryPlaceId = self.selectedSubCategory
        request.currentLongitude = NSString(string: self.getLongitude().description)
        request.currentLatitude = NSString(string: self.getLatitude().description)
        request.typeId = place.placeId
        ProxyManager.GetPlaceDetail(request ,success:{
        (result) in
            OperationQueue.main.addOperation({
                if result.isSuccess{
                    let vc = self.storyboard!.instantiateViewController(withIdentifier: "PlaceDetailViewController") as! PlaceDetailViewController
                    vc.detail = result.data
                    vc.placeSelected = place
                    vc.categorySelected = self.selectedCategory
                    vc.latitudeUser = self.getLatitude()
                    vc.longitudeUser = self.getLongitude()
                    vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                    self.hideBusyIndicator()
                    self.present(vc, animated: true, completion: nil)
                }
                else{
                    self.hideBusyIndicator()
                    self.showAlert("Error Title", messageKey: result.message as String)
                }
            })
        },
        failure: { (error) -> Void in
            DispatchQueue.main.async {
                self.hideBusyIndicator()
                self.showAlert("Login Exception Title", messageKey: error.userInfo["message"] as! String)
            }
        })
    }
    
    fileprivate func loadMarkers() -> Bool{
        self.showBusyIndicator("Loading Data")
        let request: PlacesRequest = PlacesRequest()
        request.categoryPlaceId = self.selectedCategory.categoryPlaceId
        request.subCategoryPlaceId = self.selectedSubCategory
        if ((request.categoryPlaceId.length > 0) && (self.mapcenter != nil)){
            request.latitude = self.getLatitude()
            request.longitude = self.getLongitude()
            ProxyManager.GetPlaces(request, success: {
                (result) in
                OperationQueue.main.addOperation({() -> Void in
                    self.gmaps.removeAnnotations( self.gmaps.annotations)
                })
                OperationQueue.main.addOperation({
                    if result.isSuccess{
                        self.hideBusyIndicator()
                        for place in result.data!.list{
                            let marker: PlaceMarker = PlaceMarker(place: place as! Place)
                            self.gmaps.addAnnotation(marker)
                        }
                    }
                    else{
                        self.hideBusyIndicator()
                        self.showAlert("Error Title", messageKey: result.message as String)
                    }
                })
            },
               failure: { (error) -> Void in
                DispatchQueue.main.async {
                    self.hideBusyIndicator()
                    self.showAlert("Login Exception Title", messageKey: error.userInfo["message"] as! String)
                }
            })
            return true
        }
        else{
            self.hideBusyIndicator()
            self.showAlert("Login Exception Title", messageKey: "Generic Error Message")
            return false
        }
    }
    
    fileprivate func loadPlacesCategories(){
        self.showBusyIndicator("")
        ProxyManager.PlacesCategory({(result) in
            DispatchQueue.main.async {
                if result.isSuccess{
                    self.hideBusyIndicator()
                    for items2 in ProxyManagerData.categoriesWithChildren.reversed(){
                        for items3 in items2.subCategories.reversed() {
                            self.floaty.addItem(title: items3.categoryName as String , handler: { item in
                                self.selectedSubCategory = items3.subId
                                self.selectedCategory = items2
                                self.title = self.selectedCategory.categoryName as String
                            })
                        }
                        self.floaty.addItem(title: items2.categoryName as String , handler: { item in
                        }).titleColor = UIColor(red:0.96, green:0.74, blue:0.00, alpha:1.0)
                    }
                    for items in ProxyManagerData.categories.reversed() {
                        self.floaty.addItem(title: items.categoryName as String , handler: { item in
                            self.selectedCategory = items
                            self.title = self.selectedCategory.categoryName as String
                        }).titleColor = UIColor(red:0.96, green:0.74, blue:0.00, alpha:1.0)
                    }
                    let index = ProxyManagerData.categories.index(where: {
                        let place: PlaceCategory = $0
                        return place.categoryPlaceId == "SUC"
                    })
                    let indexPath = IndexPath(row: index!, section: 0)
                    let item = self.getItem(indexPath)
                    self.selectedCategory = item
                    self.title = self.selectedCategory.categoryName as String
                }
                else{
                    self.hideBusyIndicator()
                    self.showAlert("Error Title", messageKey: result.message as String)
                }
            }
        },
        failure: { (error) -> Void in
            DispatchQueue.main.async {
                self.hideBusyIndicator()
                self.showAlert("Login Exception Title", messageKey: error.userInfo["message"] as! String)
            }
        })
    }
    
    func getItem(_ indexPath: IndexPath) -> PlaceCategory{
        var item: PlaceCategory = PlaceCategory()
        if((indexPath as NSIndexPath).section == 0){
            item = ProxyManagerData.categories[(indexPath as NSIndexPath).row]
        }
        else{
            item = ProxyManagerData.categoriesWithChildren[(indexPath as NSIndexPath).section-1].subCategories[(indexPath as NSIndexPath).row]
        }
        return item
    }
    
}
    /* func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
     self.mapcenter = gmaps.region.center
     }*/
    
    /*func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
     // 2
     guard let annotation = annotation as? PlaceMarker else { return nil }
     // 3
     let identifier = "place"
     var view: MKMarkerAnnotationView
     // 4
     if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
     as? MKMarkerAnnotationView {
     dequeuedView.annotation = annotation
     view = dequeuedView
     } else {
     // 5
     view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
     view.canShowCallout = true
     //view.calloutOffset = CGPoint(x: -5, y: 5)
     //view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
     let aSelector : Selector = #selector(MapViewController.showModal(_:))
     let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
     tapGesture.numberOfTapsRequired = 2
     view.addGestureRecognizer(tapGesture)
     let left = UIImageView(image: UIImage(named: "mapLogo1")!)
     let right = UIButton(frame:   CGRect(x: 0, y: 0, width: 40, height: 38))
     
     //left.backgroundColor = Style.mainColor3
     left.contentMode = UIViewContentMode.scaleAspectFit
     left.frame =  CGRect(x: 0, y: 0, width: 50, height: 38)
     right.setImage( UIImage(named: "info"), for: UIControlState())
     right.imageView?.contentMode = UIViewContentMode.scaleAspectFit
     right.tag = 537
     view.image = UIImage(named:"IconoUbicacion")
     view.canShowCallout = true
     view.leftCalloutAccessoryView = left
     view.rightCalloutAccessoryView = right
     
     }
     return view
     }*/
    
    
    /*
     @IBAction func showModal1(_ sender: AnyObject) {
     var target : AnyObject = sender
     //self.animateTable(true)
     if let gesture = sender  as? UITapGestureRecognizer
     {
     target = gesture.view!
     }
     if let view = target as? MKAnnotationView
     {
     self.gmaps.deselectAnnotation(view.annotation, animated: true)
     if let anotation = view.annotation as? PlaceMarker
     {
     //self.showBusyIndicator("Loading Data")
     BaseMapModal.getInfoView(self.selectedCategory,place: anotation.place,  userLocation: userLocation, success:
     { (result, modalView) -> Void in
     
     if(result.isSuccess)
     {
     DispatchQueue.main.async {
     //self.hideBusyIndicator()
     //self.popUpController.openPopUpView()
     // self.present(modalView!, animated: true, completion: nil)
     let alertViewResponder: SCLAlertViewResponder = SCLAlertView().showSuccess("Hello World", subTitle: "This is a more descriptive text.")
     
     //print("Titulo: ", (modalView?.placeDetail?.address as String?)!)
     // Upon displaying, change/close view
     alertViewResponder.setTitle((modalView?.placeDetail?.name as String?)!) // Rename title
     alertViewResponder.setSubTitle("Dirección: \n \((modalView?.placeDetail?.address as String?)!) \n\n\n Horario: \n \((modalView?.placeDetail?.scheduleAttention as String?)!) \n\n\n Teléfono: \n \((modalView?.placeDetail?.phone as String?)!)") // Rename subtitle
     //alertViewResponder.close() // Close view
     }
     }
     else
     {
     //self.hideBusyIndicator()
     self.showAlert("Error Title", messageKey: result.message as String)
     }
     }
     , failure: { (error) -> Void in
     //self.hideBusyIndicator()
     self.showAlert("Error Title", messageKey: "Timeout Generic Exception Message")
     })
     
     }
     }
     
     // let alertViewResponder: SCLAlertViewResponder = SCLAlertView().showSuccess("Hello World", subTitle: "This is a more descriptive text.")
     
     // Upon displaying, change/close view
     //alertViewResponder.setTitle("New Title") // Rename title
     //alertViewResponder.setSubTitle("New description") // Rename subtitle
     //alertViewResponder.close() // Close view
     
     }*/
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
