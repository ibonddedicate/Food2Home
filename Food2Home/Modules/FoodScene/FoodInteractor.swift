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
    var presenter: FoodPresenter?
    
    func didSelectMeal(at index: Int) {
        presenter?.interactor(didPickaMenu: index)
    }
    
    func viewDidLoad() {
        print("interactor loaded")
    }
}
