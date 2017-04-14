//
//  HomeViewController.swift
//  MCPixelArt
//
//  Created by Dalton Claybrook on 3/30/17.
//  Copyright © 2017 Claybrook Software, LLC. All rights reserved.
//

import UIKit
import MobileCoreServices

class HomeViewController: UIViewController {
    var collectionController: HomeCollectionViewController!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueID.homeCollection, let collectionController = segue.destination as? HomeCollectionViewController {
            self.collectionController = collectionController
        }
    }
    
    //MARK: Actions
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Take a Photo", style: .default, handler: { (action) in
            self.showPicker(withSourceType: .camera)
        }))
        sheet.addAction(UIAlertAction(title: "Choose an Image", style: .default, handler: { (action) in
            self.showPicker(withSourceType: .savedPhotosAlbum)
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(sheet, animated: true, completion: nil)
    }
    
    //MARK: Private
    
    private func showPicker(withSourceType type: UIImagePickerControllerSourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            showAlert(title: "Oops", message: "The selected image source type is unavailable")
            return
        }
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = type
        pickerController.mediaTypes = [kUTTypeImage as String]
//        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
