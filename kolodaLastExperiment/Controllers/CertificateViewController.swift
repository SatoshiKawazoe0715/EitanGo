//
//  certificateViewController.swift
//  kolodaLastExperiment
//
//  Created by Satoshi Kawazoe on 2023/01/17.
//

import UIKit
import FloatingPanel
import RealmSwift

class CertificateViewController: UIViewController {
    
    ///CertificateView
    @IBOutlet weak var certificateLabel: UILabel!
    @IBOutlet weak var certificateView: UIStackView!
    @IBOutlet weak var firstCommentLabel_certificateView: UILabel!
    @IBOutlet weak var secondCommentLabel_certificateView: UILabel!
    @IBOutlet weak var seeRecordButton_ceritificateView: UIButton!
    @IBOutlet weak var thirdCommentLabel_certificateView: UILabel!
    @IBOutlet weak var triangleImageView: UIImageView!
    
    ///TryAgainView
    @IBOutlet weak var tryAgainView: UIView!
    @IBOutlet weak var seeRecordButton_tryAgainView: UIButton!
    ///MessageView
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var firstCommentLabel_messageView: UILabel!
    @IBOutlet weak var secondCommentLabel_messageView: UILabel!
    @IBOutlet weak var thirdMessageLabel_messageView: UILabel!
    @IBOutlet weak var fourthCommentLabel_messageView: UILabel!
    ///Button
    @IBOutlet weak var finishLearningButton: UIButton!
    @IBOutlet weak var relearnButton: UIButton!
    
