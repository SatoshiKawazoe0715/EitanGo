//
//  Textbook.swift
//  kolodaLastExperiment
//
//  Created by Satoshi Kawazoe on 2023/02/22.
//

import Foundation
import RealmSwift

class Textbook: Object {
    
    @objc dynamic var textNumber: Int = 0
    @objc dynamic var name: String = ""
    
    let wordsData = List<WordData>()
    
}
