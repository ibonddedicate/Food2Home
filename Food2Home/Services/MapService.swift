//
//  MapService.swift
//  Food2Home
//
//  Created by Surote Gaide on 18/7/20.
//  Copyright © 2020 Surote Gaide. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation

class MapService {
    
    static var routes:[JSON]?
    static var duration = ""
    var lat: CLLocationDegrees = 0
    var lon: CLLocationDegrees = 0
    var rlat: CLLocationDegrees = 0
    var rlon: CLLocationDegrees = 0
    var destination = ""
    var rdestination = ""
    
    
    func requestPath(userLoc:CLLocationCoordinate2D, restLoc: CLLocationCoordinate2D, completion: @escaping (()->Void)) {
        lat = userLoc.latitude
        lon = userLoc.longitude
        rlat = restLoc.latitude
        rlon = restLoc.longitude
        destination = "\(lat),\(lon)"
        rdestination = "\(rlat),\(rlon)"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(rdestination)&destination=\(destination)&mode=driving&key=AIzaSyCNnCzLG-sPmWdz-gGQDBjyZl7MPpQ7WmI"
        AF.request(url).responseJSON { response in
            guard let data = response.data else {
                return
            }
            do {
                let json = try JSON(data: data)
                MapService.routes = json["routes"].arrayValue
                //print(MapService.routes!)
                completion()
                
            } catch let error{
                print(error)
            }
        }
    }
    
    func requestDuration(userLoc:CLLocationCoordinate2D, restLoc: CLLocationCoordinate2D, completion: @escaping (()->Void)) {
        lat = userLoc.latitude
        lon = userLoc.longitude
        rlat = restLoc.latitude
        rlon = restLoc.longitude
        destination = "\(lat),\(lon)"
        rdestination = "\(rlat),\(rlon)"
        let url = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(rdestination)&destinations=\(destination)&mode=driving&key=AIzaSyCNnCzLG-sPmWdz-gGQDBjyZl7MPpQ7WmI"
        print(url)
        AF.request(url).responseJSON { response in
            guard let data = response.data else {
                return
            }
            do {
                let json = try JSON(data:data)
                if let result = json["rows"][0]["elements"][0]["duration"]["text"].string {
                    print(result)
                    MapService.duration = result
                    completion()
                }
            } catch let error {
                print(error)
            }
        }
    }
}

