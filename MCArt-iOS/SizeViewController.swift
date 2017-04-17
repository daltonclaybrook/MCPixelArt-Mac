//
//  SizeViewController.swift
//  MCPixelArt
//
//  Created by Dalton Claybrook on 4/16/17.
//  Copyright © 2017 Claybrook Software, LLC. All rights reserved.
//

import UIKit

protocol SizeViewControllerDelegate: class {
    func sizeViewController(_ viewController: SizeViewController, created woolImage: WoolImage)
    func sizeViewControllerCancelled(_ viewController: SizeViewController)
}

class SizeViewController: UIViewController {
    
    weak var delegate: SizeViewControllerDelegate?
    var image: UIImage?
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var sizeSegment: UISegmentedControl!
    @IBOutlet var previewSaveButton: UIButton!
    
    private var currentWoolImage: WoolImage?
    private let loadingView = LoadingView()
    private let widths: [CGFloat] = [ 50, 100, 200, 300 ]
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        imageView.layer.magnificationFilter = kCAFilterNearest
    }
    
    //MARK: Actions
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        delegate?.sizeViewControllerCancelled(self)
    }
    
    @IBAction func previewSaveButtonPressed(_ sender: Any) {
        guard let image = image else { return }
        
        loadingView.showInView(view: view)
        DispatchQueue.global(qos: .userInitiated).async {
            let processor = ImageProcessor(transformer: WoolColorTransformer())
            let processedImage = processor.process(image: image, size: self.sizeFromSelectedSegment())
            DispatchQueue.main.async {
                self.loadingView.hide()
                self.currentWoolImage = processedImage
                self.imageView.image = processedImage?.image
                self.previewSaveButton.setTitle("SAVE", for: .normal)
            }
        }
    }
    
    @IBAction func sizeSegmentValueChanged(_ sender: Any) {
        currentWoolImage = nil
        previewSaveButton.setTitle("PREVIEW", for: .normal)
    }
    
    //MARK: Private
    
    private func sizeFromSelectedSegment() -> CGSize {
        guard let image = image else { return .zero }
        let width = widths[sizeSegment.selectedSegmentIndex]
        let height = width * (image.size.height / image.size.width)
        return CGSize(width: width, height: height)
    }
}
