//
//  CustomTableViewCell.swift
//  Project
//
//  Created by Zeus on 13.12.2018.
//  Copyright © 2018 Zeus. All rights reserved.
//

import Foundation
import UIKit

class CustomTableViewCell : UITableViewCell
{
    @IBOutlet var imageCustom: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool){
        super.setSelected(selected, animated: animated)
    }
    
}
