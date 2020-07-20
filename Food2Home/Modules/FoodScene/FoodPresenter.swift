
//
//  FoodPresenter.swift
//  Food2Home
//
//  Created by Surote Gaide on 18/7/20.
//  Copyright © 2020 Surote Gaide. All rights reserved.
//

import Foundation

protocol FoodPresenter: class {
    
    func interactor(didPickaMenu menuName: String, menuPrice: String)
    
}
class FoodPresenterImplementation: FoodPresenter {
    weak var viewController : FoodPresenterOutput?
    
    func interactor(didPickaMenu menuName: String, menuPrice: String){
        
        viewController?.presenter(didSelectedMenu: menuName, price: menuPrice)
        
    }
    
    
}
