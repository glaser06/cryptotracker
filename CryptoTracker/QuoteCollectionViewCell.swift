//
//  QuoteCollectionViewCell.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 9/13/17.
//  Copyright © 2017 zaizencorp. All rights reserved.
//

import UIKit

class QuoteCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var quoteLabel: UILabel!
    
    func setCell(quote: String) {
        self.quoteLabel.text = quote
    }
    
}
