//
//  TransactionTableCell.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 3/4/18.
//  Copyright © 2018 zaizencorp. All rights reserved.
//

import UIKit

class TransactionTableCell: UITableViewCell {
    
    static let identifier = "TransactionTableCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var pairLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var sideIndicator: UIView!
    
    @IBOutlet weak var amountLabel: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setCell(transaction: ListTransactions.FetchAsset.ViewModel.DisplayableTransaction) {
        self.pairLabel.text = transaction.pairName
        self.priceLabel.text = transaction.price
        self.dateLabel.text = transaction.date
        self.amountLabel.text = transaction.amount
        
        if transaction.isBuySide {
            self.sideIndicator.backgroundColor = UIView.theGreen
        } else {
            self.sideIndicator.backgroundColor = UIView.theRed
        }
    }
}
