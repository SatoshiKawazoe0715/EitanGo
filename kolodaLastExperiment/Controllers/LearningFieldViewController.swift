//
//  ViewController.swift
//  kolodaLastExperiment
//
//  Created by Satoshi Kawazoe on 2022/12/31.
//

import UIKit
import Koloda


class LearningFieldViewController: UIViewController {
    
    @IBOutlet weak var superViewAreaView: UIView! ///superViewArea の上部のみを着色するためのView
    @IBOutlet weak var navigationBarView: UIView! ///「終了」ボタンや「修了」ボタンなどがあるnavigationBarの位置にあるView
    @IBOutlet weak var modeLabel: UILabel! ///navigationBarViewで現在学習中のモードを表示するLabel
    @IBOutlet weak var stopLearningButton: UIButton! ///「終了」ボタン
    @IBOutlet weak var goToCertificateButton: UIButton! ///「修了」ボタン
    @IBOutlet weak var instructionLabel: UILabel! ///一番下の「答えを見るには画面をタップ。」などと表示するLabel
    @IBOutlet var kolodaFrameView: KolodaView!
    
    @IBOutlet var goToAnswerButton: [UIButton]! ///「答えを見るには画面をタップ。」の答えを見るためのボタン
    @IBOutlet weak var returnModeLabel: UILabel! ///復習モード時に「復習モード」とオレンジ色で表示するLabel
    @IBOutlet weak var progressNumberLabel: UILabel! ///復習モードでないときに何枚目までカードをめくったかを表示するLabel
    @IBOutlet weak var returnCardQuantityLabel: UILabel! ///左側に何枚スワイプしたかを表示するLabel
    @IBOutlet weak var certificatedCardQuantityLabel: UILabel! ///右側に何枚スワイプしたかを表示するLabel
    
    var cardDataAndLogic: CardDataAndLogic? ///LaunchVCから送られてくるデータ
    var cardInstanceArray: [CardViewController] = [] ///CardVCのインスタンスの配列
    var cardOverlayInstanceArray: [CardOverlayView] = []
    var tipIsShown: Bool = false ///「ヒントを見る」ボタンが押されたかを表す変数
    var answerIsShown = false /// 答えを表示したかを表す変数
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// navigationBar を非表示にする.
        navigationController?.setNavigationBarHidden(true, animated: false)
        /// CardVC, cardOverlayView のインスタンスの配列を作成.
        for _ in 1 ... cardDataAndLogic!.mainWordsDataArray.count {
            let cardVC = self.storyboard?.instantiateViewController(withIdentifier: "CardViewController") as! CardViewController
            let overlayView = Bundle.main.loadNibNamed("CardOverlayView", owner: self, options: nil)?[0] as! CardOverlayView
            cardInstanceArray.append(cardVC)
            cardOverlayInstanceArray.append(overlayView)
        }
        /// koloda の dataSource と delegate の担当を自分に設定.
        kolodaFrameView.dataSource = self
        kolodaFrameView.delegate = self
        makeInitialInterface() ///ユーザーインターフェイスを完成させる.
        kolodaFrameView.reloadData() ///kolodaをリロード
    }
}


//MARK: - KolodaViewDataSource - カードの作成を担当
extension LearningFieldViewController: KolodaViewDataSource {
    
    ///カードの枚数を返す
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return cardDataAndLogic!.mainWordsDataArray.count
    }
    
    /// \(index)番目のカードのオブジェクトを返す
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let cardVC = cardInstanceArray[index]
        cardVC.wordData = cardDataAndLogic!.mainWordsDataArray[index]
        cardVC.delegate = self
        return cardVC.view
    }
    
    /// \(index)番目のカードの overlay のオブジェクトを返す
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        let overlayView = cardOverlayInstanceArray[index]
        overlayView.selectedMode = cardDataAndLogic!.selectedLebel!
        overlayView.delegate = self
        return overlayView
    }
    
}
    
//MARK: - KolodaViewDelegate

extension LearningFieldViewController: KolodaViewDelegate {
    
    //MARK: - カードのスワイプ動作の処理を担当
    
