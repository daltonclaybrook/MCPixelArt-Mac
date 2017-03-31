//
//  HomeViewController.swift
//  MCPixelArt
//
//  Created by Dalton Claybrook on 3/30/17.
//  Copyright © 2017 Claybrook Software, LLC. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    var collectionController: HomeCollectionViewController!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueID.homeCollection, let collectionController = segue.destination as? HomeCollectionViewController {
            self.collectionController = collectionController
        }
    }
    
    //MARK: Actions
    
    @IBAction func addButtonPressed(_ sender: Any) {
//        let sheet = UIAlertController(title: "", message: <#T##String?#>, preferredStyle: <#T##UIAlertControllerStyle#>)
    }
}
