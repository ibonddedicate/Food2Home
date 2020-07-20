//
//  ViewController.swift
//  Food2Home
//
//  Created by Surote Gaide on 18/7/20.
//  Copyright © 2020 Surote Gaide. All rights reserved.
//

import UIKit

protocol FoodPresenterOutput: class {
    
    func presenter(didSelectedMenu name: String, price: String)
    
}


class FoodViewController: UIViewController {
    
    @IBOutlet weak var foodCV: UICollectionView!
    
    
    let foodModel = FoodModel()
    var interactor : FoodInteractor?
    var pickedMenu = FoodModel.init().foodSet[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodCV.dataSource = self
        foodCV.delegate = self
        setup()
        interactor?.viewDidLoad()
    }
    
    private func setup() {
        let viewController = self
        let interactor = FoodInteractorImplementation()
        let presenter = FoodPresenterImplementation()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        
    }

}

//MARK: Presenter Output
extension FoodViewController: FoodPresenterOutput {
    func presenter(didSelectedMenu name: String, price: String) {
        performSegue(withIdentifier: "toDestination", sender: self)
        print("Menu: \(name) Picked, Price: \(price)")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDestination" {
            if segue.destination is DeliveryViewController {
                let vc = segue.destination as? DeliveryViewController
                vc?.pickedFood = pickedMenu
            }
        }
    }
    
    
}


//MARK: CollectionView Delegate, DataSource
extension FoodViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        foodModel.foodSet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCell", for: indexPath) as! FoodCollectionViewCell
        cell.mealName.text = foodModel.foodSet[indexPath.row].foodName
        cell.mealPhoto.image = foodModel.foodSet[indexPath.row].foodImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pickedMenu = foodModel.foodSet[indexPath.row]
        self.interactor?.didSelectMeal(at: indexPath.row)
    }
    
    
}

