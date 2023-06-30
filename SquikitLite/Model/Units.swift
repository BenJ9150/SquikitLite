//
//  Units.swift
//  SquikitLite
//
//  Created by Benjamin on 30/06/2023.
//

import Foundation



//===========================================================
// MARK: Units class
//===========================================================



class Units {
    
    // MARK: Properties
    
    private var unitsTab = [String]()
    private var unitsSingPluralDico = [String: String]()
    
    var units: [String] {
        return unitsTab
    }
    
    var unitsSingPlural: [String: String] {
        return unitsSingPluralDico
    }
    
    // MARK: Singleton
    
    static let shared = Units()
    
    private init() {
        getUnitsTab()
        getUnitsSingPluralDico()
    }
}



//===========================================================
// MARK: Methods
//===========================================================



extension Units {
    
    private func getUnitsTab() {
        let unitsTabStringSequence = NSLocalizedString("unit_list", comment: "").split(separator: ",")
        for unit in unitsTabStringSequence {
            unitsTab.append(String(unit))
        }
    }
    
    private func getUnitsSingPluralDico() {
        let splitUnits = NSLocalizedString("unit_list_pluriel", comment: "").split(separator: ",")
        if splitUnits.count <= 0 {return}
        
        for value in splitUnits {
            let splitValue = value.split(separator: ":")
            if splitValue.count != 2 {continue}
            unitsSingPluralDico[String(splitValue[0])] = String(splitValue[1])
        }
    }
}
