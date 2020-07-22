//
//  OrderedInteractor.swift
//  Food2Home
//
//  Created by Surote Gaide on 22/7/20.
//  Copyright © 2020 Surote Gaide. All rights reserved.
//

import Foundation

protocol OrderedInteractor: class {
    func calculateDuration(duration: Float)
}

class OrderedInteractorImplementation: OrderedInteractor {
    var presenter: OrderedPresenter?
    
    func calculateDuration(duration: Float) {
        var takeTime:String?
        if duration < 3000 {
            takeTime = "< 15 Minutes"
        } else if duration > 13000 {
            takeTime = "> 40 Minutes"
        } else {
            takeTime = "20 - 35 Minutes"
        }
        presenter?.durationCalculated(time: takeTime!)
    }
    
}
