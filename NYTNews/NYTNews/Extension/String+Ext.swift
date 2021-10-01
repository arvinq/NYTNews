//
//  String+Ext.swift
//  NYTNews
//
//  Created by Arvin on 1/10/21.
//

import Foundation

extension String {
    
    /// convert string date to desired date format for output
    func convertDateFormat() -> String {
        let inDateFormatter = DateFormatter()
        inDateFormatter.timeZone = TimeZone.autoupdatingCurrent
        inDateFormatter.dateFormat = "yyyy-MM-dd"
        
        // just get the date as shown by dateFormat
        let toIndex = self.index(self.startIndex, offsetBy: 9)
        let subDate = String(self[...toIndex])
        
        let newformatDate = inDateFormatter.date(from: subDate) ?? Date()
        
        let outDateFormatter = DateFormatter()
        outDateFormatter.dateFormat = "MMM d, yyyy"
        
        return outDateFormatter.string(from: newformatDate)
    }
}
