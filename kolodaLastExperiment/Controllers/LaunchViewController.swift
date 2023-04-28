//
//  LaunchViewController.swift
//  kolodaLastExperiment
//
//  Created by Satoshi Kawazoe on 2023/01/13.
//
//

import UIKit
import RealmSwift
import IQKeyboardManager

class LaunchViewController: UIViewController {
    
    @IBAction func helpButton_modeSettingViewPressed(_ sender: Any) {
        let overLayer = OverlayoutPopUpViewController()
        overLayer.appear(sender: self)
        overLayer.LevelInstructionLabel.isHidden = false
        overLayer.maxReturnCardsQuantityInstructionLabel.isHidden = true
        overLayer.defaultLevelInstructionLabel.isHidden = true
        overLayer.usualCardQuantityInstructionLabel.isHidden = true
    }
    
    @IBAction func helpButton_maxReturnCardsQuantityPressed(_ sender: Any) {
        let overLayer = OverlayoutPopUpViewController()
        overLayer.appear(sender: self)
        overLayer.LevelInstructionLabel.isHidden = true
        overLayer.maxReturnCardsQuantityInstructionLabel.isHidden = false
        overLayer.defaultLevelInstructionLabel.isHidden = true
        overLayer.usualCardQuantityInstructionLabel.isHidden = true
    }
    
    @IBAction func helpButton_defaultModeSettingViewPressed(_ sender: Any) {
        let overLayer = OverlayoutPopUpViewController()
        overLayer.appear(sender: self)
        overLayer.LevelInstructionLabel.isHidden = true
        overLayer.maxReturnCardsQuantityInstructionLabel.isHidden = true
        overLayer.defaultLevelInstructionLabel.isHidden = false
        overLayer.usualCardQuantityInstructionLabel.isHidden = true
    }
    
