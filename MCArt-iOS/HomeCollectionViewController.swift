//
//  HomeCollectionViewController.swift
//  MCPixelArt
//
//  Created by Dalton Claybrook on 3/30/17.
//  Copyright © 2017 Claybrook Software, LLC. All rights reserved.
//

import UIKit

class HomeCollectionViewController: UICollectionViewController {
    var aspectLayout: AspectCollectionViewLayout {
        return collectionViewLayout as! AspectCollectionViewLayout
    }
    
    var woolImages = [WoolImageT]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aspectLayout.dataSource = self
    }
    
    //MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return woolImages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtCell.reuseID, for: indexPath) as! ArtCell
        cell.configure(with: woolImages[indexPath.item])
        return cell
    }
    
    //MARK: Private
}

extension HomeCollectionViewController: AspectLayoutDataSource {
    func aspectLayout(_ layout: AspectCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return woolImages[indexPath.item].image.size
    }
}
