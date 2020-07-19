
//
//  FoodPresenter.swift
//  Food2Home
//
//  Created by Surote Gaide on 18/7/20.
//  Copyright © 2020 Surote Gaide. All rights reserved.
//

import Foundation

protocol FoodPresenter: class {
    
    func interactor(didPickaMenu menuId: Int)
    
}
class FoodPresenterImplementation: FoodPresenter {
    var viewController:FoodViewController?
    
    func interactor(didPickaMenu menuId: Int) {
        viewController?.presenter(didSelectedMenu: menuId)
    }
    
    
}