    @IBAction func helpButton_usualLearningCardQuantityPressed(_ sender: Any) {
        let overLayer = OverlayoutPopUpViewController()
        overLayer.appear(sender: self)
        overLayer.LevelInstructionLabel.isHidden = true
        overLayer.maxReturnCardsQuantityInstructionLabel.isHidden = true
        overLayer.defaultLevelInstructionLabel.isHidden = true
        overLayer.usualCardQuantityInstructionLabel.isHidden = false
    }
    
    
    @IBAction func startButtonPressed(_ sender: Any) {
        ///「スタート」ボタンを押された時の動作. 注意書きのラベルが全て消えているのを確認して画面遷移.
        ///注意書きのラベルが全て消えていることは 3 つの textField が正しく入力されていることを保証する.
        if initalCardNumberTextField_NoteLabel.isHidden == true && lastCardNumberTextField_NoteLabel.isHidden == true && maxReturnCardsQuantityTextField_NoteLabel.isHidden == true {
            cardDataAndLogic!.initialCardNumber = Int(initalCardNumberTextFieild.text!)
            cardDataAndLogic!.lastCardNumber = Int(lastCardNumberTextField.text!)
            cardDataAndLogic!.maxReturnCardsQuantity = Int(maxReturnCardsQuantityTextField.text!)
            cardDataAndLogic!.selectedLevelNumber = modePicker.selectedRow(inComponent: 0)
            performSegue(withIdentifier: "goToLearningField", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToLearningField" {
            let destinationVC = segue.destination as! LearningFieldViewController
            destinationVC.cardDataAndLogic = cardDataAndLogic
        }
    }
    
    
    
    @IBOutlet weak var startButton: UIButton! ///「学習を開始」するのボタン
    @IBOutlet weak var initalCardNumberTextFieild: UITextField! ///「番から」の前のテキストフィールド
    @IBOutlet weak var lastCardNumberTextField: UITextField! ///「番まで」の前のテキストフィールド
    @IBOutlet weak var maxReturnCardsQuantityTextField: UITextField! ///「枚で復習モードに入る」の前のテキストフィールド
    @IBOutlet weak var usualLearningCardsQuantityTextField: UITextField!
    @IBOutlet weak var modePicker: UIPickerView! ///開始する学習のレベルを設定するピッカー
    @IBOutlet weak var defaultModePicker: UIPickerView! ///「デフォルトを 〜 モードに」の「〜」部分のピッカー
    @IBOutlet weak var initalCardNumberTextField_NoteLabel: UILabel!
    @IBOutlet weak var maxReturnCardsQuantityTextField_NoteLabel: UILabel!
    @IBOutlet weak var lastCardNumberTextField_NoteLabel: UILabel!
    @IBOutlet weak var usualLearningCardQuantityTextField_NoteLabel: UILabel!
    @IBOutlet weak var alertLabel_startButton_top: UILabel!
    @IBOutlet weak var alertLabel_startButton_bottom: UILabel!
    
    @IBOutlet weak var bankaraButton: UIButton! ///「番から」の文字の下のボタン
    @IBOutlet weak var banmadeButton: UIButton! ///「番まで」の文字の下のボタン
    @IBOutlet weak var helpButton_rangeView: UIButton!
    @IBOutlet weak var helpButton_modeSelectingView: UIButton!
    @IBOutlet weak var helpButton_maxReturnCardNumberSettingView: UIButton!
    @IBOutlet weak var helpButton_defaultModeSettingView: UIButton!
    @IBOutlet var borderLabels: [UILabel]!
    
    let defaults = UserDefaults.standard
    var cardDataAndLogic: CardDataAndLogic? ///ほかのViewControllerから送られてくる.
    var defaultLastCardNumber: Int {
        get {
            return cardDataAndLogic!.allWordsInTextBook_Data!.count
        }
    }
    
    var lastCardNumberHasBeenNeverEditted = true ///いつも〜枚学習するの数値は, lastCardNumberTextField が未編集のとき, のみ initalCardNumberTextField の数値から lastCardNumber を計算しlastCardNumberTextField の数値を書き換える. 「学習を開始する」ボタンが押されてから lastCabrdNumberTextField が未編集のときこの変数は true になる.
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//            outputText.text = inputText.text
            self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ///picker の delegate, dataSource を設定
        modePicker.delegate = self
        modePicker.dataSource = self
        defaultModePicker.delegate = self
        defaultModePicker.dataSource = self
        ///textField の delegate を設定
        initalCardNumberTextFieild.delegate = self
        lastCardNumberTextField.delegate = self
        maxReturnCardsQuantityTextField.delegate = self
        usualLearningCardsQuantityTextField.delegate = self
        //二つの picker を初期状態にセットする.
        if let safeDefaultModeNumber = defaults.value(forKey: "defaultModeNumber") as? Int {
            modePicker.selectRow(safeDefaultModeNumber, inComponent: 0, animated: false)
            defaultModePicker.selectRow(safeDefaultModeNumber, inComponent: 0, animated: false)
        } else {
            modePicker.selectRow(0, inComponent: 0, animated: false) ///Level.1に設定
            defaultModePicker.selectRow(0, inComponent: 0, animated: false) ///Level.1に設定
        }
        ///「〜枚で復習モードに入る」の前の textField に初期値を書き込む
        if let m = defaults.value(forKey: "maxReturnCardQuantity") as? Int {
            maxReturnCardsQuantityTextField.text = String(m)
        } else {
            maxReturnCardsQuantityTextField.text = String(5)
        }
        
        ///「いつも〜枚学習する」の textField に初期値を書き込む
        if let x = defaults.value(forKey: "usualLearningCardsQuantity") as? Int {
            if x != 0 {
                print("LVC_ ch1")
                usualLearningCardsQuantityTextField.text = String(x)
            } else {
                print("LVC_ ch2")
                usualLearningCardsQuantityTextField.text = ""
            }
        } else { /// userDefaults にデータが入っていないとき
///以下の20は usualLearningCardsQuantity の超初期値.
            if cardDataAndLogic!.allWordsInTextBook_Data!.count <= 50 {
                print("LVC_ ch3")
                usualLearningCardsQuantityTextField.text = String(cardDataAndLogic!.allWordsInTextBook_Data!.count)
            } else {
                print("LVC_ ch4")
                usualLearningCardsQuantityTextField.text = String(cardDataAndLogic!.allWordsInTextBook_Data!.count / 2)
            }
        }
        
        //外観を設定
        makeInitialInterface()
        keyboardBar() ///キーボードの toolBar を作成する.
    }
    
}

//MARK: - UITextFiewldDelegate

extension LaunchViewController: UITextFieldDelegate {
    /// textfieldがタップされてfirstresponderになる前にこのメソッドを呼び出す。trueを返すと編集ができるようになる
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    /// ユーザーがclearボタンを押したときにこのメソッドを呼び出す。trueを返すと textfield内のテキストを全て消去する
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    /// textfield が firstresponder の役割を終える直前にこのメソッドを呼び出す。trueを返すと役割を終える。
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        ///ここでは textField 上の注意書きのラベルに関する処理だけ行う.
//        ///textFieldに入力された値は「スタート」ボタンが押された時に取得して
//        /// CardDataAndLogic のインスタンスに格納する
//        /// ただし maxReturnCardNumber は このメソッド内で userDefault に保存する.
//        ///  ついでに. defaultModePicker の情報は pickerView の delegate メソッド内で保存する.
        var i = Int(initalCardNumberTextFieild.text!)
        let l = Int(lastCardNumberTextField.text!) ///〜番までの前の入力を取得
        let x = Int(usualLearningCardsQuantityTextField.text!)
        let m = Int(maxReturnCardsQuantityTextField.text!) ///〜枚で復習モード...の前の入力を取得.
        
