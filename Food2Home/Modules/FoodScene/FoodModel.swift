//
//  FoodModels.swift
//  Food2Home
//
//  Created by Surote Gaide on 18/7/20.
//  Copyright © 2020 Surote Gaide. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

//MARK: Dummy

class FoodModel {

    let italianRestaurant = CLLocationCoordinate2D(latitude: 13.68512500, longitude: 100.61102060)
    let germanRestaurant = CLLocationCoordinate2D(latitude: 13.68512500, longitude: 100.61102060)
    let japaneseRestaurant = CLLocationCoordinate2D(latitude: 13.68512500, longitude: 100.61102060)
    
    let foodSet:[FoodModels] = [
        FoodModels(food: "Italian Meal", price: 489, image: UIImage(named: "ItalianMeal")!,loc: CLLocationCoordinate2D(latitude: 13.739576, longitude: 100.565218)),
        FoodModels(food: "Japanese Meal", price: 689, image: UIImage(named: "JapaneseMeal")!, loc: CLLocationCoordinate2D(latitude: 13.651521, longitude: 100.486233)),
        FoodModels(food: "German Meal", price: 369, image: UIImage(named: "GermanMeal")!, loc: CLLocationCoordinate2D(latitude: 13.733536, longitude: 100.564188)),
        FoodModels(food: "Thai Meal", price: 79, image: UIImage(named: "ThaiMeal")!, loc: CLLocationCoordinate2D(latitude: 13.68512500, longitude: 100.61102060))
    ]
}
