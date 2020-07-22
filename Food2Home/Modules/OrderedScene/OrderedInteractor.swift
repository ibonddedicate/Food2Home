//
//  OrderedInteractor.swift
//  Food2Home
//
//  Created by Surote Gaide on 22/7/20.
//  Copyright © 2020 Surote Gaide. All rights reserved.
//

import Foundation
import CoreLocation

protocol OrderedInteractor: class {
    func calculateDuration(userLoc: CLLocationCoordinate2D, restLoc: CLLocationCoordinate2D)
}

class OrderedInteractorImplementation: OrderedInteractor {
    var presenter: OrderedPresenter?
    
    func calculateDuration(userLoc: CLLocationCoordinate2D, restLoc: CLLocationCoordinate2D) {
        MapService().requestDuration(userLoc: userLoc, restLoc: restLoc) {
            let time = MapService.duration
            self.presenter?.durationCalculated(time: time)
        }
    }
    
}
