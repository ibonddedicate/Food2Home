//
//  FoodModels.swift
//  Food2Home
//
//  Created by Surote Gaide on 18/7/20.
//  Copyright © 2020 Surote Gaide. All rights reserved.
//

import Foundation
import UIKit

//MARK: Dummy

class FoodModel {
    let foodSet:[FoodModels] = [
        FoodModels(food: "Italian Meal", price: 489, image: UIImage(named: "ItalianMeal")!),
        FoodModels(food: "Japanese Meal", price: 689, image: UIImage(named: "JapaneseMeal")!),
        FoodModels(food: "German Meal", price: 369, image: UIImage(named: "GermanMeal")!),
        FoodModels(food: "Thai Meal", price: 79, image: UIImage(named: "ThaiMeal")!)
    ]
}
