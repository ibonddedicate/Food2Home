//
//  ViewController.swift
//  Food2Home
//
//  Created by Surote Gaide on 18/7/20.
//  Copyright © 2020 Surote Gaide. All rights reserved.
//

import UIKit

protocol FoodPresenterOutput: class {
    
    func presenter(didSelectedMenu id: Int)
    
}


class FoodViewController: UIViewController {
    
    @IBOutlet weak var foodCV: UICollectionView!
    let foodModel = FoodModel()
    var interactor:FoodInteractor?
    var router:FoodRouter?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        foodCV.dataSource = self
        foodCV.delegate = self
        interactor?.viewDidLoad()
    }
}

//MARK: Presenter Output
extension FoodViewController: FoodPresenterOutput {
    
    func presenter(didSelectedMenu id: Int) {
        router?.routToAnother(id: id)
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
        self.interactor?.didSelectMeal(at: indexPath.row)
    }
    
    
}