    let realm = try! Realm()
    let dateBrain = DataBrain()
    var cardDataAndLogic: CardDataAndLogic? /// LearningFieldVC から送られてくる
    var fpc : FloatingPanelController!
    var wordsData: Results<WordData>?
    var certificatedLevelColor_CGColor: CGColor {
        get {
            switch cardDataAndLogic!.selectedLebel {
            case "Level.1": return #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)
            case "Level.2": return #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
            case "Perfect": return #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1)
            default: return #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)
            }
        }
    }
    var certificatedLevelColor_UIColor: UIColor {
        get {
            switch cardDataAndLogic!.selectedLebel {
            case "Level.1": return #colorLiteral(red: 0, green: 0.568627451, blue: 0.5764705882, alpha: 1)
            case "Level.2": return #colorLiteral(red: 0, green: 0.3294117647, blue: 0.5764705882, alpha: 1)
            case "Perfect": return #colorLiteral(red: 0.3254901961, green: 0.1058823529, blue: 0.5764705882, alpha: 1)
            default: return #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        makeCertificateView()
        makeMessageView()
        saveData()
        ///以下は FoloatingPanelController に関するコード
        fpc = FloatingPanelController()
        fpc.delegate = self
        ///以下は枠線などの外観を完成させるメソッド
        makeInitialInterface()
        
    }
    
    //MARK: - certificateView を設定する関数
    
    func makeCertificateView() {
        if cardDataAndLogic?.failPerfectMode == true {
            tryAgainView.isHidden = false
            tryAgainView.layer.borderColor = certificatedLevelColor_CGColor
            tryAgainView.layer.borderWidth = 3
            tryAgainView.layer.cornerRadius = 20
            seeRecordButton_tryAgainView.layer.cornerRadius = 10
        } else {
            tryAgainView.isHidden = true
            if cardDataAndLogic?.getCertificateOnTheWay == true {
                firstCommentLabel_certificateView.text = "右スワイプした\(cardDataAndLogic!.certificatedWordsDataArray.count)語を"
            } else {
                firstCommentLabel_certificateView.text = "\(cardDataAndLogic!.initialCardNumber!)番から\(cardDataAndLogic!.lastCardNumber!)番の単語を"
            }
            secondCommentLabel_certificateView.text = "\(cardDataAndLogic!.selectedLebel!)モードで修了しました。"
            thirdCommentLabel_certificateView.text = dateBrain.fetchData("Certificate")
            ///色をつけていく
            seeRecordButton_ceritificateView.backgroundColor = certificatedLevelColor_UIColor
            certificateView.layer.borderColor = certificatedLevelColor_CGColor
            certificateView.layer.borderWidth = 3
            certificateView.layer.cornerRadius = 20
        }
    }
    
    //MARK: - messageView を設定する関数
    
    func makeMessageView() {
        messageView.layer.cornerRadius = 20
        if cardDataAndLogic?.failPerfectMode == true {
            messageView.backgroundColor = #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1)
            firstCommentLabel_messageView.textColor = .white
            secondCommentLabel_messageView.textColor = .white
            thirdMessageLabel_messageView.textColor = .white
            fourthCommentLabel_messageView.textColor = .white
            firstCommentLabel_messageView.text = "もう一度 Perfect モードに挑戦しませんか。"
            thirdMessageLabel_messageView.text = "あなたがすぐに学習に入れるように"
            fourthCommentLabel_messageView.text = "準備されています。"
            triangleImageView.image = UIImage(named: "triangle_violet")
        } else {
            switch cardDataAndLogic!.selectedLebel {
            case "Level.1":
                messageView.backgroundColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
                firstCommentLabel_messageView.textColor = .white
                secondCommentLabel_messageView.textColor = .white
                thirdMessageLabel_messageView.textColor = .white
                fourthCommentLabel_messageView.textColor = .white
                firstCommentLabel_messageView.text = "このまま Level.2 に挑戦しませんか。"
                thirdMessageLabel_messageView.text = "あなたがすぐに学習に入れるように"
                fourthCommentLabel_messageView.text = "準備されています。"
                triangleImageView.image = UIImage(named: "triangle_blue")
            case "Level.2":
                messageView.backgroundColor = #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1)
                firstCommentLabel_messageView.textColor = .white
                secondCommentLabel_messageView.textColor = .white
                thirdMessageLabel_messageView.textColor = .white
                fourthCommentLabel_messageView.textColor = .white
                firstCommentLabel_messageView.text = "このまま Perfect モードに挑戦しませんか。"
                thirdMessageLabel_messageView.text = "あなたがすぐに学習に入れるように"
                fourthCommentLabel_messageView.text = "準備されています。"
                triangleImageView.image = UIImage(named: "triangle_violet")
            case "Perfect":
                messageView.backgroundColor = #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1)
                firstCommentLabel_messageView.textColor = .white
                secondCommentLabel_messageView.textColor = .white
                thirdMessageLabel_messageView.textColor = .white
                fourthCommentLabel_messageView.textColor = .white
                firstCommentLabel_messageView.text = "同じ範囲を一定期間、繰り返し学習して"
                secondCommentLabel_messageView.text = "記憶を強固に定着させましょう。"
                thirdMessageLabel_messageView.text = "5日間連続で同じ範囲を Level.2 以上で修了すると"
                fourthCommentLabel_messageView.text = "Master の certificate が発行されます。"
                triangleImageView.isHidden = true
            default:
                print("CVC_ Error")
            }
        }
    }
    
    //MARK: - データを Realm に保存するための関数
    
    func saveData() {
        if cardDataAndLogic!.failPerfectMode == true || cardDataAndLogic!.certificatedWordsDataArray.count == 0 {
            //何も保存しない！
        } else {
            for i in 0 ... cardDataAndLogic!.certificatedWordsDataArray.count - 1 {
                do {
                    try realm.write {
                        cardDataAndLogic?.certificatedWordsDataArray[i].certificatedLevel = (cardDataAndLogic?.selectedLebel)! ///クリアしたレベルを保存.
                        cardDataAndLogic?.certificatedWordsDataArray[i].certificatedDate = dateBrain.fetchData("Realm") ///クリアした日付を保存.
                    }
                } catch {
                    print("Error saving done status, \(error)")
                }
            }
        }
    }
}


//MARK: - FloatingPannelDelegate

extension CertificateViewController: FloatingPanelControllerDelegate {
    
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return FloatingPanelStocksLayoutForAllWordsVC()
    }
    
    func floatingPanelDidMove(_ vc: FloatingPanelController) {
        if vc.isAttracting == false {
            let loc = vc.surfaceLocation
            let minY = vc.surfaceLocation(for: .full).y + 6.0
            let maxY = vc.surfaceLocation(for: .tip).y - 6.0
            vc.surfaceLocation = CGPoint(x: loc.x, y: min(max(loc.y, minY), maxY))
        }
    }
}



//MARK: - IBAction と 最初の外観に関する関数.

extension CertificateViewController {
    
