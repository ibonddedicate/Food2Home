//
//  DeliveryInteractor.swift
//  Food2Home
//
//  Created by Surote Gaide on 19/7/20.
//  Copyright © 2020 Surote Gaide. All rights reserved.
//

import Foundation

protocol DeliveryInteractor: class {
    func calculateDeliveryCost(dist: Float)
}

class DeliveryInteractorImplementation: DeliveryInteractor {
    var presenter : DeliveryPresenterImplementation?
    
    func calculateDeliveryCost(dist: Float){
        let costPerMeter = 0.020
        let total = costPerMeter * Double(dist)
        presenter?.distanceFeeCalculated(fee: total)
    }
}
