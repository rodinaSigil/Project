//
//  ModifyViewController.swift
//  Project
//
//  Created by Zeus on 13.01.2019.
//  Copyright © 2019 Zeus. All rights reserved.
//

import UIKit
import CoreData

class ModifyViewController: UIViewController {

    @IBOutlet weak var titleBox: UITextView!
    
    @IBOutlet weak var subtitleBox: UITextView!
    
    
    @IBOutlet weak var detailBox: UITextView!
    
    
    @IBOutlet weak var pictureView: UIImageView!
    
    weak var university: Universities! = Universities()
    weak var picture: UIImage? = nil
    private var pathToImage: String? = ""
    weak var coreDataManager: CoreDataManager? = nil // ?????
	var mode: ModifyMod = ModifyMod.insert
    let serverPictureSavingPath = "https://api.backendless.com/1635C9DF-95AF-D692-FF8F-6FB81E271200/FDE223AC-8187-63FC-FF2C-031A610D0900/files"
    
    override func viewDidLoad() {
        super.viewDidLoad()
		if (mode == .update)
        {
		  titleBox.text = university.title
          subtitleBox.text = university.subtitle
          detailBox.text = university.detail
          pictureView.image = picture ?? nil
		}
        let submitBtn = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(submitButtonTapped))
        self.navigationItem.rightBarButtonItem = submitBtn
        
    }
    
    @IBAction func chooseImageButtonTouched(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
	
	func modifyItemIntoCoreData()
	{
       if self.pathToImage == ""
       {
          if self.mode == ModifyMod.insert
          {
             coreDataManager?.addItem(key: 0, title: self.titleBox.text, subtitle: subtitleBox.text, imgurl: "", detail: detailBox.text)
            coreDataManager?.saveChangesInContext()
          }
          if self.mode == ModifyMod.update
          {
            coreDataManager?.updateItem(item: self.university, new_title: self.titleBox.text, new_subtitle: self.subtitleBox.text, new_imgurl: "", new_detail: self.detailBox.text)
            coreDataManager?.saveChangesInContext()
          }
       }
        else
       {
          // upload image to server
        
        
       }
	}
	
    func sendToServer()
    {
        let serverManager = URLInfoManager()
        var buf = Universities()
        serverManager.sendImageToServer(name: "image.jpg", urlPath: serverPictureSavingPath, jpgdata: pictureView.image?.jpegData(compressionQuality: 0)! ?? nil, sender: buf)
    }
    
    @objc func submitButtonTapped()
	{
       //self.modifyItemIntoCoreData()
       self.sendToServer()
	}
    

}

extension ModifyViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        pathToImage = UIImagePickerController.InfoKey.originalImage.rawValue
        if let pathToImage = pathToImage
        {
            let imageFromPC = info[pathToImage] as! UIImage
            pictureView.image = imageFromPC
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
