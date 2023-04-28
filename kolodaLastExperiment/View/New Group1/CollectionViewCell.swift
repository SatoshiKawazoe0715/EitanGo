//
//  TableViewCell.swift
//  kolodaLastExperiment
//
//  Created by Satoshi Kawazoe on 2023/04/04.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var fameView: UIStackView!
    @IBOutlet weak var TextImageView: UIImageView!
    @IBOutlet weak var textNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
//        fameView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//        fameView.layer.shadowColor = UIColor.black.cgColor
//        fameView.layer.shadowOpacity = 0.6
//        fameView.layer.shadowRadius = 4
        TextImageView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    }

        // Configure the view for the selected state
}
    

