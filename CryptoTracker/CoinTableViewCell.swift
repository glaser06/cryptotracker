//
//  CoinTableViewCell.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 8/23/17.
//  Copyright © 2017 zaizencorp. All rights reserved.
//

import UIKit

class CoinTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var capLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(data: ListCoins.FetchCoins.ViewModel.DisplayableCoin) {
        
        self.tickerLabel.text = data.symbol
        self.capLabel.text = data.cap
        self.priceLabel.text = data.price
        self.percentLabel.text = data.percentage
        
    }
    
}
