//
//  Models.swift
//  Food2Home
//
//  Created by Surote Gaide on 18/7/20.
//  Copyright © 2020 Surote Gaide. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

//MARK: Food Related Model

class FoodModels {
    var foodName: String
    var foodPrice: Float
    var foodImage: UIImage
    var foodLocation: CLLocationCoordinate2D
    
    init(food: String, price: Float, image: UIImage, loc: CLLocationCoordinate2D) {
        foodName = food
        foodPrice = price
        foodImage = image
        foodLocation = loc
    }
}
