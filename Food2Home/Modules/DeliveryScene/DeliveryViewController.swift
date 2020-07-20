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
    
    @IBOutlet weak var mapFrame: GMSMapView!
    @IBOutlet weak var pickedMenu: UILabel!
    @IBOutlet weak var pickedMenuPrice: UILabel!
    @IBOutlet weak var deliveryCost: UILabel!
    @IBOutlet weak var locationBox: UITextField!
    var interactor : DeliveryInteractor?
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    var pickedFood = FoodModel.init().foodSet[0]
    var distanceCost:String?
    let mapService = MapService()

    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []

    // The currently selected place.
    var selectedPlace: GMSPlace?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
        mapFrame.settings.myLocationButton = true
        mapFrame.isMyLocationEnabled = true


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

extension DeliveryViewController : GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(String(describing: place.name))")
        dismiss(animated: true, completion: nil)
        
        self.mapFrame.clear()
        self.locationBox.text = place.name
        
        let cord2D = CLLocationCoordinate2D(latitude: (place.coordinate.latitude), longitude: (place.coordinate.longitude))
        let cord2DRestaurant = CLLocationCoordinate2D(latitude: 13.685125, longitude: 100.611021)
        let cordRestaurant = CLLocation(latitude: 13.685125, longitude: 100.611021)
        let cordUser = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        let distance = cordUser.distance(from: cordRestaurant)
        mapService.requestPath(userLoc: cord2D){
            let routes = MapService.routes
            print(MapService.routes!)
            if routes != nil {
                for route in routes! {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeColor = UIColor.systemBlue
                    polyline.strokeWidth = 4
                    polyline.map = self.mapFrame
                }
            }
        }
        interactor?.calculateDeliveryCost(dist: Float(distance))
        

        
        let cusMarker = GMSMarker()
        cusMarker.position =  cord2D
        cusMarker.title = place.name
        cusMarker.snippet = "Food Pickup Location"
        cusMarker.map = self.mapFrame
        
        let resMarker = GMSMarker()
        resMarker.position = cord2DRestaurant
        resMarker.title = "True Digital Park"
        resMarker.snippet = "Food2Home Restaurant"
        resMarker.icon = UIImage(named: "location.png")
        resMarker.map = self.mapFrame
        
        self.mapFrame.camera = GMSCameraPosition.camera(withTarget: cord2D, zoom: 15)
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
            if cost <= 15.00 {
                self.deliveryCost.text = "FREE DELIVERY"
                self.deliveryCost.textColor = UIColor.systemGreen
            } else if cost >= 1000.00{
                self.deliveryCost.text = "NO DELIVERY SERVICE"
                self.deliveryCost.textColor = UIColor.red
            } else {
                self.deliveryCost.text = "+\(self.distanceCost!) THB"
                self.deliveryCost.textColor = UIColor.systemGreen
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

    let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                          longitude: location.coordinate.longitude,
                                          zoom: zoomLevel)

    if mapFrame.isHidden {
      mapFrame.isHidden = false
      mapFrame.camera = camera
    } else {
      mapFrame.animate(to: camera)
    }
  }

  // Handle authorization for the location manager.
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .restricted:
      print("Location access was restricted.")
    case .denied:
      print("User denied access to location.")
      // Display the map using the default location.
      mapFrame.isHidden = false
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

