//
//  ViewController.swift
//  plantDetector
//
//  Created by jinqi on 2021/6/22.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,netRequestDelegate, visionAnalysisDelegate {

    

    let imagePicker = UIImagePickerController()
    let visionAnalysisController = visionAnalysis()
    let netRequestController = netRequest()
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var uiImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = true
        self.netRequestController.delegate = self
        self.visionAnalysisController.delegate = self
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        self.imagePicker.sourceType = .camera
        present(self.imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func photoTapped(_ sender: UIBarButtonItem) {
        self.imagePicker.sourceType = .photoLibrary
        present(self.imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            self.uiImage.image = selectedImage
            self.visionAnalysisController.asyncDetectImage(image: selectedImage)
        }
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
    
//MARK: - network delegate
    func setLabelAndImageInMainQueue(flowerDescription: String, imageURLString: String) {
        DispatchQueue.main.async {
            self.label.text = flowerDescription
            self.uiImage.sd_setImage(with: URL(string: imageURLString), placeholderImage: .remove, options: .continueInBackground, context: .none)
        }
    }
    
//MARK: - visionAnalysis delegate
    func updateTitle(flowerName: String) {
        self.netRequestController.makeSearchRequest(flowerName: flowerName)
        DispatchQueue.main.async {
            self.navigationItem.title = flowerName.capitalized
        }
    }
    
}

