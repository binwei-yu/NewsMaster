//
//  NewsViewCell.swift
//  NewsMaster
//
//  Created by Vincent Yu on 2/16/19.
//  Copyright © 2019 Vincent Yu. All rights reserved.
//

import UIKit

class NewsViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var RecentLabel: UILabel!
    @IBOutlet weak var AuthorLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
