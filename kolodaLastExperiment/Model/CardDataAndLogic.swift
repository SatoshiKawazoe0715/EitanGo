//
//  swipeBrain.swift
//  kolodaLastExperiment
//
//  Created by Satoshi Kawazoe on 2023/04/12.
//
import UIKit
import Koloda
import RealmSwift


struct CardDataAndLogic {
    
    // TextSelectinVC で決定する変数.
    var selectedTextbook: Textbook?  ///今回学習する textbook
    var allWordsInTextBook_Data: Results<WordData>? {
        get {
            return selectedTextbook?.wordsData.sorted(byKeyPath: "wordNumber", ascending: true)
        }
    }
    // LaunchVC で決定する変数
    var selectedLevelNumber: Int? { ///学習するモード.   Level.0 > -1, Level.1 > 0, Level.2 > 1, Perfect > 2
        didSet {
            switch selectedLevelNumber {
            case 0:
                selectedLebel = "Level.1"
                nextLearninLevelNumber = 1
            case 1:
                selectedLebel = "Level.2"
                nextLearninLevelNumber = 2
            case 2:
                selectedLebel = "Perfect"
                nextLearninLevelNumber = 2
            default:
                selectedLebel = "Level.1"
                nextLearninLevelNumber = 1
            }
        }
    }
    var nextLearninLevelNumber: Int?
    var selectedLebel: String?
    var initialCardNumber: Int? { ///学習する最初のカードの番号. LaunchViewController でスタートボタンが押されるとデータが飛んでくる.
        didSet {
            if let l = lastCardNumber, let t = selectedTextbook {
                mainWordsDataArray = Array(t.wordsData.filter("wordNumber >= %@ && wordNumber <= %@", initialCardNumber!, l).sorted(byKeyPath: "wordNumber", ascending: true))
                backupWordsDataArray = mainWordsDataArray
                learningCardQuantity = mainWordsDataArray.count
                learningCardQuantity = l - initialCardNumber! + 1
                print("CDAL_ mainWordsDataArray is set from initalCardNumber")
            }
        }
    }
    var lastCardNumber: Int? { ///学習する最後のカードの番号.  LaunchViewController でスタートボタンが押されるとデータが飛んでくる.
        didSet {
            if let i = initialCardNumber, let t = selectedTextbook {
                mainWordsDataArray = Array(t.wordsData.filter("wordNumber >= %@ && wordNumber <= %@", i, lastCardNumber!).sorted(byKeyPath: "wordNumber", ascending: true))
                backupWordsDataArray = mainWordsDataArray
                learningCardQuantity = lastCardNumber! - i + 1
                print("CDAL_ mainWordsDataArray is set from lastCardNumber")
            }
        }
    }
    var maxReturnCardsQuantity: Int? ///何枚で復習モードに入るかを決める整数
    var learningCardQuantity: Int? /// LearningFieldCV で学習するカードの枚数. mainWordsDataArray.count = learningCardQuantity とは限らないことに注意！
    var mainWordsDataArray:[WordData] = [] /// kolodaViwe を作るのに使うデータの配列. カードが切れるとリセットされたり, 復習モードに入ると repaetWordsDataArray のデータが写されたりする.
    var backupWordsDataArray:[WordData] = [] /// 復習モードから復活する時に mainWordsDataArray を作るのに使うデータの配列.
    var repeatWordsDataArray:[WordData] = [] /// 復習モード時に kolodaView を作るのに使うデータの配列.
    var certificatedWordsDataArray:[WordData] = [] /// 記録をつける単語のデータの配列.
    var progressNumber: Int = 0 ///何枚目のカードまでスワイプされたかを記録する変数
    var returnCardQuantity: Int = 0 ///repeatWordsDataArrayに何枚分のデータがあるか記録する変数
    var certificatedCardQuantity: Int = 0 ///何枚右にスワイプしたかを記録する変数
    var returningMode: Bool = false /// 復習モードが発動しているかを表す変数
    var learningFieldVCShouldPerformSegue: Bool = false
    var learningFieldVCShouldResetCurrentCardIndex: Bool = false
    var failPerfectMode: Bool = false /// PerfectModeに失敗したかどうかを表す変数.
    var getCertificateOnTheWay = false ///「修了」ボタンが押された場合 true に.
    
//MARK: - カードをスワイプした時の処理を担当
    
//カードがスワイプが完了した時に発動される
    mutating func swipeProcessing(_ direction: SwipeResultDirection,
                                  _ index: Int,
                                  _ tipIsShown: Bool) {
        
        switch (returningMode, direction, selectedLebel, tipIsShown) {
    //メインモードで左スワイプ
        case (false, .left, "Level.1" , false): ///_1 メインモード, 左スワイプ, Level.1,  ヒントは見られていない
            /// データを管理.
            repeatWordsDataArray.append(mainWordsDataArray[index])
            progressNumber += 1
            returnCardQuantity += 1
            certificatedCardQuantity += 0
            ///復習モードに入るか確認
            activateReturnModeIfShould(index)
        case (false, .left, "Level.1", true): ///_2 Level.1 ヒントが見られたとき
            repeatWordsDataArray.append(mainWordsDataArray[index])
            progressNumber += 1
            returnCardQuantity += 1
            certificatedCardQuantity += 0
            ///復習モードに入るか確認
            activateReturnModeIfShould(index)
    ///メインモードで左スワイプ.
        case (false, .left, "Level.2", false): ///_3 Level.2 ヒントは見られていない
            repeatWordsDataArray.append(mainWordsDataArray[index])
            progressNumber += 1
            returnCardQuantity += 1
            certificatedCardQuantity += 0
            ///復習モードに入るか確認
            activateReturnModeIfShould(index)
        case (false, .left, "Level.2", true): ///_4 Level.2 ヒントが見られたとき
            repeatWordsDataArray.append(mainWordsDataArray[index])
            progressNumber += 1
            returnCardQuantity += 1
            certificatedCardQuantity += 0
            ///復習モードに入るか確認
            activateReturnModeIfShould(index)
    ///メインモードで左スワイプ.
        case (false, .left, "Perfect", false): ///_5 Perfect ヒントは見られていない
            failPerfectMode = true
            learningFieldVCShouldPerformSegue = true ///ここを true にしておけば ViewController はこの関数をを実行した直後に下のコードを実行する.
         // performSegue(withIdentifier: "goToCertificate", sender: self) //Certificateの画面へセグエ.
        case (false, .left, "Perfect", true): ///_6 Perfect ヒントが見られたとき
            failPerfectMode = true
            learningFieldVCShouldPerformSegue = true ///ここを true にしておけば ViewController はこの関数をを実行した直後に下のコードを実行する.
         // performSegue(withIdentifier: "goToCertificate", sender: self) //Certificateの画面へセグエ.
    //メインモードで右スワイプ。
        case (false, .right, "Level.1", false): ///_7 Level.1 ヒントは見られていない
            certificatedWordsDataArray.append(mainWordsDataArray[index])
            progressNumber += 1
            returnCardQuantity += 0
            certificatedCardQuantity += 1
        case (false, .right, "Level.1", true): ///_8 Level.1 ヒントが見られたとき
            certificatedWordsDataArray.append(mainWordsDataArray[index])
            progressNumber += 1
            returnCardQuantity += 0
            certificatedCardQuantity += 1
    //メインモードで右スワイプ。
        case (false, .right, "Level.2", false): ///_9 Level.2 ヒントは見られていない
            certificatedWordsDataArray.append(mainWordsDataArray[index])
            progressNumber += 1
            returnCardQuantity += 0
            certificatedCardQuantity += 1
        case (false, .right, "Level.2", true): ///_10 Level.2 ヒントが見られたとき
        //ヒントを見ずに左スワイプされるのと同じ動作
            repeatWordsDataArray.append(mainWordsDataArray[index])
            progressNumber += 1
            returnCardQuantity += 1
            certificatedCardQuantity += 0
            activateReturnModeIfShould(index)
    //メインモードで右スワイプ。
        case (false, .right, "Perfect", false): //_11 Perfect ヒントは見られていない
            certificatedWordsDataArray.append(mainWordsDataArray[index])
            progressNumber += 1
            returnCardQuantity += 0
            certificatedCardQuantity += 1
        case (false, .right, "Perfect", true): //_12 Perfect ヒントが見られたとき
            failPerfectMode = true
            learningFieldVCShouldPerformSegue = true ///ここを true にしておけば ViewController はこの関数をを実行した直後に下のコードを実行する.
         // performSegue(withIdentifier: "goToCertificate", sender: self) ///Certificateの画面へセグエ.
    //復習モードで左スワイプ。
        case (true, .left, "Level.1", false): //_13 Level.1 ヒントは見られていない
            repeatWordsDataArray.append(mainWordsDataArray[index])
            progressNumber += 0
            returnCardQuantity += 0
            certificatedCardQuantity += 0
        case (true, .left, "Level.1", true): //_14 Level.1 ヒントが見られたとき
            repeatWordsDataArray.append(mainWordsDataArray[index])
            progressNumber += 0
            returnCardQuantity += 0
            certificatedCardQuantity += 0
    //復習モードで左スワイプ。
        case (true, .left, "Level.2", false): //_15 Level.2 ヒントは見られていない
            repeatWordsDataArray.append(mainWordsDataArray[index])
            progressNumber += 0
            returnCardQuantity += 0
            certificatedCardQuantity += 0
        case (true, .left, "Level.2", true): //_16 Level.2 ヒントが見られたとき
            repeatWordsDataArray.append(mainWordsDataArray[index])
            progressNumber += 0
            returnCardQuantity += 0
            certificatedCardQuantity += 0
//        case (true, .left, 2, false): //_17 Perfect ヒントは見られていない (こんな時は存在しない)
//        case (true, .left, 2, true):  //_18 Perfect ヒントが見られたとき (こんな時は存在しない)
    //復習モードで右スワイプ。
        case (true, .right, "Level.1", false): //_19 Level.1 ヒントは見られていない
            certificatedWordsDataArray.append(mainWordsDataArray[index])
            progressNumber += 0
            returnCardQuantity -= 1
            certificatedCardQuantity += 1
        case (true, .right, "Level.1", true): //_20 Level.1 ヒントが見られたとき
            certificatedWordsDataArray.append(mainWordsDataArray[index])
            progressNumber += 0
            returnCardQuantity -= 1
            certificatedCardQuantity += 1
        case (true, .right, "Level.2", false): //_21 Level.2 ヒントは見られていない
            certificatedWordsDataArray.append(mainWordsDataArray[index])
            progressNumber += 0
            returnCardQuantity -= 1
            certificatedCardQuantity += 1
        case (true, .right, "Level.2", true): //_22 Level.2 ヒントが見られたとき
        //左スワイプと同じ動作
            repeatWordsDataArray.append(mainWordsDataArray[index])
            progressNumber += 0
            returnCardQuantity += 0
            certificatedCardQuantity += 0
//        case (true, .right, 2, false):  ///_23 Perfect ヒントは見られていない (こんな時は存在しない)
//        case (true, .right, 2, true):  ///_24 Perfect ヒントが見られたとき (こんな時は存在しない)
        default:
            print("Error")
        }
    }

