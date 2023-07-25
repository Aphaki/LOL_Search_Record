//
//  Double.swift
//  LOL_Search_Record
//
//  Created by Sy Lee on 2023/07/25.
//

import Foundation

extension Double {
    func unixToMyString() -> String {
        let unixTime = self
        let myYears = unixTime / 60 / 60 / 24 / 30 / 12
        let myMonths = unixTime / 60 / 60 / 24 / 30
        let myDays =  unixTime / 60 / 60 / 24
        let myHours =  unixTime / 60 / 60
        let myMinutes =  unixTime / 60
        if myYears > 50 {
            return "오래전"
        } else if myYears > 1 {
            return "\(Int(myYears))년전"
        } else if myMonths > 1 {
            return "\(Int(myMonths))달전"
        } else if myDays > 1 {
            return "\(Int(myDays))일전"
        } else if myHours > 1 {
            return "\(Int(myHours))시간전"
        } else if myMinutes > 1 {
            return "\(Int(myMinutes))분전"
        } else {
            return "\(Int(unixTime))초전"
        }
    }
}