    func koloda(_ koloda: KolodaView, didShowCardAt index: Int) {
        //二つのスイッチを初期化.
        answerIsShown = false
        tipIsShown = false
        //ラベルを更新する.
        returnCardQuantityLabel.text = String(cardDataAndLogic!.returnCardQuantity)
        certificatedCardQuantityLabel.text = String(cardDataAndLogic!.certificatedCardQuantity)
        progressNumberLabel.text = String("\(cardDataAndLogic!.progressNumber + 1) / \(cardDataAndLogic!.learningCardQuantity!)")
        instructionLabel.text = "答えを見るには余白をタップ。"
        if cardDataAndLogic?.returningMode == true {
            progressNumberLabel.isHidden = true
        } else {
            progressNumberLabel.isHidden = false
        }
    }
    
    func koloda(_ koloda: KolodaView, shouldSwipeCardAt index: Int, in direction: SwipeResultDirection) -> Bool {
        print("LFVC_ answerIsShown = \(answerIsShown)")
        if answerIsShown == true {
            return true
        } else {
            return false
        }
    }
    //カードがスワイプされた時に発動される。
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        ///カードのスワイプ動作を処理する.
        cardDataAndLogic!.swipeProcessing(direction, index, tipIsShown)
        ///復習モードのラベルを表示するべきか確認する.
        returnModeLabel.isHidden = !cardDataAndLogic!.returningMode ///復習モードのラベルを表示.
        ///セグエを実行するべきか確認する.
        if cardDataAndLogic!.checkViewControllerShouldPerformSegue() == true {
            performSegue(withIdentifier: "goToCertificate", sender: self) ///Certificateの画面へセグエ.
        }
        ///カードをリロードすべきか確認する.
        if cardDataAndLogic!.checkLearngVCShouldResetCardContentIndex() == true {
            /// CardVCのインスタンスの配列を作成しなおす.
            cardInstanceArray = []
            cardOverlayInstanceArray = []
            for _ in 1 ... cardDataAndLogic!.mainWordsDataArray.count {
                let cardVC = self.storyboard?.instantiateViewController(withIdentifier: "CardViewController") as! CardViewController
                let overlayView = Bundle.main.loadNibNamed("CardOverlayView", owner: self, options: nil)?[0] as! CardOverlayView
                cardInstanceArray.append(cardVC)
                cardOverlayInstanceArray.append(overlayView)
            }
            self.kolodaFrameView.resetCurrentCardIndex() /// カードをリロードする.
            cardDataAndLogic!.learningFieldVCShouldResetCurrentCardIndex = false
        }
    }

    //MARK: - カード切れの処理を担当する
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        cardDataAndLogic!.runOutProcessing()
        
        returnModeLabel.isHidden = !cardDataAndLogic!.returningMode
        
        if cardDataAndLogic!.checkViewControllerShouldPerformSegue() == true {
            performSegue(withIdentifier: "goToCertificate", sender: self) ///Certificateの画面へセグエ.
        }
        
        if cardDataAndLogic!.checkLearngVCShouldResetCardContentIndex() == true {
            cardInstanceArray = []
            cardOverlayInstanceArray = []
            for _ in 1 ... cardDataAndLogic!.mainWordsDataArray.count {
                let cardVC = self.storyboard?.instantiateViewController(withIdentifier: "CardViewController") as! CardViewController
                let overlayView = Bundle.main.loadNibNamed("CardOverlayView", owner: self, options: nil)?[0] as! CardOverlayView
                cardInstanceArray.append(cardVC)
                cardOverlayInstanceArray.append(overlayView)
            }
            self.kolodaFrameView.resetCurrentCardIndex()
            cardDataAndLogic!.learningFieldVCShouldResetCurrentCardIndex = false
        }
        
    }
    
    //MARK: - その他 KolodaViewDelegate のメソッド
    ///どこまでスワイプすれば自動でスワイプが始まるかを定義する関数.
    func kolodaSwipeThresholdRatioMargin(_ koloda: KolodaView) -> CGFloat? {
            return CGFloat(0.2)
    }
    
    func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool {
        return false
    }
    
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return false
    }
    
}

//MARK: - CardViewControllerDelegate カード内のボタンが押されたときの動作を担当.

extension LearningFieldViewController: CardViewControllerDelegate {
   
    func showTipButtonIsTappedInCardVC() {
        tipIsShown = true
        instructionLabel.text = "答えを見るには画面をタップ。"
    }

    func showAnswerButtonIsTappedInCardVC() {
        answerIsShown = true
        instructionLabel.text = "カードを左右にスワイプ。"
    }
    
    func checkAnswerIsShown() -> Bool {
        return answerIsShown
    }
}

//MARK: - CardOverlayViewDelegate
extension LearningFieldViewController: CardOverlayViewDelegate {
    func checkTipIsShown() -> Bool {
        return tipIsShown
    }
}

