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
	// var urlPicture: String? = nil
    weak var coreDataManager: CoreDataManager? = nil // ?????
	var mode: ModifyMod = ModifyMod.insert
    let serverPictureSavingPath = "https://api.backendless.com/1635C9DF-95AF-D692-FF8F-6FB81E271200/FDE223AC-8187-63FC-FF2C-031A610D0900/files"
    var selectedImageName: String? = ""
   // let resourceDownloader: ResourceDownloader? = nil
	
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
        //self.resourceDownloader = ResourceDownloader()
		//self.resourceDownloader.initDownloading(self.urlPicture)
		/*
		 {
		    pictureView.image = 
		 }
		*/
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
          if self.mode == ModifyMod.insert
          {
            self.university = coreDataManager?.addItem(key: 0, title: self.titleBox.text, subtitle: subtitleBox.text, imgurl: "", detail: detailBox.text)
            coreDataManager?.saveChangesInContext()
          }
          if self.mode == ModifyMod.update
          {
            coreDataManager?.updateItem(item: self.university, new_title: self.titleBox.text, new_subtitle: self.subtitleBox.text, new_imgurl: self.university.imgurl ?? "", new_detail: self.detailBox.text)
            coreDataManager?.saveChangesInContext()
          }
          if self.selectedImageName != ""
		  {
            if let selectedImageName = selectedImageName
            {
                sendToServer(withName: selectedImageName)
                
            }
		  }
	}
	
    func sendToServer(withName: String)
    {
        let serverManager = URLInfoManager()
        serverManager.sendImageToServer(name: withName,
                                        urlPath: serverPictureSavingPath,
                                        jpgdata: pictureView.image?.jpegData(compressionQuality: 0)! ?? nil,
                                        sender: self.university)
    }
    
    @objc func submitButtonTapped()
	{
       //self.modifyItemIntoCoreData()
       //self.sendToServer()
	   self.modifyItemIntoCoreData()
	}
    

}

extension ModifyViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let imageFromPC = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        pictureView.image = imageFromPC
        self.dismiss(animated: true, completion: nil)
        self.selectedImageName = (info[UIImagePickerController.InfoKey.imageURL] as! URL).lastPathComponent
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
