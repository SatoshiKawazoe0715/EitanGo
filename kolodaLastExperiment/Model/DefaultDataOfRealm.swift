//
//  ReadDefaultData.swift
//  kolodaLastExperiment
//
//  Created by Satoshi Kawazoe on 2023/04/04.
//

import Foundation
import RealmSwift


struct DefaultDataOfRealm {
    
    lazy var realm = try! Realm()
    var wordsDataInRealm : Results<WordData>?
    var textbook : Results<Textbook>?
    let defaults = UserDefaults.standard
    var firstOpen: Bool = true
    let defaultTextbookArray = [
            [0, "MaxOriginal"]
        ]
    let dataOfMaxOriginal =
        [
            [1,"自動詞","remain","(ある状態の)ままでいる","ま",nil,nil],
            [2,"他動詞","reach","〜に達する","〜にた",nil,nil],
            [3,"他動詞","allow","〜を許可する","〜をき",nil,nil],
            [4,"他動詞","force","〜を強制する","〜をき",nil,nil],
            [5,"他動詞","offer","〜を申し出る","〜をも",nil,nil],
            [6,"他動詞","realize","〜を悟る","〜をさ",nil,nil],
            [7,"他動詞","suggest","〜を提案する","〜をて",nil,nil],
            [8,"他動詞","require","〜を要求する","〜をよ",nil,nil],
            [9,"自動詞","worry","心配する","し",nil,nil],
            [10,"他動詞","wonder","〜かと疑問に思う","〜かと",nil,nil],
        ]
    
    
    mutating func setDefaultTextbookIfFirstOpen() {
        //userDefaultに格納された変数firstOpenを確認.
        if let safeFirstOpen = defaults.value(forKey: "firstOpen") as? Bool {
            firstOpen = safeFirstOpen
        }
        
        if firstOpen != false { // firstOpen == true か nil の場合
            print("TextSelectingVC,初期データをよみこむ")
            //新しいTextbook()のインスタンスをつくり name プロパティに初期データを書き込む(今回は MaxOriginal しか存在していない。)
//            for textbookName in defaultTextbookArray {
//                let newTextbook = Textbook()
//                newTextbook.textNumber = textbookName[0] as! Int
//                newTextbook.name = textbookName[1] as! String
//                saveTextbook(textbook: newTextbook)
//
//                setDefaultWordsDataOfMaxOriginal(textbook: newTextbook) //newTextbookのwordsプロパティに初期データを追加(append)する
//                defaults.set(false, forKey: "firstOpen")
//            }
        } else {
            print("TextSelectingVC,データは既に読み込まれている")
        }
    }
    
    mutating func saveTextbook(textbook: Textbook) {
        do {
            try realm.write {
                realm.add(textbook)
            }
        } catch {
            print("error \(error)")
        }
    }
    
    mutating func setDefaultWordsDataOfMaxOriginal(textbook: Textbook) {
        do {
            try self.realm.write {
                for wordData in dataOfMaxOriginal {
                    let newWordData = WordData()
                    newWordData.wordNumber = wordData[0] as! Int
                    newWordData.hinshi = wordData[1] as! String
                    newWordData.english = wordData[2] as! String
                    newWordData.japanese = wordData[3] as! String
                    newWordData.firstHiragana = wordData[4] as! String
                    newWordData.certificatedLevel = wordData[5] as? String
                    textbook.wordsData.append(newWordData) //ここで
                }
            }
        } catch {
                print("Error saving new wordsData, \(error)")
        }
        print("TextSelectingVC,読み込んだ初期データのmaxOriginalのwordsDataの数は, \(textbook.wordsData.count)")
    }
    
    
    
    func getWordsData(textbook: Textbook) {
        
    }
}

