//
//  OrderedPresenter.swift
//  Food2Home
//
//  Created by Surote Gaide on 22/7/20.
//  Copyright © 2020 Surote Gaide. All rights reserved.
//

import Foundation

protocol OrderedPresenter: class {
    func durationCalculated(time: String)
}

class OrderedPresenterImplementation: OrderedPresenter {
    weak var viewController: OrderedViewController?
    
    func durationCalculated(time: String) {
        viewController?.setDuration(dur: time)
    }
    
    
}
