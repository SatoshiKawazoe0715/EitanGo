//
//  TableViewCell.swift
//  kolodaLastExperiment
//
//  Created by Satoshi Kawazoe on 2023/04/04.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var japaneseLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var hinshiLabel: UILabel!
    @IBOutlet weak var englishLabel: UILabel!
    
    var wordData: WordData? {
        didSet {
            englishLabel.text = wordData?.english
            japaneseLabel.text = wordData?.japanese
            /// hinshiLabel の設定
            hinshiLabel.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            switch wordData?.hinshi {
            case "名詞": hinshiLabel.text = "名"
            case "他動詞": hinshiLabel.text = "他"
            case "自動詞": hinshiLabel.text = "自"
            case "形容詞": hinshiLabel.text = "形"
            case "副詞": hinshiLabel.text = "副"
            case "前置詞": hinshiLabel.text = "前"
            case "接続詞": hinshiLabel.text = "接"
            default: print("Error")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        hinshiLabel.layer.cornerRadius = 5
        editButton.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
