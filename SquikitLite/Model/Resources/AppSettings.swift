//
//  AppSettings.swift
//  SquikitLite
//
//  Created by Benjamin on 28/06/2023.
//

import Foundation



//===========================================================
// MARK: AppSettings class
//===========================================================



class AppSettings {
    
    // MARK: peremption
    
    // Valeur de passage de Warning à critique
    static let ConsoLimitNowValue: Int = 2 // en jours
    // Valeur de passage de Ok à Warning
    static let ConsoLimitSoonValue: Int = 5; // en jours
    // Valeur de désactivation d'une DLC dans la péremption
    static let DLCDisablePeremption: Int = -1;
}
