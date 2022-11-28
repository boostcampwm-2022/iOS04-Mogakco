//
//  String+Date.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/28.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

extension String {
    func toDate(dateFormat: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: self)
        return date
    }
}
