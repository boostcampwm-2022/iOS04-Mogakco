//
//  Int+Formatter.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/22.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

extension Int {
    
    /// ex) 202212011700 ==> 2022년 12월 1일 17시 00분
    func toDateString() -> String {
        var number = self
        let date: [Int] = [100, 100, 100, 100, 10000].map {
            let remain = number % $0
            number /= $0
            return remain
        }
        
        let all = zip(date.reversed(), ["년", "월", "일", "시", "분"])
        
        let dateString = all.reduce("") { result, info in
            let (num, unit) = info
            let twoDigit = String(format: "%02d", num)
            return "\(result) \(twoDigit)\(unit)"
        }
        
        return dateString.trimmingCharacters(in: [" "])
    }
    
    /// ex) 202212011700 ==> 2022년 12월 1일 오후 5시
    func toCompactDateString() -> String {
        var number = self
        let date: [Int] = [100, 100, 100, 100, 10000].map {
            let remain = number % $0
            number /= $0
            return remain
        }
        
        let all = zip(date.reversed(), ["년", "월", "일", "시", "분"])
        
        let dateString = all.reduce("") { result, info in
            let (num, unit) = info
            if unit == "분" && num == 0 { return result }
            if unit == "시" {
                let hour = num <= 12 ? num : num - 12
                let ampm = num < 12 ? "오전" : "오후"
                return "\(result) \(ampm) \(hour)\(unit)"
            } else {
                return "\(result) \(num)\(unit)"
            }
        }
        
        return dateString.trimmingCharacters(in: [" "])
    }
    
    /// ex) 202212011700 ==> 오후 5시
    func toChatCompactDateString() -> String {
        var number = self / 100
        let date: [Int] = [100, 100].map {
            let remain = number % $0
            number /= $0
            return remain
        }
        
        let all = zip(date.reversed(), ["시", "분"])
        
        let dateString = all.reduce("") { result, info in
            let (num, unit) = info
            if unit == "분" && num == 0 { return result }
            if unit == "시" {
                let hour = num <= 12 ? num : num - 12
                let ampm = num < 12 ? "오전" : "오후"
                return "\(result) \(ampm) \(hour)\(unit)"
            } else {
                return "\(result) \(num)\(unit)"
            }
        }
        
        return dateString.trimmingCharacters(in: [" "])
    }
}
