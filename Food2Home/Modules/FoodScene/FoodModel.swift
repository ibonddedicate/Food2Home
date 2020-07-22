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

    
    let foodSet:[FoodModels] = [
        FoodModels(food: "Italian Meal", price: 489, image: UIImage(named: "ItalianMeal")!,loc: CLLocationCoordinate2D(latitude: 13.739576, longitude: 100.565218)),
        FoodModels(food: "Japanese Meal", price: 689, image: UIImage(named: "JapaneseMeal")!, loc: CLLocationCoordinate2D(latitude: 13.651521, longitude: 100.486233)),
        FoodModels(food: "German Meal", price: 369, image: UIImage(named: "GermanMeal")!, loc: CLLocationCoordinate2D(latitude: 13.733536, longitude: 100.564188)),
        FoodModels(food: "Thai Meal", price: 79, image: UIImage(named: "ThaiMeal")!, loc: CLLocationCoordinate2D(latitude: 13.68512500, longitude: 100.61102060)),
        FoodModels(food: "Indian Meal", price: 129, image: UIImage(named: "IndianMeal")!,loc: CLLocationCoordinate2D(latitude: 13.717845, longitude: 100.507724)),
        FoodModels(food: "Vietnamese Meal", price: 259, image: UIImage(named: "VietnameseMeal")!, loc: CLLocationCoordinate2D(latitude: 13.700337, longitude: 100.499522)),
        FoodModels(food: "Hungarian Meal", price: 329, image: UIImage(named: "HungarianMeal")!, loc: CLLocationCoordinate2D(latitude: 13.730608, longitude: 100.579898)),
        FoodModels(food: "Swedish Meal", price: 479, image: UIImage(named: "SwedishMeal")!, loc: CLLocationCoordinate2D(latitude: 13.651048, longitude: 100.680105))
    ]
}
