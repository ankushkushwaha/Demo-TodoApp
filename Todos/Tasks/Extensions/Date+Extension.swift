//
//  Date+Extension.swift
//  Tasks
//
//  Created by Ankush on 30/07/23.
//

import Foundation

extension Date {
    var string: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM YYYY"
        return dateFormatter.string(from: self)
    }
}
