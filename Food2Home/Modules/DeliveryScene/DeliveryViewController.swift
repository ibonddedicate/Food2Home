//
//  DeliveryViewController.swift
//  Food2Home
//
//  Created by Surote Gaide on 19/7/20.
//  Copyright © 2020 Surote Gaide. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

protocol DeliveryPresenterOutput: class {
    func updateDeliveryCost(cost:Double)
}

class DeliveryViewController: UIViewController {
    
    @IBOutlet weak var confirmOrder: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var pickedMenu: UILabel!
    @IBOutlet weak var pickedMenuPrice: UILabel!
    @IBOutlet weak var deliveryCost: UILabel!
    @IBOutlet weak var locationBox: UITextField!
    @IBOutlet weak var totalPrice: UILabel!
    var cord2DRestaurant = CLLocationCoordinate2D(latitude: 13.685125, longitude: 100.611021)
    var cordRestaurant = CLLocation(latitude: 13.685125, longitude: 100.611021)
    var cord2DUser = CLLocationCoordinate2D(latitude: 13.685125, longitude: 100.611021)
    var interactor : DeliveryInteractor?
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    var pickedFood = FoodModel.init().foodSet[0]
    var distanceCost:String?
    let mapService = MapService()
    let orderService = OrderService()
    let marker = GMSMarker()
    var ableToOrder = false
    var path = GMSPath()
    var locationDistance: Float?
    var total:Double?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setup()
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        pickedMenu.text = pickedFood.foodName
        pickedMenuPrice.text = "\(String(pickedFood.foodPrice)) THB"
        placesClient = GMSPlacesClient.shared()
        setRestaurantLocation()
        createRestaurantMarker(loc: cord2DRestaurant)
        mapView.camera = GMSCameraPosition.camera(withTarget: cord2DRestaurant, zoom: 14)
        confirmOrder.isEnabled = false
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        totalPrice.text = "\(pickedFood.foodPrice) THB"
        confirmOrder.layer.cornerRadius = 10

    }
    @IBAction func searchTapped(_ sender: Any) {
        gotoPlace()
    }
    
    @IBAction func confirmTapped(_ sender: Any) {
        confirmPressed()
    }
    
    private func setup() {
        let viewController = self
        let interactor = DeliveryInteractorImplementation()
        let presenter = DeliveryPresenterImplementation()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }

}
//MARK: GMS Marker
extension DeliveryViewController : GMSAutocompleteViewControllerDelegate, GMSMapViewDelegate {
    func createMarker(titleMarker: String, loc: CLLocationCoordinate2D) {
        let marker = GMSMarker()
        marker.position = loc
        marker.isDraggable = true
        marker.title = titleMarker
        marker.map = mapView
    }
    
    func createRestaurantMarker(loc: CLLocationCoordinate2D) {
        let resMarker = GMSMarker()
        resMarker.position = cord2DRestaurant
        resMarker.title = "\(pickedFood.foodName) Restaurant"
        resMarker.snippet = "by Food2Home"
        resMarker.icon = UIImage(named: "location.png")
        resMarker.map = self.mapView
    }
    
    func setRestaurantLocation() {
        cord2DRestaurant = pickedFood.foodLocation
        cordRestaurant = CLLocation(latitude: pickedFood.foodLocation.latitude, longitude: pickedFood.foodLocation.longitude)
    }
    //MARK: GMSAuto Complete
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(String(describing: place.name))")
        dismiss(animated: true, completion: nil)
        
        self.mapView.clear()
        self.locationBox.text = place.name
        
        cord2DUser = CLLocationCoordinate2D(latitude: (place.coordinate.latitude), longitude: (place.coordinate.longitude))
        let cordUser = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        let bounds = GMSCoordinateBounds(coordinate: cord2DUser, coordinate: cord2DRestaurant)
        let camera: GMSCameraUpdate = GMSCameraUpdate.fit(bounds, withPadding: 70.0)
        self.mapView.animate(with: camera)
        let distance = cordUser.distance(from: cordRestaurant)
        mapService.requestPath(userLoc: cord2DUser, restLoc: cord2DRestaurant){
            let routes = MapService.routes
            if routes != nil {
                for route in routes! {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    self.path = GMSPath.init(fromEncodedPath: points!)!
                    let polyline = GMSPolyline.init(path: self.path)
                    polyline.strokeColor = UIColor.systemBlue
                    polyline.strokeWidth = 5
                    polyline.map = self.mapView
                }
            }
        }
        interactor?.calculateDeliveryCost(dist: Float(distance))
        locationDistance = Float(distance)