    ///メインモードで左スワイプされたとき復習モード発動の処理をするべきかを判定する関数.
    mutating func activateReturnModeIfShould(_ index: Int) {
         if returnCardQuantity >= maxReturnCardsQuantity! && progressNumber < learningCardQuantity! {
            //復習モードが発動するのは, 1 または 2 の条件を満たすこと.
            //1. returnCardQuantity が maxReturnCardQuantityに達すること。
            //2. progressNumber が cardQuantiyに達する(カードが切れる)こと。
            //1.の条件と2.の条件の両方を満たすとき,
            //両方の条件から同時に復習モード発動の処理をしてしまうとエラーになるので,
            //この関数では "&& progressNumber < CardQuantity"のコードでそのエラーを防いでいる。
            returningMode = true ///復習モードを発動
            mainWordsDataArray = repeatWordsDataArray ///repeatArrayに入った要素をmainArrayに写す
            repeatWordsDataArray = [] ///repeatArrayを初期化する
            learningFieldVCShouldResetCurrentCardIndex = true ///ここを true にしておけば ViewController はこの関数を呼び出した swipeProcessing (_, _, ) メソッドを実行した直後に下のコードを実行する.
//            kolodaView.resetCurrentCardIndex() ///mainArrayを元にカードを作成しなおす
            }
    }

//MARK: - runOutProcessing()  カード切れのときの処理
    
