//
//  FoundationExtensions.swift
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
    static let userProvisionUpdated = Notification.Name("UserProvisionUpdated")
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
    
    mutating func toConvertibleString() {
        self = self.replacingOccurrences(of: ",", with: ".")
    }
}



//===========================================================
// MARK: Double
//===========================================================



extension Double {
    
    var toRoundedString: String {
        /*
        let roundedQty = self.rounded()
        if roundedQty == self {
            return "\(self.formatted(.number.precision(.fractionLength(0))))"
        } else {
            return "\(self.formatted(.number.precision(.fractionLength(1))))"
        }
         */
        
        let roundedQty = self.rounded()
        if roundedQty == self {
           // pas de virgule
            return String(format: "%.0f", self)
            
        } else {
            if let language = Locale.current.language.languageCode?.identifier, language == "fr" {
                return String(format: "%.1f", self).replacingOccurrences(of: ".", with: ",")
            }
            return String(format: "%.1f", self)
        }
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




