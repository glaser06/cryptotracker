//
//  FiatAssetTableViewCell.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 9/22/17.
//  Copyright © 2017 zaizencorp. All rights reserved.
//

import UIKit

class FiatAssetTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var totalValueLabel: UILabel!
//    @IBOutlet weak var valueColorView: UIView!
    
    //    @IBOutlet weak var amountLabel: UILabel!
//    @IBOutlet weak var percentLabel: UILabel!
//    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var colorIndicator: UIView!
//    @IBOutlet weak var capLabel: UILabel!
    
//    @IBOutlet weak var amountLabel: UILabel!
//    @IBOutlet weak var valueLabel: UILabel!
    
    func setCell(asset: ShowPortfolio.FetchPortfolio.ViewModel.DisplayableAsset, color: UIColor) {
        nameLabel.text = asset.coinName
        symbolLabel.text = asset.symbol.uppercased()
        totalValueLabel.text = asset.totalValue
        colorIndicator.backgroundColor = color
    }
    
    
    
}
