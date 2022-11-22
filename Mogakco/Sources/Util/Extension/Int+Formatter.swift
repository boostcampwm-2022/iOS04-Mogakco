//
//  Int+Formatter.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/22.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

extension Int {
    
    func toDateString() -> String {
        
        var date = self
        
        var nums: [Int] = [100, 100, 100, 100, 10000].map {
            let remain = date % $0
            date /= $0
            return remain
        }
        nums.reverse()
        
        let all = zip(nums, ["년", "월", "일", "시", "분"])
        
        let dateString = all.reduce("") { result, info in
            let twoDigit = String(format: "%02d", info.0)
            return "\(result) \(twoDigit)\(info.1)"
        }
        
        return dateString.trimmingCharacters(in: [" "])
    }
}
