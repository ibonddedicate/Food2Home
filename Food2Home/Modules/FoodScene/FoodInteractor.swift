//
//  FoodInteractor.swift
//  Food2Home
//
//  Created by Surote Gaide on 18/7/20.
//  Copyright © 2020 Surote Gaide. All rights reserved.
//

import Foundation

protocol FoodInteractor: class {
    
    func didSelectMeal(at index: Int)
    func viewDidLoad()
}

class FoodInteractorImplementation: FoodInteractor {
    var presenter : FoodPresenterImplementation?
    var foodModel = FoodModel()
    
    func didSelectMeal(at index: Int) {
        let selectedFoodName = foodModel.foodSet[index].foodName
        let selectedFoodPrice = String(foodModel.foodSet[index].foodPrice)
        presenter?.interactor(didPickaMenu: selectedFoodName, menuPrice: selectedFoodPrice)
    }
    
    func viewDidLoad() {
        print("interactor loaded")
    }
}
