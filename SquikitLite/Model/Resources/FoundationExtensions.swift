//
//  CustomString.swift
//  SquikitLite
//
//  Created by Benjamin on 28/06/2023.
//

import Foundation



//===========================================================
// MARK: Notification.Name
//===========================================================



extension Notification.Name {
    static let userProvisionsAdded = Notification.Name("UserProvisionsAdded")
    static let userProvisionsDeleted = Notification.Name("UserProvisionsDeleted")
}



//===========================================================
// MARK: String
//===========================================================



extension String {
    
    var capitalizedSentence: String {
        if self.count < 2 {
            return self.capitalized
        }
        return self.prefix(1).capitalized + self.dropFirst().lowercased()
    }
    
    var cleanUpForComparaison: String {
        return self.lowercased().folding(options: .diacriticInsensitive, locale: .none).replacingOccurrences(of: "’", with: "'")
    }
}



//===========================================================
// MARK: Calendar
//===========================================================



extension Calendar {
    
    /// - returns: Int.max if error, or number of days
    func numberOfDaysBetween(from fromDate: Date, to toDate: Date) -> Int {
        let dateComponents = dateComponents([.day], from: startOfDay(for: fromDate), to: startOfDay(for: toDate))
        
        if let numberOfDays = dateComponents.day {
            return numberOfDays
        }
        
        return Int.max
    }
}




