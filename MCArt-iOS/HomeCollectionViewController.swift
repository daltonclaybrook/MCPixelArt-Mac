//
//  HomeCollectionViewController.swift
//  MCPixelArt
//
//  Created by Dalton Claybrook on 3/30/17.
//  Copyright © 2017 Claybrook Software, LLC. All rights reserved.
//

import UIKit

protocol HomeCollectionViewControllerDelegate: class {
    func homeCollectionViewController(_ viewController: HomeCollectionViewController, shouldExport image: WoolImage)
}

class HomeCollectionViewController: UICollectionViewController {
    var aspectLayout: AspectCollectionViewLayout {
        return collectionViewLayout as! AspectCollectionViewLayout
    }
    
    var woolImages = [WoolImage]()
    weak var delegate: HomeCollectionViewControllerDelegate?
    
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
    
    //MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let woolImage = woolImages[indexPath.item]
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Export Schematic", style: .default, handler: { [weak self] (action) in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.homeCollectionViewController(strongSelf, shouldExport: woolImage)
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(sheet, animated: true, completion: nil)
    }
}

extension HomeCollectionViewController: AspectLayoutDataSource {
    func aspectLayout(_ layout: AspectCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return woolImages[indexPath.item].image.size
    }
}
