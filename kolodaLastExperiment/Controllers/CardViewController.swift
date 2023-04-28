//
//  Container_VC.swift
//  kolodaLastExperiment
//
//  Created by Satoshi Kawazoe on 2022/12/31.
//
import UIKit

protocol CardViewControllerDelegate {
    func showTipButtonIsTappedInCardVC()
    func showAnswerButtonIsTappedInCardVC()
    func checkAnswerIsShown() -> Bool
}


class CardViewController: UIViewController {
    
    @IBOutlet var cardViewFrame: UIView!
    /// Labels ラベル
    @IBOutlet weak var wordNumberLabel: UILabel!
    @IBOutlet weak var hinshiLabel: UILabel!
    @IBOutlet weak var mainWordLabel: UILabel!
    @IBOutlet weak var initalHiraganaLabel: UILabel!
    @IBOutlet weak var subWordLabel: UILabel!
    /// UIImageView 画像
    @IBOutlet weak var tipImageView: UIImageView!
    /// UIButton ボタン
    @IBOutlet weak var seeTipButton: UIButton!
    @IBOutlet weak var changeTipImageButton: UIButton!
    /// UIView ビュー
    @IBOutlet weak var cardFrameStackView: UIStackView!
    @IBOutlet weak var centerFrameView: UIView!
    
    var wordData: WordData?
    var delegate: CardViewControllerDelegate?
    var hinshiLabelColor: UIColor {
        get {
            switch wordData!.hinshi {
            case "名詞": return #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1)
            case "他動詞": return #colorLiteral(red: 0.5810584426, green: 0.1285524964, blue: 0.5745313764, alpha: 1)
            case "自動詞": return #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)
            case "形容詞": return #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            case "副詞": return #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            case "前置詞": return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            case "接続詞": return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            default: return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeInitialInterface()
    }
    
    ///カードのインターフェイスを初期状態にするためのコード.
    func makeInitialInterface() {
        /// wordData をもとに設定するパーツ
        cardViewFrame.backgroundColor = .white
        wordNumberLabel.text = String(wordData!.wordNumber)
        mainWordLabel.text = wordData!.english
        subWordLabel.text = wordData!.english
        initalHiraganaLabel.text = wordData!.firstHiragana
        tipImageView.image = UIImage(named: wordData!.english)
        hinshiLabel.text = wordData!.hinshi
        hinshiLabel.backgroundColor = hinshiLabelColor
        hinshiLabel.layer.cornerRadius = 5
        /// 表示 / 非表示に関するコード
        tipImageView.isHidden = true
//        changeTipImageButton.isHidden = true
        subWordLabel.isHidden = true
        ///枠線に関するコード
        cardFrameStackView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cardFrameStackView.layer.cornerRadius = 20
        cardFrameStackView.layer.borderWidth = 1
//        cardViewFrame.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//        cardViewFrame.layer.shadowColor = UIColor.black.cgColor
//        cardViewFrame.layer.shadowOpacity = 0.6
//        cardViewFrame.layer.shadowRadius = 7
        seeTipButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        seeTipButton.layer.cornerRadius = 10
        seeTipButton.layer.borderWidth = 1
    }
    ///カードのインターフェイスをヒントが表示された状態にするためのコード.
    func showTipImage() {
        ///表示 / 非表示に関するコード
        seeTipButton.isHidden = true
        changeTipImageButton.isHidden = false
        subWordLabel.isHidden = false
        tipImageView.isHidden = false
        ///枠線に関するコード
        centerFrameView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        centerFrameView.layer.cornerRadius = 10
        centerFrameView.layer.borderWidth = 1
//        changeTipImageButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        changeTipImageButton.layer.cornerRadius = 5
//        changeTipImageButton.layer.borderWidth = 1
    }
    ///カードのインターフェイスを答えが表示された状態にするためのコード.
    func showAnswer() {
        /// wordData をもとに設定するパーツ
        mainWordLabel.text = wordData?.japanese
        ///表示 / 非表示に関するコード
        seeTipButton.isHidden = true
        changeTipImageButton.isHidden = false
        subWordLabel.isHidden = false
        tipImageView.isHidden = false
        ///枠線に関するコード
        centerFrameView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        centerFrameView.layer.cornerRadius = 10
        centerFrameView.layer.borderWidth = 1
//        changeTipImageButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        changeTipImageButton.layer.cornerRadius = 5
//        changeTipImageButton.layer.borderWidth = 1
    }
    
    //MARK: - IBAction
    
    @IBAction func seeAnswerButtonPressed(_ sender: Any) {
        if delegate?.checkAnswerIsShown() == false {
            UIView.transition(with: cardFrameStackView,
                                              duration: 0.2,
                                              options: [.transitionFlipFromLeft],
                                              animations: {
                self.showAnswer()
                                              },
                                              completion: nil)
            delegate?.showAnswerButtonIsTappedInCardVC()

        }
    }
    
    @IBAction func seeTipButtonPressed(_ sender: Any) {
        UIView.transition(with: self.cardFrameStackView,
                              duration: 0.2,
                              options: [.transitionFlipFromLeft],
                              animations: {
                self.showTipImage()
            },
                              completion: nil)
        delegate?.showTipButtonIsTappedInCardVC()
    }
    
    @IBAction func changeTipImageButtonPressed(_ sender: Any) {
        
    }
    
}



    
