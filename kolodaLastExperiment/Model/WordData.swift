//
//  DefaultWordsData.swift
//  kolodaLastExperiment
//
//  Created by Satoshi Kawazoe on 2023/02/21.
//

import Foundation
import RealmSwift

class WordData: Object {
    @objc dynamic var wordNumber: Int = 0 ///単語に割り振られた番号
    @objc dynamic var hinshi: String = "" ///単語の品詞
    @objc dynamic var english: String = "" ///単語
    @objc dynamic var japanese: String = "" ///単語の日本語訳
    @objc dynamic var firstHiragana: String = "" ///日本語訳の最初の一文字目
    @objc dynamic var certificatedLevel: String? ///Level.0, Level.1, Level.2, Perfect. Specialist
    @objc dynamic var certificatedDate: String? ///certificate が発行された日付.
    
    var parentTextbook = LinkingObjects(fromType: Textbook.self, property: "wordsData")
}