    @IBAction func relearnButtonPressed(_sender: UIButton) {
        fpc.move(to: .half, animated: true)
    }
    
    @IBAction func finishLearningButtonPressed(_ sender: Any) {
        let allVC = self.navigationController?.viewControllers
        ///ここのコードの詳しい解説は LaunchVC でも同じコードを書いていてそこに書いている.
        var AllWordsVCisFound = false
        var m = 0
        while AllWordsVCisFound == false && m < 100 {
            m += 1
            if  let inventoryListVC = allVC![allVC!.count - m] as? AllWordsViewController {
                AllWordsVCisFound = true
                inventoryListVC.tableView.reloadData()
                inventoryListVC.makeInitialInterface()
                inventoryListVC.fpc.move(to: .hidden, animated: true)
                self.navigationController!.popToViewController(inventoryListVC, animated: true)
            }
        }
    }
    
    func makeInitialInterface() {
        // LaunchVCのインスタンスを作成.
        /// 注意！ LaunchVC の viewDidLoad 関数が発動するのは, fpc.set(contentViewController: newLaunchVC) のコードが実行されたとき。
        var newLaunchVC = storyboard?.instantiateViewController(withIdentifier: "launch") as? LaunchViewController
        newLaunchVC?.cardDataAndLogic = CardDataAndLogic()
        newLaunchVC?.cardDataAndLogic?.selectedTextbook = cardDataAndLogic?.selectedTextbook
        fpc.set(contentViewController: newLaunchVC) //ここでLaunchVC の viewDidLoad 関数が発動する
        newLaunchVC!.certificateVCMakeInitialInterface(cardDataAndLogic!.nextLearninLevelNumber!, cardDataAndLogic!.initialCardNumber!, cardDataAndLogic!.lastCardNumber!)
        fpc.move(to: .hidden, animated: false)
        fpc.addPanel(toParent: self)
        fpc.surfaceView.backgroundColor = UIColor(displayP3Red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        fpc.surfaceView.appearance.cornerRadius = 24.0
        fpc.surfaceView.appearance.shadows = []
        fpc.surfaceView.appearance.borderWidth = 1.0 / self.traitCollection.displayScale
        fpc.surfaceView.appearance.borderColor = UIColor.black.withAlphaComponent(0.2)
        fpc.surfaceView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        fpc.surfaceView.layer.shadowColor = UIColor.black.cgColor
        fpc.surfaceView.layer.shadowOpacity = 0.6
        fpc.surfaceView.layer.shadowRadius = 7
        ///その他枠線などに関するコード
        switch cardDataAndLogic!.selectedLebel {
        case "Level.1": relearnButton.backgroundColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
        case "Level.2": relearnButton.backgroundColor = #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1)
        case "Perfect":
            if cardDataAndLogic!.failPerfectMode == true {
                relearnButton.backgroundColor = #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1)
            } else {
                relearnButton.backgroundColor = .clear
                relearnButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                relearnButton.layer.borderWidth = 2
                relearnButton.setTitleColor(.black, for: .normal)
            }
            
        default:
            print("CVC_ Error")
        }
        relearnButton.layer.cornerRadius = 20
        finishLearningButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        finishLearningButton.layer.borderWidth = 2
        finishLearningButton.layer.cornerRadius = 20
        seeRecordButton_ceritificateView.layer.cornerRadius = 10
    }
    
}
