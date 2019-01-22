//
//  CustomTableViewCell.swift
//  Project
//
//  Created by Zeus on 13.12.2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imageCustom: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    //let downloader = ImageDownloader()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setImage(URL: String)
    {
       // downloader.startDownload(url: URL) {
         //   self.imageCustom!.image = self.downloader.tmp_image
       // }
    }
    
    override func prepareForReuse() {
      //  downloader.stopDownload()
    }
    
}
