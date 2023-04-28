//
//  TableViewCell.swift
//  kolodaLastExperiment
//
//  Created by Satoshi Kawazoe on 2023/03/23.
//

import UIKit
import RealmSwift

class WordCell: UITableViewCell {
    
    @IBOutlet weak var wordNumberLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var changeLanguageButton: UIButton!
    @IBOutlet weak var cleardDateLabel: UILabel!
    @IBOutlet weak var cleardLevelLabel: UILabel!
    @IBOutlet weak var hinshiLabel: UILabel!
    
    
    var wordData: WordData? {
        didSet {
            wordNumberLabel.text = String(wordData!.wordNumber)
            wordLabel.text = wordData!.english
            cleardDateLabel.text = wordData!.certificatedDate
            switch wordData!.certificatedLevel {
            case nil:
                cleardLevelLabel.isHidden = true
            case "Level.1":
                cleardLevelLabel.isHidden = false
                cleardLevelLabel.text = wordData!.certificatedLevel
                cleardLevelLabel.backgroundColor = #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)
            case "Level.2":
                cleardLevelLabel.isHidden = false
                cleardLevelLabel.text = wordData!.certificatedLevel
                cleardLevelLabel.backgroundColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
            case "Perfect":
                cleardLevelLabel.isHidden = false
                cleardLevelLabel.text = wordData!.certificatedLevel
                cleardLevelLabel.backgroundColor = #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1)
            default:
                cleardLevelLabel.isHidden = false
                cleardDateLabel.text = wordData!.certificatedLevel
                print("WC_Error, certificatedLevel = \(wordData!.certificatedLevel)")
            }
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
    var currentLanguageIsEnglish = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cleardLevelLabel.layer.cornerRadius = 5
        hinshiLabel.layer.cornerRadius = 5
//        wordNumberLabel.text = String(wordData!.wordNumber)
//        wordLabel.text = wordData!.english
//        cleardDateLabel.text = wordData!.certificatedDate
//
//        switch wordData!.certificatedLevel {
//        case "Level.0":
//            cleardLevelLabel.isHidden = true
//        case "Level.1":
//            cleardLevelLabel.text = wordData!.certificatedLevel
//            cleardLevelLabel.backgroundColor = #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)
//        case "Level.2":
//            cleardLevelLabel.text = wordData!.certificatedLevel
//            cleardLevelLabel.backgroundColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
//        case "Perfect":
//            cleardLevelLabel.text = wordData!.certificatedLevel
//            cleardLevelLabel.backgroundColor = #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1)
//        default:
//            cleardLevelLabel.isHidden = true
//        }
//
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func changeLanguageButtonPressed(_ sender: Any) {
        switch currentLanguageIsEnglish {
        case true:
            wordLabel.text = wordData!.japanese
            changeLanguageButton.setTitle("→英", for: .normal)
            currentLanguageIsEnglish = false
        case false:
            wordLabel.text = wordData!.english
            changeLanguageButton.setTitle("→日", for: .normal)
            currentLanguageIsEnglish = true
        }
    }
    
}
