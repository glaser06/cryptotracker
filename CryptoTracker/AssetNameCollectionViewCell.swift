//
//  AssetNameCollectionViewCell.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 11/3/17.
//  Copyright © 2017 zaizencorp. All rights reserved.
//

import UIKit

class AssetNameCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var colorIndicator: UIView!
    
    func setCell(name: String, color: UIColor) {
        self.nameLabel.text = name
        self.colorIndicator.backgroundColor = color
    }

}
