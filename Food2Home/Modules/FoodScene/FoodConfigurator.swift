//
//  FoodConfigurator.swift
//  Food2Home
//
//  Created by Surote Gaide on 18/7/20.
//  Copyright © 2020 Surote Gaide. All rights reserved.
//

import Foundation

class FoodConfigurator {

    static func configureModule(viewController: FoodViewController) {
        let interactor = FoodInteractorImplementation()
        let router = FoodRouterImplementation()
        let presenter = FoodPresenterImplementation()

        viewController.interactor = interactor
        viewController.router = router
        
        interactor.presenter = presenter
        presenter.viewController = viewController

    }

}
