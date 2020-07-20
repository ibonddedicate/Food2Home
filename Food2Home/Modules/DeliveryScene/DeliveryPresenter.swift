//
//  DeliveryPresenter.swift
//  Food2Home
//
//  Created by Surote Gaide on 19/7/20.
//  Copyright © 2020 Surote Gaide. All rights reserved.
//

import Foundation

protocol DeliveryPresenter: class {
    
}

class DeliveryPresenterImplementation: DeliveryPresenter {
    weak var viewController : DeliveryPresenterOutput?
    
    func distanceFeeCalculated(fee: Double) {
        viewController?.updateDeliveryCost(cost: fee)
    }
}
