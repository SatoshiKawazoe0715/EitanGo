//
//  LearningWordDataArrays.swift
//  kolodaLastExperiment
//
//  Created by Satoshi Kawazoe on 2023/04/12.
//

import Foundation

struct kolodaData {
    
    var selectedTextbook: Textbook?  ///1_Realmに保管されている、今回学習するテキストのデータ
    var selectedLevel: String = "Level.1"  ///2_学習するモード
    var initialCardNumber: Int = 0  ///3_学習する最初のカードの番号
    var lastCardNumber: Int = 0  ///4_学習する最後のカードの番号
    var cardQuantity: Int = 0  ///5_学習するカードの枚数
    var progressNumber: Int = 0
    var returnCardQuantity: Int = 0
    var certificatedCardQuantity: Int = 0
    var returningMode: Bool = false
    var seeTipButtonIsTapped: Bool = false
    var failPerfectMode: Bool = false
    var maxReturnCardsQuantity: Int = 1 ///6_何枚で復習モードに入るかを決める整数
    var mainWordsDataArray:[WordData] = []/// kolodaViwe を作るのに使うデータの配列.
    var backupWordsDataArray:[WordData] = [] /// 復習モードから復活する時に kolodaView を作るのに使うデータの配列.
    var repeatWordsDataArray:[WordData] = [] /// 復習モード時に kolodaView を作るのに使うデータの配列.
    var certificatedWordsDataArray:[WordData] = [] /// 記録をつける単語のデータの配列.
}