        if textField == lastCardNumberTextField {
            lastCardNumberHasBeenNeverEditted = false
        }
        
        print("LVC_ i = \(i), l = \(l), m = \(m), maxL = \(cardDataAndLogic!.allWordsInTextBook_Data!.count)")
        print("LVC_ textField= \(textField)")
    // i も l も nil のとき
        if i == nil && l == nil {
                ///initalCardNumberTextField_NoteLabel の処理
                initalCardNumberTextField_NoteLabel.isHidden = false
                initalCardNumberTextField_NoteLabel.text = "1〜\(cardDataAndLogic!.allWordsInTextBook_Data!.count)"
                ///lastCardNumberTextField_NoteLabel の処理
                lastCardNumberTextField_NoteLabel.isHidden = false
                lastCardNumberTextField_NoteLabel.text = "1〜\(cardDataAndLogic!.allWordsInTextBook_Data!.count)"
     //i は nil でなく l が nil のとき 要変更！！
        } else if i != nil && l == nil {
            // i の値は正しい時
                if i! >= 1 && i! <= cardDataAndLogic!.allWordsInTextBook_Data!.count {
                    ///initalCardNumberTextField_NoteLabel の処理
                    initalCardNumberTextField_NoteLabel.isHidden = true
                    ///lastCardNumberTextField_NoteLabel の処理
                    lastCardNumberTextField_NoteLabel.isHidden = false
                    lastCardNumberTextField_NoteLabel.text = "\(i!)〜\(cardDataAndLogic!.allWordsInTextBook_Data!.count)"
            // i の値が正しくないとき
                } else {
                    ///initalCardNumberTextField_NoteLabel の処理
                    initalCardNumberTextField_NoteLabel.isHidden = false
                    initalCardNumberTextField_NoteLabel.text = "1〜\(cardDataAndLogic!.allWordsInTextBook_Data!.count)の値を入力して"
                    ///lastCardNumberTextField_NoteLabel の処理
                    lastCardNumberTextField_NoteLabel.isHidden = false
                    lastCardNumberTextField_NoteLabel.text = "1〜\(cardDataAndLogic!.allWordsInTextBook_Data!.count)"
                }

    // i が nil で l は nil でないとき
        } else if i == nil && l != nil {
                ///initalCardNumberTextField_NoteLabel の処理
                initalCardNumberTextField_NoteLabel.isHidden = false
                initalCardNumberTextField_NoteLabel.text = "1〜\(cardDataAndLogic!.allWordsInTextBook_Data!.count)"
            // l の数値が正しいとき
                if l! >= 1 && l! <= cardDataAndLogic!.allWordsInTextBook_Data!.count {
                    ///lastCardNumberTextField_NoteLabel の処理
                    lastCardNumberTextField_NoteLabel.isHidden = true
            // l の数値が正しくないとき
                } else {
                    lastCardNumberTextField_NoteLabel.isHidden = false
                    lastCardNumberTextField_NoteLabel.text = "1〜\(cardDataAndLogic!.allWordsInTextBook_Data!.count)の数を入力して"
                }
    // i も l も nil でない
        } else {
            // i の値は正しい時
                if i! >= 1 && i! <= cardDataAndLogic!.allWordsInTextBook_Data!.count {
                    ///initalCardNumberTextField_NoteLabel の処理
                    initalCardNumberTextField_NoteLabel.isHidden = true
                // l の値は正しいとき
                    ///usualLearningCardQuantity を使うかを判断
                    if l! >= i! && l! <= cardDataAndLogic!.allWordsInTextBook_Data!.count {
                        if textField == initalCardNumberTextFieild &&
                            lastCardNumberHasBeenNeverEditted == true &&
                            x != nil && x != 0 {
                            ///使う場合, 足したものが defaultLastCardNumber を越えないかチェックする
                            if i! + x! - 1 < defaultLastCardNumber {
                                lastCardNumberTextField.text = String(i! + x! - 1)
                            } else {
                                lastCardNumberTextField.text = String(defaultLastCardNumber)
                            }
                        }
                        ///lastCardNumberTextField_NoteLabel の処理
                        lastCardNumberTextField_NoteLabel.isHidden = true
                // l の値が正しくないとき
                    } else {
                        ///usualLearningCardQuantity を使うかを判断
                        if textField == initalCardNumberTextFieild &&
                            lastCardNumberHasBeenNeverEditted == true &&
                            x != nil && x != 0 {
                            ///使う場合, 足したものが defaultLastCardNumber を越えないかチェックする
                            if i! + x! - 1 < defaultLastCardNumber {
                                lastCardNumberTextField.text = String(i! + x! - 1)
                            } else {
                                lastCardNumberTextField.text = String(defaultLastCardNumber)
                            }
                        } else {
                            lastCardNumberTextField_NoteLabel.isHidden = false
                            lastCardNumberTextField_NoteLabel.text = "\(i!)〜\(cardDataAndLogic!.allWordsInTextBook_Data!.count)の値を代入して！"
                        }
                    }
            // i の値が正しくないとき
                } else {
                    ///initalCardNumberTextField_NoteLabel の処理
                    initalCardNumberTextField_NoteLabel.isHidden = false
                    initalCardNumberTextField_NoteLabel.text = "1〜\(cardDataAndLogic!.allWordsInTextBook_Data!.count)"
                // l の値が正しいとき
                    if l! >= 1 && l! <= cardDataAndLogic!.allWordsInTextBook_Data!.count {
                        ///lastCardNumberTextField_NoteLabel の処理
                        lastCardNumberTextField_NoteLabel.isHidden = true
                // l の値が正しくないとき
                    } else {
                        ///lastCardNumberTextField_NoteLabel の処理
                        lastCardNumberTextField_NoteLabel.isHidden = false
                        lastCardNumberTextField_NoteLabel.text = "1〜\(cardDataAndLogic!.allWordsInTextBook_Data!.count) の数を入力して"
                    }
                }
        }

