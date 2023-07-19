//
//  Extensions.swift
//  SquikitLite
//
//  Created by Benjamin on 28/06/2023.
//

import Foundation
import UIKit



//===========================================================
// MARK: Notification.Name
//===========================================================



extension Notification.Name {
    // app become active
    static let appBecomeActive = Notification.Name("AppBecomeActive")
    // Provisions
    static let userProvisionsAdded = Notification.Name("UserProvisionsAdded")
    static let deleteUserProvision = Notification.Name("DeleteUserProvision")
    static let updateUserProvision = Notification.Name("updateUserProvision")
    // Shopping
    static let provAddedToShop = Notification.Name("ProvAddedToShop")
    static let deleteProvFromShop = Notification.Name("DeleteProvFromShop")
    static let updateProvInShop = Notification.Name("UpdateProvInShop")
    // cart
    static let provAddedToCart = Notification.Name("ProvAddedToCart")
    static let updateBadgeNumber = Notification.Name("UpdateBadgeNumber")
    // product
    static let updateProductInStock = Notification.Name("UpdateProductInStock")
    static let updateProductInShop = Notification.Name("UpdateProductInShop")
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
        return self.lowercased().folding(options: .diacriticInsensitive, locale: .none)
            .replacingOccurrences(of: "’", with: " ")
            .replacingOccurrences(of: "'", with: " ")
            .replacingOccurrences(of: " a ", with: " ")
            .replacingOccurrences(of: " au ", with: " ")
            .replacingOccurrences(of: " de ", with: " ")
            .replacingOccurrences(of: " aux ", with: " ")
            .replacingOccurrences(of: "-", with: " ")
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



//===========================================================
// MARK: UITextField
//===========================================================



extension UITextField {
    
    func addDoneOnNumericPad() {
        // create toolbar
        let keypadToolbar: UIToolbar = UIToolbar()
        // add done item
        keypadToolbar.items = [
        UIBarButtonItem(title: "OK", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.resignFirstResponder)),
        UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        ]
        keypadToolbar.sizeToFit()
        // add toolbar to textfield
        self.inputAccessoryView = keypadToolbar
    }
}



//===========================================================
// MARK: AlertButton
//===========================================================



class AlertButton {
    
    let cancel = UIAlertAction(title: NSLocalizedString("alert_cancel", comment: ""), style: .cancel)
}



//===========================================================
// MARK: UIControl
//===========================================================



extension UIControl {
    
    // pour réaliser une action en closure sur clic d'un bouton dans une cellule (collection ou tableView)
    func addTouchUpInsideAction(_ closure: @escaping()->()) {
        // on retire l'action pour éviter de s'abonner plusieurs fois
        removeAction(identifiedBy: UIAction.Identifier("ActionInCell"), for: .touchUpInside)
        // on ajoute l'action
        addAction(UIAction(identifier: UIAction.Identifier("ActionInCell"),handler: { _ in
            closure()
        }), for: .touchUpInside)
    }
}
