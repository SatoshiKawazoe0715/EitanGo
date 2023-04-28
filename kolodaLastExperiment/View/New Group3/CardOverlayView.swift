//
//  ExampleOverlayView.swift
//  kolodaLastExperiment
//
//  Created by Satoshi Kawazoe on 2023/01/01.
//

import UIKit
import Koloda

protocol CardOverlayViewDelegate {
    func checkTipIsShown() -> Bool
}

class CardOverlayView: OverlayView { /// OverlayView は koloda の pod で定義されている.
    
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var overlayImageView: UIImageView!
    @IBOutlet weak var cardFrameView: UIView!
    
    var delegate: CardOverlayViewDelegate?
    var selectedMode: String = "Level.1"
    
    
    override var overlayState: SwipeResultDirection? { ///overlayState はスワイプされた方向が判明したとき koloda の pod が渡してくる.
        didSet {
            cardFrameView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cardFrameView.layer.borderWidth = 0.5
            cardFrameView.layer.cornerRadius = 20
            switch (overlayState, selectedMode) {
            case(.left, "Level.1"):
                overlayImageView.image = UIImage(named: "left")
                modeLabel.text = "Level.1"
                messageLabel.text = "もう一度。"
            case(.left, "Level.2"):
                overlayImageView.image = UIImage(named: "left")
                modeLabel.text = "Level.2"
                messageLabel.text = "もう一度。"
            case(.left, "Perfect"):
                overlayImageView.image = UIImage(named: "perfect_left")
                modeLabel.text = "Perfect"
                messageLabel.text = "何度も挑戦しよう。"
            case(.right, "Level.1"):
                overlayImageView.image = UIImage(named: "Level.1_right")
                modeLabel.text = "Level.1"
                messageLabel.text = "Cleard."
            case(.right, "Level.2"):
                if delegate?.checkTipIsShown() == false {
                    overlayImageView.image = UIImage(named: "Level.2_right")
                    modeLabel.text = "Level.2"
                    messageLabel.text = "Cleard."
                } else {
                    overlayImageView.image = UIImage(named: "Level.2_tipIsTapped_right")
                    modeLabel.text = "Level.2"
                    messageLabel.text = "次はヒントを見ずに。"
                }
            case(.right, "Perfect"):
                if delegate?.checkTipIsShown() == false {
                    overlayImageView.image = UIImage(named: "perfect_right")
                    modeLabel.text = "Perfect"
                    messageLabel.text = "Cleard."
                } else {
                    overlayImageView.image = UIImage(named: "perfect_left")
                    modeLabel.text = "Perfect"
                    messageLabel.text = "何度も挑戦しよう。"
                }
                
            default:
                overlayImageView.image = UIImage(named: "right")
                modeLabel.text = "Level.1"
                messageLabel.text = "Cleard."
            }
        }
    }

}

