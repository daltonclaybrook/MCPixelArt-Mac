//
//  ArtCell.swift
//  MCPixelArt
//
//  Created by Dalton Claybrook on 3/30/17.
//  Copyright © 2017 Claybrook Software, LLC. All rights reserved.
//

import UIKit

class ArtCell: UICollectionViewCell {
    static var reuseID: String {
        return "ArtCell"
    }
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var gradientView: GradientView!
    @IBOutlet var nameLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gradientView.isHidden = false
        nameLabel.isHidden = false
    }
    
    func configure(with woolImage: WoolImageT) {
        imageView.image = woolImage.image
        if let name = woolImage.name {
            nameLabel.text = name
        } else {
            gradientView.isHidden = true
            nameLabel.isHidden = true
        }
    }
}
