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
    @IBOutlet weak var backView: UIView!
    
    
    func setCell(quote: String) {
//        self.backView.layer.borderColor = color(from: 107, green: 185, blue: 240).cgColor
        self.quoteLabel.text = quote
    }
    
    func color(from red: Int, green: Int, blue: Int) -> UIColor {
//        UIColor(red: Float(red)/255.0, green: Float(green)/255.0, blue: Float(blue)/255.0, alpha: 1.0)
        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
    }
    
}