        createMarker(titleMarker: place.name!, loc: cord2DUser)
        createRestaurantMarker(loc: cord2DRestaurant)
//
    }
    
    //MARK: GMS Marker Drag
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print("Position of marker is = \(marker.position.latitude),\(marker.position.longitude)")
        self.mapView.clear()
        cord2DUser = CLLocationCoordinate2D(latitude: marker.position.latitude, longitude: marker.position.longitude)
        let bounds = GMSCoordinateBounds(coordinate: cord2DUser, coordinate: cord2DRestaurant)
        let camera: GMSCameraUpdate = GMSCameraUpdate.fit(bounds, withPadding: 70.0)
        self.mapView.animate(with: camera)
        mapService.requestPath(userLoc: marker.position, restLoc: cord2DRestaurant) {
            let routes = MapService.routes
             if routes != nil {
                 for route in routes! {
                     let routeOverviewPolyline = route["overview_polyline"].dictionary
                     let points = routeOverviewPolyline?["points"]?.stringValue
                     self.path = GMSPath.init(fromEncodedPath: points!)!
                     let polyline = GMSPolyline.init(path: self.path)
                     polyline.strokeColor = UIColor.systemBlue
                     polyline.strokeWidth = 5
                     polyline.map = self.mapView
                 }
             }
        }
        let cordUser = CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude)
        let distance = cordUser.distance(from: cordRestaurant)
        interactor?.calculateDeliveryCost(dist: Float(distance))
        locationDistance = Float(distance)
        reverseGeocoding(marker: marker)
        marker.title = "Picked Location"
        createRestaurantMarker(loc: cord2DRestaurant)
        
    }
    //MARK: Reverse GeoCoding
    
    func reverseGeocoding(marker: GMSMarker) {
        let geocoder = GMSGeocoder()
        let coordinate = CLLocationCoordinate2DMake(Double(marker.position.latitude),Double(marker.position.longitude))
        
        var currentAddress = String()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                
                currentAddress = lines.joined(separator: "\n")
                
            }
            self.locationBox.text = currentAddress
            marker.map = self.mapView
        }
    }
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true)
    }
    
    func gotoPlace() {
        locationBox.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
}
//MARK: Presenter Output & Button
extension DeliveryViewController : DeliveryPresenterOutput {
    
    func updateDeliveryCost(cost: Double) {
        distanceCost = String(cost.rounded(.up))
        confirmOrder.setTitle("Confirm Order", for: .normal)
        self.deliveryCost.textColor = UIColor.black
        DispatchQueue.main.async {
            self.confirmOrder.backgroundColor = Utilities().f2hRed
            if cost <= 15.00 {
                self.deliveryCost.text = "FREE"
                self.deliveryCost.textColor = UIColor.systemGreen
                self.ableToOrder = true
                self.confirmOrder.isEnabled = true
                self.totalPrice.text = "\(self.pickedFood.foodPrice) THB"
            } else if cost >= 600.00{
                self.deliveryCost.text = "N/A"
                self.deliveryCost.textColor = UIColor.red
                self.ableToOrder = false
                self.confirmOrder.isEnabled = false
                self.confirmOrder.backgroundColor = UIColor.lightGray
                self.confirmOrder.setTitle("Delivery Not Available", for: .normal)
            } else {
                self.deliveryCost.text = "\(self.distanceCost!) THB"
                self.ableToOrder = true
                self.confirmOrder.isEnabled = true
                let distanceCostnonOp = Double(self.distanceCost!)!
                self.total = distanceCostnonOp + Double(self.pickedFood.foodPrice)
                self.totalPrice.text = "\(self.total!.rounded()) THB"
            }
        }
        
    }
    func confirmPressed() {
        performSegue(withIdentifier: "toOrdered", sender: self)
        orderService.postOrder(menu: pickedFood, totalPrice: total!, deliver: cord2DUser)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toOrdered" {
            if segue.destination is OrderedViewController {
                let vc = segue.destination as? OrderedViewController
                vc?.locationDistance = locationDistance
            }
        }
    }
}

//MARK: CoreLocation Manager
extension DeliveryViewController: CLLocationManagerDelegate {

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location: CLLocation = locations.last!
    print("Location: \(location)")
    let myLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    createMarker(titleMarker: "My location", loc: myLocation)
    locationManager.stopUpdatingLocation()
  }

  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .restricted:
      print("Location access was restricted.")
    case .denied:
      print("User denied access to location.")
    case .notDetermined:
      print("Location status not determined.")
    case .authorizedAlways: fallthrough
    case .authorizedWhenInUse:
      print("Location status is OK.")
    @unknown default:
      fatalError()
    }
  }

  // Handle location manager errors.
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    locationManager.stopUpdatingLocation()
    print("Error: \(error)")
  }
}
