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
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var capLabel: UILabel!
    @IBOutlet weak var displayButton: UIButton!
//    @IBOutlet weak var percentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var currentlyDisplayed: Int = 0
    
    var percentage: String = ""
    
    var marketCap: String = ""
    var price: String = ""
    
    var changeAllDisplays: (() -> Void)?
    
    var isSender = false
    
    func setCell(data: ListCoins.FetchCoins.ViewModel.DisplayableCoin, change: @escaping () -> Void, currentInfo: Int) {
        
        self.tickerLabel.text = data.name
        self.capLabel.text = data.cap
        self.symbolLabel.text = data.symbol
        
//        self.priceLabel.text = data.price
        self.percentage = data.percentage
        self.price = data.price
        self.marketCap = data.cap
        
        currentlyDisplayed = currentInfo
        self.changeAllDisplays = change
        self.changeDisplayNoLooping()
        
//        self.percentLabel.text = data.percentage
        
    }
    @IBAction func changeDisplay() {
        
        let arr = [price,percentage]
        self.displayButton.setTitle(arr[currentlyDisplayed], for: .normal)
        currentlyDisplayed += 1
        if currentlyDisplayed >= 2 {
            currentlyDisplayed = 0
        }
        self.isSender = true
        self.changeAllDisplays!()
        
        
    }
    func changeDisplayNoLooping() {
        let arr = [price,percentage]
        if currentlyDisplayed >= 2 {
            currentlyDisplayed = 0
        }
        self.displayButton.setTitle(arr[currentlyDisplayed], for: .normal)
        currentlyDisplayed += 1
        if currentlyDisplayed >= 2 {
            currentlyDisplayed = 0
        }
        self.isSender = false
    }
    
}
