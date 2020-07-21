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
import SwiftyJSON

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
    var cord2DRestaurant = CLLocationCoordinate2D(latitude: 13.685125, longitude: 100.611021)
    var cordRestaurant = CLLocation(latitude: 13.685125, longitude: 100.611021)
    var interactor : DeliveryInteractor?
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    var pickedFood = FoodModel.init().foodSet[0]
    var distanceCost:String?
    let mapService = MapService()
    let marker = GMSMarker()
    var ableToOrder = false

    
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
        mapView.camera = GMSCameraPosition.camera(withTarget: cord2DRestaurant, zoom: 15)

    }
    @IBAction func searchTapped(_ sender: Any) {
        gotoPlace()
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
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(String(describing: place.name))")
        dismiss(animated: true, completion: nil)
        
        self.mapView.clear()
        self.locationBox.text = place.name
        
        let cord2D = CLLocationCoordinate2D(latitude: (place.coordinate.latitude), longitude: (place.coordinate.longitude))
        let cordUser = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        let distance = cordUser.distance(from: cordRestaurant)
        mapService.requestPath(userLoc: cord2D, restLoc: cord2DRestaurant){
            let routes = MapService.routes
            if routes != nil {
                for route in routes! {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeColor = UIColor.systemBlue
                    polyline.strokeWidth = 5
                    polyline.map = self.mapView
                }
            }
        }
        interactor?.calculateDeliveryCost(dist: Float(distance))
        

        createMarker(titleMarker: place.name!, loc: cord2D)
        createRestaurantMarker(loc: cord2DRestaurant)
//
        
        self.mapView.camera = GMSCameraPosition.camera(withTarget: cord2D, zoom: 15)
    }
    
    //MARK: Marker methods
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print("Position of marker is = \(marker.position.latitude),\(marker.position.longitude)")
        self.mapView.clear()
        mapService.requestPath(userLoc: marker.position, restLoc: cord2DRestaurant) {
            let routes = MapService.routes
             if routes != nil {
                 for route in routes! {
                     let routeOverviewPolyline = route["overview_polyline"].dictionary
                     let points = routeOverviewPolyline?["points"]?.stringValue
                     let path = GMSPath.init(fromEncodedPath: points!)
                     let polyline = GMSPolyline.init(path: path)
                     polyline.strokeColor = UIColor.systemBlue
                     polyline.strokeWidth = 5
                     polyline.map = self.mapView
                 }
             }
        }
        let cordUser = CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude)
        let distance = cordUser.distance(from: cordRestaurant)
        interactor?.calculateDeliveryCost(dist: Float(distance))
        reverseGeocoding(marker: marker)
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

extension DeliveryViewController : DeliveryPresenterOutput {
    
    func updateDeliveryCost(cost: Double) {
        distanceCost = String(cost.rounded(.up))
        DispatchQueue.main.async {
            self.confirmOrder.backgroundColor = UIColor.systemRed
            if cost <= 15.00 {
                self.deliveryCost.text = "FREE DELIVERY"
                self.deliveryCost.textColor = UIColor.systemGreen
                self.ableToOrder = true
                self.confirmOrder.setTitle("ConfirmOrder (Total: \(self.pickedFood.foodPrice) THB)", for: .normal)
            } else if cost >= 1000.00{
                self.deliveryCost.text = "NO DELIVERY SERVICE"
                self.deliveryCost.textColor = UIColor.red
                self.ableToOrder = false
                self.confirmOrder.backgroundColor = UIColor.lightGray
                self.confirmOrder.setTitle("Delivery Not Available", for: .normal)
            } else {
                self.deliveryCost.text = "Delivery : \(self.distanceCost!) THB"
                self.deliveryCost.textColor = UIColor.lightGray
                self.ableToOrder = true
                let distanceCostnonOp = Double(self.distanceCost!)!
                let total = distanceCostnonOp + Double(self.pickedFood.foodPrice)
                self.confirmOrder.setTitle("ConfirmOrder (Total: \(total.rounded()) THB)", for: .normal)
            }
        }
        
    }
}

// Delegates to handle events for the location manager.
extension DeliveryViewController: CLLocationManagerDelegate {

  // Handle incoming location events.
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location: CLLocation = locations.last!
    print("Location: \(location)")

    //let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
     //                                     longitude: location.coordinate.longitude,
     //                                     zoom: zoomLevel)
    //mapView.camera = camera
  }

  // Handle authorization for the location manager.
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .restricted:
      print("Location access was restricted.")
    case .denied:
      print("User denied access to location.")
      // Display the map using the default location.
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

