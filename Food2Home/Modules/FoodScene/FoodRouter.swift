//
//  FoodRouter.swift
//  Food2Home
//
//  Created by Surote Gaide on 18/7/20.
//  Copyright © 2020 Surote Gaide. All rights reserved.
//

import Foundation

protocol FoodRouter {
    
    func routToAnother(id: Int)
    
}

class FoodRouterImplementation: FoodRouter {
    
    func routToAnother(id: Int) {
        print("push new view id:\(id)")
    }
    
    
}