    ///maxReturnCardsQuantityTextField_NoteLabel の処理
        if m == nil {
            maxReturnCardsQuantityTextField_NoteLabel.isHidden = false
            maxReturnCardsQuantityTextField_NoteLabel.text = "1〜の数を入力して！"
        } else if m! < 1 {
            maxReturnCardsQuantityTextField_NoteLabel.isHidden = false
            maxReturnCardsQuantityTextField_NoteLabel.text = "1〜 の数を入力して！"
        } else {
            /// maxReturnCardQuantity はここで UserDefault に保存する.
            defaults.set(m!, forKey: "maxReturnCardQuantity")
            maxReturnCardsQuantityTextField_NoteLabel.isHidden = true
        }
        
        if x == nil {
            usualLearningCardQuantityTextField_NoteLabel.isHidden = false
            usualLearningCardQuantityTextField_NoteLabel.text = "ここの機能は無効化されています"
            defaults.set(0, forKey: "usualLearningCardsQuantity")
        } else if x! < 1 {
            usualLearningCardQuantityTextField_NoteLabel.isHidden = false
            usualLearningCardQuantityTextField_NoteLabel.text = "ここの機能は無効化されています"
            defaults.set(0, forKey: "usualLearningCardsQuantity")
        } else {
            /// maxReturnCardQuantity はここで UserDefault に保存する.
            defaults.set(x!, forKey: "usualLearningCardsQuantity")
            usualLearningCardQuantityTextField_NoteLabel.isHidden = true
            usualLearningCardQuantityTextField_NoteLabel.isHidden = true
        }
        
        return true
    }
}


//MARK: - UIPickerViewDataSource
extension LaunchViewController: UIPickerViewDataSource {
    
    ///pickerView に表示するデータの列の数を与える.
    func numberOfComponents(in pickerView: UIPickerView)
    -> Int {
        return 1
    }
    
    ///pickerView に表示するデータの行の数を与える.
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int)
    -> Int {
        return 3
    }
}


//MARK: - UIPickerViewDelegate
extension LaunchViewController: UIPickerViewDelegate {
    ///pickerに表示するデータを与える
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int)
    -> String? {
        let data = ["Level.1", "Level.2", "Perfect"]
        return data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == defaultModePicker {
            /// picker が操作された時に defaultModeNumber を userDefault に保存する.
            defaults.set(row, forKey: "defaultModeNumber")
        }
    }
}

//MARK: - キーボードの toolBar を作成する関数

