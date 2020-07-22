//
//  OrderedViewController.swift
//  Food2Home
//
//  Created by Surote Gaide on 21/7/20.
//  Copyright © 2020 Surote Gaide. All rights reserved.
//

import UIKit
import ViewAnimator

protocol OrderedPresenterOutput: class {
    func setDuration(dur: String)
}

class OrderedViewController: UIViewController {

    @IBOutlet weak var waitDuration: UILabel!
    @IBOutlet weak var mockUpButton1: UIButton!
    @IBOutlet weak var mockUpButton2: UIButton!
    @IBOutlet weak var theChef: UIImageView!
    @IBOutlet weak var orderStatus: UILabel!
    var interactor: OrderedInteractor?
    var locationDistance: Float?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        mockUpButton1.layer.cornerRadius = 10
        mockUpButton2.layer.cornerRadius = 10
        theChef.alpha = 0
        waitDuration.alpha = 0

        
        if locationDistance != nil {
            interactor?.calculateDuration(duration: locationDistance!)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        theChef.animate(animations: [AnimationType.from(direction: .right, offset: 100.00)], duration: 2.5, options: [.repeat, .autoreverse])
        waitDuration.animate(animations: [AnimationType.from(direction: .left, offset: 100.00)], delay: 3, duration: 3)
        orderStatus.text = ""
        var charIndex = 0.0
        let statusText = "The chef is about to 🍳 your order.."
        for letter in statusText {
            Timer.scheduledTimer(withTimeInterval: 0.04 * charIndex, repeats: false) {(timer) in
                self.orderStatus.text?.append(letter)
            }
            charIndex += 1
        }
    }
    
    private func setup() {
        let viewController = self
        let interactor = OrderedInteractorImplementation()
        let presenter = OrderedPresenterImplementation()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    

}

extension OrderedViewController: OrderedPresenterOutput {
    
    func setDuration(dur: String) {
        DispatchQueue.main.async {
            self.waitDuration.text = dur
        }
    }
    
    
}
