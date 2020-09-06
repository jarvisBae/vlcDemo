//
//  FileCell.swift
//  VlcDemo
//
//  Created by JINKI BAE on 2020/09/04.
//  Copyright © 2020 JINKI BAE. All rights reserved.
//

import UIKit

class FileCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var video: Video? {
        didSet {
            let title = video?.title
            labelTitle.text = title
        }
    }
}
