//
//  LoadingTableCell.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 11/3/17.
//  Copyright © 2017 zaizencorp. All rights reserved.
//

import UIKit

class LoadingTableCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var refresher: UIActivityIndicatorView!
    
}
