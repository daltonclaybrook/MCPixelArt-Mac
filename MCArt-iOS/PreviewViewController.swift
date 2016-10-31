//
//  PreviewViewController.swift
//  MCPixelArt
//
//  Created by Dalton Claybrook on 10/30/16.
//  Copyright © 2016 Claybrook Software, LLC. All rights reserved.
//

import UIKit

protocol PreviewViewControllerDelegate: class {
    func previewViewController(_ vc: PreviewViewController, saved image: WoolImage<UIImage>)
    func previewViewControllerCancelled(_ vc: PreviewViewController)
}

class PreviewViewController: UIViewController {
    
    @IBOutlet var previewImageView: UIImageView!
    weak var delegate: PreviewViewControllerDelegate?
    
    private var woolImage: WoolImage<UIImage>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previewImageView.image = woolImage?.image
    }
    
    //MARK: Public
    
    func configure(with image: WoolImage<UIImage>) {
        self.woolImage = image
    }
    
    //MARK: Actions
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        delegate?.previewViewControllerCancelled(self)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let woolImage = woolImage else { return }
        saveImage(image: woolImage)
    }
    
    //MARK: Private
    
    private func saveImage(image: WoolImage<UIImage>) {
        let schematic = MCSchematic()
        let data = schematic.createSchematic(withIndeces: image.woolIndexes, andSize: image.image.size, replacingWhiteWool: false)
        let url = tempFileURL()
        
        do {
            try data.write(to: url)
            showDocumentController(with: url)
        } catch let error {
            print("error: \(error)")
        }
    }
    
    private func showDocumentController(with url: URL) {
        let activity = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        activity.completionWithItemsHandler = { [weak self] (type, completed, returnedItems, error) in
            if completed, let strongSelf = self, let woolImage = strongSelf.woolImage {
                strongSelf.delegate?.previewViewController(strongSelf, saved: woolImage)
            } else if let error = error {
                print("error: \(error)")
            }
        }
        present(activity, animated: true, completion: nil)
    }
    
    private func tempFileURL() -> URL {
        var tempURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        tempURL.appendPathComponent("minecraft.schematic")
        return tempURL
    }
}
