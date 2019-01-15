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
    var pkey: Int! = 0
    private var pathToImage: String? = ""
    weak var coreDataManager: CoreDataManager? = nil // ?????
    var pictureURL: String = ""// ?????
	var mode: ModifyMod
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
		if (mode == .update)
        {
		  titleBox.text = university.title
          subtitleBox.text = university.subtitle
          detailBox.text = university.detail
		  let submitBtn = UIBarButtonItem(title: "Submit", style: "done", target: self, action: #selector(submitButtonTapped))
		  self.navigationItem.rightBarButtonItem = submitBtn
          pictureView.image = picture ?? nil
		}
    }
    
    @IBAction func chooseImageButtonTouched(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
	
	func ModifyItemIntoCoreData()
	{
	      switch self.mode
	      {
		    // что делаем с imgurl??? его уже тут надо генерить???
	         case ModifyMode.insert:
			  { 
			     coreDataManager.addItem(key: maxPkey, title: titleTextView.text, subtitle: subtitleTextView.text, imgurl: pictureURL, detail: detailTextView.text)
			  }
			  case ModifyMode.update:
			  {
				if pictureURL != ""   
				 coreDataManager.updateItem(item: university, new_title: titleTextView.text, new_subtitle: subtitleTextView.text, new_imgurl: pictureURL, new_detail: detailTextView.text)
                else
				 coreDataManager.updateItem(item: university, new_title: titleTextView.text, new_subtitle: subtitleTextView.text, new_imgurl: university.imgurl, new_detail: detailTextView.text)
			  }
	      }
		 
	}
	
    func submitButtonTapped()
	{
	    let serverReader: URLInfoManager! = URLInfoManager()
		if mode == ModifyMode.insert
		{
		serverReader.readData(source: url)
		{   
		    [weak, self]
		    self.pkey = serverReader.max_pkey
			if let pathToImage = pathToImage
			{
			  if pathToImage != ""
			  {
			     let jpgData = NSData(contentsOfFile: filePath)! as Data
				 let name = NSURL(fileURLWithPath: pathToImage).lastPathComponent!
			     pictureURL = serverReader.uploadToServerJPGData(data: jpgData, withName: name)
				 guard pictureURL != "" else { 
				     return
				 }
			  }
			}
		    self.ModifyItemIntoCoreData()
		}
		}
		else
		{
			if let pathToImage = pathToImage
			{
			  if pathToImage != ""
			  {
			     let jpgData = NSData(contentsOfFile: filePath)! as Data
				 let name = NSURL(fileURLWithPath: pathToImage).lastPathComponent!
			     pictureURL = serverReader.uploadToServerJPGData(data: jpgData, withName: name)
				 guard pictureURL != "" else { 
				     return
				 }
			  }
			}
			self.ModifyItemIntoCoreData()
		}
	}
    

}

extension ModifyViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        pathToImage = UIImagePickerController.InfoKey.originalImage.rawValue
        if let pathToImage = pathToImage
        {
            let imageFromPC = info[pathToImage] as! UIImage
            pictureView.image = imageFromPC
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
