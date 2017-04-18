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
            collectionController.delegate = self
        } else if segue.identifier == SegueID.size,
            let viewController = segue.destination as? SizeViewController,
            let image = sender as? UIImage {
            
            viewController.image = image
            viewController.delegate = self
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
        present(pickerController, animated: true, completion: nil)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func presentCropper(withImage image: UIImage) {
        let cropViewController = CropViewController(image: image)
        cropViewController.delegate = self
        cropViewController.cancelButton.setImage(#imageLiteral(resourceName: "xButton"), for: .normal)
        cropViewController.cancelButton.setTitle(nil, for: .normal)
        present(cropViewController, animated: true, completion: nil)
    }
}

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        presentCropper(withImage: image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension HomeViewController: CropViewControllerDelegate {
    
    func cropViewController(_ viewController: CropViewController, cropped image: UIImage) {
        dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: SegueID.size, sender: image)
    }
    
    func cropViewControllerCancelled(_ viewController: CropViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension HomeViewController: SizeViewControllerDelegate {
    
    func sizeViewControllerCancelled(_ viewController: SizeViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func sizeViewController(_ viewController: SizeViewController, created woolImage: WoolImage) {
        dismiss(animated: true, completion: nil)
        collectionController.woolImages.append(woolImage)
        collectionController.collectionView?.reloadData()
    }
}

extension HomeViewController: HomeCollectionViewControllerDelegate {
    
    func homeCollectionViewController(_ viewController: HomeCollectionViewController, shouldExport image: WoolImage) {
        ExportUtility().prepareAndExport(image: image, fromVC: self)
    }
}
