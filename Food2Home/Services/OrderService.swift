//
//  OrderService.swift
//  Food2Home
//
//  Created by Surote Gaide on 22/7/20.
//  Copyright © 2020 Surote Gaide. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

class OrderService {
    
    
    func postOrder(menu:FoodModels,totalPrice:Double, deliver:CLLocationCoordinate2D) {
        
        let orderObject: [String:Any] = [
            "food": menu.foodName,
            "price": totalPrice,
            "deliveryLocation": [
                "latitude": deliver.latitude,
                "longitude": deliver.longitude
            ],
        ]
        
        AF.request("https://jsonplaceholder.typicode.com/posts", method: .post, parameters: orderObject, encoding: JSONEncoding.default).responseJSON { (response) in
            print(response)
        }
        
//        let url = "https://jsonplaceholder.typicode.com/posts"
//        var request = URLRequest(url: URL(string: url)!)
//        request.httpMethod = HTTPMethod.post.rawValue
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let json = orderObject
//        let data = (json.data(using: .utf8))! as Data
//
//        request.httpBody = data
//
//        AF.request(request).responseJSON { (response) in
//
//            print(response)
//
//        }
    }
}
