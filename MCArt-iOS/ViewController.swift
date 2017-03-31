//
//  ViewController.swift
//  MCArt-iOS
//
//  Created by Dalton Claybrook on 10/28/16.
//  Copyright © 2016 Claybrook Software, LLC. All rights reserved.
//

import UIKit

let ShowPreview = "ShowPreview"

class ViewController: UIViewController {

    private let loadingView = LoadingView()
    private var woolImage: WoolImageT?
    
    //MARK: Superclass
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == ShowPreview, let controller = segue.destination as? PreviewViewController, let woolImage = woolImage {
            controller.delegate = self
            controller.configure(with: woolImage)
        }
    }
    
    //MARK: Actions
    
    @IBAction func takeAPhotoButtonPressed(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func chooseAnImageButtonPressed(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: Private
    
    fileprivate func process(image: UIImage, size: CGSize) {
        loadingView.showInView(view: view)
        DispatchQueue(label: "Image Processing").async { [weak self] in
            let processor = ImageProcessor<UIImage>(transformer: WoolColorTransformer())
            if let woolImage = processor.process(image: image, size: size) {
                DispatchQueue.main.async {
                    self?.loadingView.hide()
                    self?.woolImage = woolImage
                    self?.performSegue(withIdentifier: ShowPreview, sender: nil)
                }
            }
        }
        
    }
}

extension ViewController: PreviewViewControllerDelegate {
    
    func previewViewController(_ vc: PreviewViewController, saved image: WoolImageT) {
        dismiss(animated: true, completion: nil)
    }
    
    func previewViewControllerCancelled(_ vc: PreviewViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        process(image: image, size: CGSize(width: 200, height: 200))
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
