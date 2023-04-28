//
//  DateBrain.swift
//  kolodaLastExperiment
//
//  Created by Satoshi Kawazoe on 2023/04/17.
//

import Foundation

struct DataBrain {
    
    func fetchData(_ from: String) -> String {
        let date = Date() // May 4, 2020, 11:36 AM
        let cal = Calendar.current
        let comp = cal.dateComponents(
            [Calendar.Component.year, Calendar.Component.month, Calendar.Component.day,
             Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second],
             from: date)
        if from == "Certificate" {
            return "\(comp.year ?? 0).\(comp.month ?? 0).\(comp.day ?? 0)"
        } else if from == "Realm" {
            return "\(comp.year! - 2000)/\(comp.month ?? 0)/\(comp.day ?? 0)"
        } else {
            return "Error"
        }
    }
}
