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

class MapViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    
    let floaty = Floaty()
    
    //let regionRadius: CLLocationDistance = 2000
    let popUpController = mapPopUpViewController()
    
    @IBOutlet weak var contentView: UIView!
    var ProxyManager :UtilProxyManager = UtilProxyManager()
    
    var timer : Timer?;
    
    var selectedPlace : Place?
    var selectedCategory: PlaceCategory = PlaceCategory()
    {
        didSet
        {
            if(self.loadMarkers())
            {
                print("selectedCategory invoke")
            }
            else
            {
                print("selectedCategory not invoke")
            }
        }
    }
    var mapcenter : CLLocationCoordinate2D?
    {
        didSet
        {
            //if(self.loadMarkers())
            //{
            //  println("mapcenter invoke")
            //}
            //else
            //{
            //     println("mapcenter not invoke")
            // }
        }
    }
    
    var annotationLoaded : Bool = false
    
    var userLocation : CLLocation?
    let locationManager = CLLocationManager()
    @IBOutlet weak var gmaps: MKMapView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUpController.crateInstanceOfPopUp(senderView: self.view, theViewController: self, sizeOfPopUpViewContainer: Int(self.view.frame.height))
        
        self.title = "Agencias"
        self.loadPlacesCategories()
        //BaseViewController.setNavigation(self.title!,controller: self)
        locationManager.delegate = self
        if Constants.iOS8
        {
            locationManager.requestWhenInUseAuthorization()
        }
        else
        {
            startListeningLocation()
        }
        self.floaty.DeviceVersion = DeviceVersion.modelName as NSString
        self.contentView.addSubview(floaty)
        
        gmaps.delegate = self
        gmaps.isZoomEnabled = true
        gmaps.showsUserLocation = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapcenter = gmaps.region.center;
        
    }
    
    func startListeningLocation()
    {
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            startListeningLocation();
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        /*if let location = locations.first as CLLocation? {
            let theRegion:MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude),regionRadius, regionRadius)
            self.gmaps.setRegion(theRegion, animated: true)
            self.mapcenter = gmaps.region.center
            userLocation = location
            locationManager.stopUpdatingLocation()
        }*/
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
            let right = UIButton(frame:   CGRect(x: 0, y: 0, width: 40, height: 38))
            
            //left.backgroundColor = Style.mainColor3
            left.contentMode = UIViewContentMode.scaleAspectFit
            left.frame =  CGRect(x: 0, y: 0, width: 50, height: 38)
            right.setImage( UIImage(named: "info"), for: UIControlState())
            right.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            right.tag = 537
            
            anView?.image = UIImage(named:"CoopeAndeMarker")
            anView?.canShowCallout = true
            anView?.leftCalloutAccessoryView = left
            anView?.rightCalloutAccessoryView = right
            
        }
        else {
            //we are re-using a view, update its annotation reference...
            anView?.annotation = annotation
        }
        
        return anView
    }
    
    @IBAction func showModal(sender: AnyObject) {
        var target : AnyObject = sender
        if let gesture = sender  as? UITapGestureRecognizer
        {
            target = gesture.view!
        }
        if let view = target as? MKAnnotationView
        {
            self.gmaps.deselectAnnotation(view.annotation, animated: true)
            if let anotation = view.annotation as? PlaceMarker
            {
                //print("User Location latitude: ", userLocation?.coordinate.latitude)
                self.showBusyIndicator("Loading Data")
                BaseMapModal.getInfoView(self.selectedCategory,place: anotation.place,  userLocation: userLocation, success:
                    { (result, modalView) -> Void in
                        DispatchQueue.main.async {
                            if(result.isSuccess){
                                self.hideBusyIndicator()
                                self.present(modalView!, animated: true, completion: nil)
                            }
                            else{
                                self.hideBusyIndicator()
                                self.showAlert("Error Title", messageKey: result.message as String)
                            }
                        }
                    }, failure: { (error) -> Void in
                        self.hideBusyIndicator()
                        self.showAlert("Error Title", messageKey: "Timeout Generic Exception Message")
                })
                
            }
        }
        
    }
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
    
    
    fileprivate func loadMarkers() -> Bool
    {
        let  request: PlacesRequest = PlacesRequest()
        request.categoryPlaceId = self.selectedCategory.categoryPlaceId
        request.subCategoryPlaceId = self.selectedCategory.subId
        //print("Map Center: ",self.mapcenter)
        if ((request.categoryPlaceId.length > 0) && (self.mapcenter != nil))
        {
            request.latitude = NSNumber(value: self.mapcenter!.latitude)
            request.longitude =  NSNumber(value: self.mapcenter!.longitude)
            self.showBusyIndicator("")
            ProxyManager.GetPlaces(request, success: {
                (result) in
                OperationQueue.main.addOperation({() -> Void in
                    self.gmaps.removeAnnotations( self.gmaps.annotations)
                })
                OperationQueue.main.addOperation({
                if result.isSuccess
                {
                    self.hideBusyIndicator()
                    
                        for place  in  result.data!.list
                        {
                            let marker : PlaceMarker = PlaceMarker(place: place as! Place)
                            
                            self.gmaps.addAnnotation(marker)
                            
                        }
                }
                else
                {
                    self.hideBusyIndicator()
                    self.showAlert("Error Title", messageKey: result.message as String)
                }
                })
            },
                                   failure: { (error) -> Void in
                                    self.hideBusyIndicator()
                                    self.showAlert("Error Title", messageKey: "Login Generic Exception Message")
            })
            
            return true
        }
        else
        {
            return false
        }
        
    }
    
    fileprivate func loadPlacesCategories()
    {
        self.showBusyIndicator("")
        ProxyManager.PlacesCategory({
            (result) in
            self.hideBusyIndicator()
            DispatchQueue.main.async {
            if result.isSuccess
            {
                
                    //print(ProxyManagerData.categories.endIndex)
                    //print(DeviceVersion.modelName)
                    for items in ProxyManagerData.categories{
                        //print(items.categoryName)
                        self.floaty.addItem(title: items.categoryName as String , handler: { item in
                            
                            
                            self.selectedCategory =  items
                            self.title = self.selectedCategory.categoryName as String
                            //fab.close()
                        }).titleColor = UIColor(red:0.96, green:0.74, blue:0.00, alpha:1.0)
                    }
                    for items2 in ProxyManagerData.categoriesWithChildren{
                        //print(items2.categoryName)
                        self.floaty.addItem(title: items2.categoryName as String , handler: { item in
                            let alert = UIAlertController(title: "Accion", message: "Carga la categoría: "+(items2.categoryName as String), preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            //fab.close()
                        }).titleColor = UIColor(red:0.96, green:0.74, blue:0.00, alpha:1.0)
                        
                        for items3 in items2.subCategories{
                            //print(items3.categoryName)
                            self.floaty.addItem(title: items3.categoryName as String , handler: { item in
                                let alert = UIAlertController(title: "Accion", message: "Carga la Subcategoría: "+(items3.categoryName as String), preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                //fab.close()
                            })
                        }
                    }

                    //var section
                    let index =  ProxyManagerData.categories.index( where: {
                        let place : PlaceCategory = $0
                        return place.categoryPlaceId == "SUC"
                    } )
                    let indexPath = IndexPath(row: index!, section: 0)
                    //print("IndexPath",indexPath)
                    let item = self.getItem(indexPath)
                    self.selectedCategory = item
                    self.title = self.selectedCategory.categoryName as String
            }
            else
            {
                self.showAlert("Error Title", messageKey: result.message as String)
            }
            }
        },
                                    failure: { (error) -> Void in
                                        self.hideBusyIndicator()
                                        self.showAlert("Error Title", messageKey: "Timeout Generic Exception Message")
        })
        
    }
    
    func getItem(_ indexPath: IndexPath) -> PlaceCategory
    {
        var item : PlaceCategory = PlaceCategory()
        if((indexPath as NSIndexPath).section == 0)
        {
            item = ProxyManagerData.categories[(indexPath as NSIndexPath).row]
        }
        else
        {
            item = ProxyManagerData.categoriesWithChildren[(indexPath as NSIndexPath).section-1].subCategories[(indexPath as NSIndexPath).row]
        }
        return item
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
