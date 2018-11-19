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

class MapViewController: BaseViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var gmaps: MKMapView!
    @IBOutlet weak var btnPlaces: UIButton!
    @IBOutlet weak var viewPlaces: UIView!
    @IBOutlet weak var viewPlacesHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var timer: Timer?
    var selectedPlace: Place?
    var selectedSubCategory: NSString = ""
    var selectedCategory: PlaceCategory = PlaceCategory() { didSet{ _ = self.loadMarkers() } }
    //var mapcenter: CLLocationCoordinate2D?
    var annotationLoaded: Bool = false
    var userLocation: CLLocation?
    let locationManager = CLLocationManager()
    var showPlaces: Bool = false
    var arrayPlaceItem: Array<PlaceItemList> = []
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Agencias"
        self.viewPlaces.layer.opacity = 0
        self.tableViewHeight.constant = ((Constants.iPhone) ? UIScreen.main.bounds.width : 500) - 150
        self.tableView.layoutIfNeeded()
        self.addMask()
        self.viewPlacesHeight.constant = 0
        self.viewPlaces.layoutIfNeeded()
        self.backAction()
        self.loadPlacesCategories()
        self.locationManager.delegate = self
        self.btnPlaces.layer.cornerRadius = 27.5
        Constants.iOS8 ? locationManager.requestWhenInUseAuthorization() : startListeningLocation()
        self.gmaps.delegate = self
        self.gmaps.isZoomEnabled = true
        self.gmaps.showsUserLocation = true
    }
    
    func addMask(){
        let width = (Constants.iPhone) ? UIScreen.main.bounds.width : 500
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: CGFloat(width)))
        path.addArc(withCenter: CGPoint(x: CGFloat(width), y: CGFloat(width)), radius: CGFloat(width), startAngle: .pi, endAngle: .pi * 1.5, clockwise: true)
        path.addLine(to: CGPoint(x: CGFloat(width), y: CGFloat(width)))
        path.close()
        let maskLayer = CAShapeLayer()
        maskLayer.frame = CGRect(x: (Constants.iPhone) ? self.viewPlaces.bounds.minX : (UIScreen.main.bounds.width - 500), y: 700 - width, width: self.viewPlaces.bounds.width, height: self.viewPlaces.bounds.height)//self.viewPlaces.bounds
        maskLayer.path = path.cgPath
        self.viewPlaces.layer.mask = maskLayer
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async() {
            self.addMask()
        }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayPlaceItem.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.arrayPlaceItem[indexPath.row]
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        cell.textLabel?.text = item.name
        cell.textLabel?.textAlignment = .right
        cell.textLabel?.textColor = item.colorName
        cell.textLabel?.font = (item.colorName == UIColor.white) ? UIFont.systemFont(ofSize: 14) : UIFont.boldSystemFont(ofSize: 14)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.arrayPlaceItem[indexPath.row]
        if item.category != nil {
            if item.subCategory != "" {
                self.selectedSubCategory = item.subCategory
            }
            self.selectedCategory = item.category
            self.title = item.category.categoryName.description
        }
        self.hideShowPlaces()
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
        return self.checkLocation() == 1 ? NSNumber(value: (self.userLocation?.coordinate.latitude)!) : NSNumber(value: 9.93283107948426)
        //return NSNumber(value: 9.93283107948426) //Emulador
    }
    
    func getLongitude() -> NSNumber{
        return self.checkLocation() == 1 ? NSNumber(value: (self.userLocation?.coordinate.longitude)!) : NSNumber(value: -84.07657233644923)
        //return NSNumber(value: -84.07657233644923) //Emulador
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.mapcenter = self.gmaps.region.center;
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
        if ((request.categoryPlaceId.length > 0)){ //&& (self.mapcenter != nil)){
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
                    for items in ProxyManagerData.categories{
                        self.arrayPlaceItem.append(PlaceItemList(name: items.categoryName.description, colorName: UIColor(red:0.96, green:0.74, blue:0.00, alpha:1.0), category: items))
                    }
                    for items2 in ProxyManagerData.categoriesWithChildren{
                        self.arrayPlaceItem.append(PlaceItemList(name: items2.categoryName.description, colorName: UIColor(red:0.96, green:0.74, blue:0.00, alpha:1.0)))
                        for items3 in items2.subCategories{
                            self.arrayPlaceItem.append(PlaceItemList(name: items3.categoryName.description, colorName: UIColor.white, category: items2, subCategory: items3.subId))
                        }
                    }
                    self.tableView.reloadData()
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
    
    @IBAction func hideShowPlaces(_ sender: UIButton) {
       self.hideShowPlaces()
    }
    
    func hideShowPlaces(){
        self.showPlaces = !self.showPlaces
        if self.showPlaces {
            self.viewPlacesHeight.constant = 700
            UIView.animate(withDuration: 0.25) {
                self.btnPlaces.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 4.0)
                self.viewPlaces.layer.opacity = 1
                self.viewPlaces.layoutIfNeeded()
            }
        }
        else{
            self.viewPlacesHeight.constant = 0
            UIView.animate(withDuration: 0.25) {
                self.btnPlaces.transform = CGAffineTransform.identity
                self.viewPlaces.layer.opacity = 0
                self.viewPlaces.layoutIfNeeded()
            }
        }
    }
}
