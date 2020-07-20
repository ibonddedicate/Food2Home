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
    func requestPath(userLoc:CLLocationCoordinate2D, completion: @escaping (()->Void)) {
        let lat = userLoc.latitude
        let lon = userLoc.longitude
        let destination = "\(lat),\(lon)"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=13.685125,100.611021&destination=\(destination)&mode=driving&key=AIzaSyCNnCzLG-sPmWdz-gGQDBjyZl7MPpQ7WmI"
        print(url)
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
    
}