    mutating func runOutProcessing() {
        switch (returningMode, returnCardQuantity) {
    //メインモードで復習すべきカードが0枚 -> セグエを実行
        case (false, 0):
            learningFieldVCShouldPerformSegue = true
    //メインモードで復習すべきカードがある -> 復習モード発動.
        case (false, 1 ... learningCardQuantity!):
            returningMode = true
            mainWordsDataArray = repeatWordsDataArray ///repeatArrayに入った要素をmainArrayに写す
            repeatWordsDataArray = []
            learningFieldVCShouldResetCurrentCardIndex = true
            
        case(true, 0):
    //復習モードで復習すべきカード0枚,カードは全て表示されている -> セグエを実行
            if progressNumber == learningCardQuantity {
                learningFieldVCShouldPerformSegue = true
            }
    //復習モードで復習すべきカード0枚,まだ表示されていないカードがある -> 復習モードを解除
            else {
                returningMode = false
                mainWordsDataArray = Array(backupWordsDataArray[progressNumber...learningCardQuantity! - 1])
                learningFieldVCShouldResetCurrentCardIndex = true
            }
    //復習モードで復習すべきカードがある -> 復習モード継続.
        case(true, 1 ... learningCardQuantity!):
            returningMode = true
            mainWordsDataArray = repeatWordsDataArray ///repeatArrayに入った要素をmainArrayに写す
            repeatWordsDataArray = []
            learningFieldVCShouldResetCurrentCardIndex = true
        default:
            ("Error")
        }
        
    }
    

//MARK: - LaunchVCで入力された値が正しいかを判定する関数
    func initilCardNumberIsCorrect(_ initialCardNumber: Int) -> Bool {
        if initialCardNumber >= 1 && initialCardNumber <= allWordsInTextBook_Data!.count {
            return true
        } else {
            return false
        }
    }
    
    func lastCardNumberIsCorrect(_ lastCardNumber: Int) -> Bool {
        if lastCardNumber >= initialCardNumber ?? 1 && lastCardNumber <= allWordsInTextBook_Data!.count { ///initialCardNumberが決まっていない時は
            return true
        } else {
            return false
        }
    }
    
    
    
//MARK: - LearningFieldVC がセグエするかやkolodaをリセットするかを確認するための関数
        mutating func checkLearngVCShouldResetCardContentIndex() -> Bool {
            return learningFieldVCShouldResetCurrentCardIndex
        }
        
        mutating func checkViewControllerShouldPerformSegue() -> Bool {
            return learningFieldVCShouldPerformSegue
        }
        
        
    
}