//MARK: - 画面遷移に関する関数
extension LearningFieldViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCertificate" {
            let destinationVC = segue.destination as! CertificateViewController
            destinationVC.cardDataAndLogic = cardDataAndLogic!
        }
    }
}


//MARK: - IBActionと最初のインターフェイスの設定に関する関数
extension LearningFieldViewController {
    
    // goToAnswerButtonPressed -> カードを回転させ答えを表示
    @IBAction func goToAnswerButtonPressed(_ sender: Any) {
        
        if answerIsShown == false {
            UIView.transition(with: self.cardInstanceArray[self.kolodaFrameView.currentCardIndex].cardFrameStackView,
                              duration: 0.2,
                                              options: [.transitionFlipFromLeft],
                                              animations: {
                self.cardInstanceArray[self.kolodaFrameView.currentCardIndex].showAnswer()
                                              },
                                              completion: nil)
            answerIsShown = true
            instructionLabel.text = "カードを左右にスワイプ。"
        }
    }
    
    
    // stopLearningButtonPressed -> allWordsVCに準備した後,遷移.
    @IBAction func stopLearningButtonPressed(_ sender: Any) {
        /// allVC は navigationController のスタックに入っているすべての ViewController
        let allVC = self.navigationController?.viewControllers
        /// allWordsVC をスタックから探すのに成功したかを判定する変数.
        var allWordsVCisFound = false
        /// 整数 m
        var m = 0
        /// allVC から AllWordsViewController を見つけていく.
        /// allWordsVC がスタックから見つけたら allWordsVCisFound = true にする
        while allWordsVCisFound == false && m < 100 {
            m += 1 ///AllWordsViewController と合致しない場合は m += 1 をして探索を続ける.
            if  let inventoryListVC = allVC![allVC!.count - m] as? AllWordsViewController {
                /// AllWordsViewController と合致したらこのコードが実行される.
                /// allWordsVCisFound を true にする.
                allWordsVCisFound = true
                /// CardDataAndLogic 構造体のインスタンスを作成し, 遷移先の allWordsVC の cardDataAndLogic プロパティに格納.
        //注意！popToViewController はすでに作成した allWordsVC のインスタンスに画面遷移する(よってviewDidLoad関数も呼ばれない)ため,allWordsVC のインスタンスのプロパティは allWordsVCから遷移した時そのままの状態になっている. よってあらためてcardDataプロパティを作り直す必要はない.
                
//                inventoryListVC.cardDataAndLogic = CardDataAndLogic()
//                /// cardDataAndLogic プロパティに格納したインスタンスの selectedTextbook プロパティに現在学習中の textbook を格納.
//                inventoryListVC.cardDataAndLogic?.selectedTextbook = cardDataAndLogic?.selectedTextbook
            
                inventoryListVC.tableView.reloadData()
                inventoryListVC.makeInitialInterface() /// modePicker の初期値を userDefault から読み込みなおすためにもう一度最初のインターフェイスを作り直す.
                /// 遷移先の allWordsVC の FloatingPannel の位置を設定.
                inventoryListVC.fpc.move(to: .hidden, animated: true)
                /// navigationController を通して遷移を実行.
                self.navigationController!.popToViewController(inventoryListVC, animated: true)
            }
        }
    }
        
    @IBAction func certificateButtonPressed(_ sender: Any) {
        cardDataAndLogic!.getCertificateOnTheWay = true
        performSegue(withIdentifier: "goToCertificate", sender: self)
        
    }
    
    
    func makeInitialInterface() {
        returnModeLabel.isHidden = true
        returnModeLabel.layer.cornerRadius = 5
        modeLabel.text = cardDataAndLogic!.selectedLebel
        progressNumberLabel.text = String("\(cardDataAndLogic!.progressNumber) / \(cardDataAndLogic!.learningCardQuantity!)")
        switch cardDataAndLogic!.selectedLebel {
        case "Level.1":
            certificatedCardQuantityLabel.textColor = #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)
            superViewAreaView.backgroundColor = #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)
            navigationBarView.backgroundColor = #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)
        case "Level.2":
            certificatedCardQuantityLabel.textColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
            superViewAreaView.backgroundColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
            navigationBarView.backgroundColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
        case "Perfect":
            certificatedCardQuantityLabel.textColor = #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1)
            superViewAreaView.backgroundColor = #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1)
            navigationBarView.backgroundColor = #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1)
        default:
            print("LFVC_ Error")
        }
    }
}





