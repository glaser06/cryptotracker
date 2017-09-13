//
//  AssetTableViewCell.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 8/25/17.
//  Copyright © 2017 zaizencorp. All rights reserved.
//

import UIKit

class AssetTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var totalValueLabel: UILabel!
//    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var colorIndicator: UIView!
    
    func setCell(asset: ShowPortfolio.FetchPortfolio.ViewModel.DisplayableAsset, color: UIColor) {
        
        self.totalValueLabel.text = asset.totalValue
//        self.amountLabel.text = asset.amount
        self.percentLabel.text = asset.change
        self.priceLabel.text = asset.price
        self.nameLabel.text = asset.coinName.uppercased()
        
        self.colorIndicator.backgroundColor = color
        
        if !asset.isUp {
            self.percentLabel.textColor = UIColor.red
        }
        
    }
    
}
