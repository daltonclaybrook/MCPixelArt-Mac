//
//  ExportUtility.swift
//  MCPixelArt
//
//  Created by Dalton Claybrook on 4/17/17.
//  Copyright © 2017 Claybrook Software, LLC. All rights reserved.
//

import UIKit

struct ExportUtility {
    
    //MARK: Public
    
    func prepareAndExport(image: WoolImage, fromVC: UIViewController) {
        let schematic = MCSchematic()
        let data = schematic.createSchematic(withIndeces: image.woolIndexes, andSize: image.image.size, replacingWhiteWool: false)
        let url = tempFileURL()
        
        do {
            try data.write(to: url)
            showDocumentController(with: url, fromVC: fromVC)
        } catch let error {
            print("error: \(error)")
        }
    }
    
    //MARK: Private
    
    private func showDocumentController(with url: URL, fromVC: UIViewController) {
        let activity = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        activity.completionWithItemsHandler = { (type, completed, returnedItems, error) in
            if let error = error {
                print("error: \(error)")
            } else {
                print("success!")
            }
        }
        fromVC.present(activity, animated: true, completion: nil)
    }
    
    private func tempFileURL() -> URL {
        var tempURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        tempURL.appendPathComponent("minecraft.schematic")
        return tempURL
    }
}