extension LaunchViewController {
    // Make a bar on the keyboard.
    func keyboardBar() {
        // ツールバーのインスタンスを作成
            let toolBar = UIToolbar()

        // ツールバーに配置するアイテムのインスタンスを作成
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let okButton: UIBarButtonItem = UIBarButtonItem(title: "OK", style: UIBarButtonItem.Style.plain, target: self, action: #selector(tapOkButton(_:)))
        okButton.width = 100
        let cancelButton: UIBarButtonItem = UIBarButtonItem(title: "CANCEL", style: UIBarButtonItem.Style.plain, target: self, action: #selector(tapCancelButton(_:)))

                // アイテムを配置
//                toolBar.setItems([flexibleItem, okButton, flexibleItem, cancelButton, flexibleItem], animated: true)
        toolBar.setItems([flexibleItem, okButton, flexibleItem], animated: true)

                // ツールバーのサイズを指定
                toolBar.sizeToFit()

        // テキストフィールドにツールバーを設定
        lastCardNumberTextField.inputAccessoryView = toolBar
        initalCardNumberTextFieild.inputAccessoryView = toolBar
        maxReturnCardsQuantityTextField.inputAccessoryView = toolBar
        usualLearningCardsQuantityTextField.inputAccessoryView = toolBar
    }
    
    @objc func tapOkButton(_ sender: UIButton){
           // キーボードを閉じる
           self.view.endEditing(true)
       }
       @objc func tapCancelButton(_ sender: UIButton){
           // テキストフィールドを空にする
           
       }


}

//MARK: - IBAction と最初のインターフェイスに関する関数

extension LaunchViewController {
    
    func makeInitialInterface() {
        ///「〜番から」の前の textField に初期値を書き込む
        initalCardNumberTextFieild.text = String(1)
        lastCardNumberTextField.text = String(defaultLastCardNumber)
        ///注意書きのラベルを非表示に.
        initalCardNumberTextField_NoteLabel.isHidden = true
        lastCardNumberTextField_NoteLabel.isHidden = true
        maxReturnCardsQuantityTextField_NoteLabel.isHidden = true
        usualLearningCardQuantityTextField_NoteLabel.isHidden = true
        /// TextField のキーボードを設定.
        initalCardNumberTextFieild.keyboardType = UIKeyboardType.numberPad
        lastCardNumberTextField.keyboardType = UIKeyboardType.numberPad
        maxReturnCardsQuantityTextField.keyboardType = UIKeyboardType.numberPad
        usualLearningCardsQuantityTextField.keyboardType = UIKeyboardType.numberPad
        /// 枠線を描く.
        initalCardNumberTextFieild.layer.borderWidth = 1.5
        initalCardNumberTextFieild.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        initalCardNumberTextFieild.layer.cornerRadius = 7.5
        lastCardNumberTextField.layer.borderWidth = 1.5
        lastCardNumberTextField.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lastCardNumberTextField.layer.cornerRadius = 7.5
        maxReturnCardsQuantityTextField.layer.borderWidth = 1.5
        maxReturnCardsQuantityTextField.layer.borderColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        maxReturnCardsQuantityTextField.layer.cornerRadius = 7.5
        usualLearningCardsQuantityTextField.layer.borderWidth = 1.5
        usualLearningCardsQuantityTextField.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        usualLearningCardsQuantityTextField.layer.cornerRadius = 7.5
        startButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        startButton.layer.borderWidth = 1.5
        startButton.layer.cornerRadius = 20
        borderLabels[0].addBorders(edges: [.bottom, .top], color:  #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), thickness: 0.7)
        borderLabels[1].addBorders(edges: [.bottom, .top], color:  #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), thickness: 0.7)
        borderLabels[2].addBorders(edges: [.bottom], color:  #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), thickness: 0.7)
    }
    
    
//MARK: - CertificateVC が "あなたがワンタップで学習に入れるように" LaunchVC の interface を作成する時に呼び出す変数.
/// CertificateVC が "あなたがワンタップで学習に入れるように" LaunchVC の interface を作成する時に呼び出す変数.
    func certificateVCMakeInitialInterface(_ nextLearningModeNumber: Int,
                                           _ initalCardNumber: Int,
                                           _ lastCardNumber: Int) {
        /// モードピッカーを nextLearningMode に設定
        modePicker.selectRow(nextLearningModeNumber, inComponent: 0, animated: false)
        /// defaultModePicker の初期状態を設定
        if let safeDefaultModeNumber = defaults.value(forKey: "defaultModeNumber") as? Int {
            defaultModePicker.selectRow(safeDefaultModeNumber, inComponent: 0, animated: false)
        } else {
            defaultModePicker.selectRow(0, inComponent: 0, animated: false) ///Level.1に設定
        }
        ///「〜番から」の前の textField に初期値を書き込む
        initalCardNumberTextFieild.text = String(initalCardNumber)
        lastCardNumberTextField.text = String(lastCardNumber)
    }

}
