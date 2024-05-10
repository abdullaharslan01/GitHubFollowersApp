//
//  Date+Ext.swift
//  GHFollowersApp
//
//  Created by abdullah on 9.05.2024.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        
        return dateFormatter.string(from: self)
    }
    
    
}
