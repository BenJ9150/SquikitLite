//
//  UnitsAlertController.swift
//  SquikitLite
//
//  Created by Benjamin on 01/07/2023.
//

import UIKit



//===========================================================
// MARK: UnitsAlertController class
//===========================================================



class UnitsAlertController: UIAlertController {
    
    // MARK: Properties
    
    var o_selectedUnit: String?
    let o_pickerView = UIPickerView(frame: CGRect.zero)
}



//===========================================================
// MARK: View did load
//===========================================================



extension UnitsAlertController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButtonsAndPicker()
    }
}



//===========================================================
// MARK: Add buttons and picker
//===========================================================



extension UnitsAlertController {
    
    private func addButtonsAndPicker() {
        // picker view
        o_pickerView.delegate = self
        o_pickerView.dataSource = self
        
        // change message for space
        message = "\n\n\n\n\n\n\n\n\n\n"
        
        // add cancel button and picker
        addAction(AlertButton().cancel)
        view.addSubview(o_pickerView)
        
        // picker contraintes
        o_pickerView.translatesAutoresizingMaskIntoConstraints = false
        o_pickerView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        o_pickerView.leadingAnchor.constraint(equalTo: view.subviews[0].leadingAnchor, constant: 16).isActive = true
        o_pickerView.centerXAnchor.constraint(equalTo: view.subviews[0].centerXAnchor).isActive = true
        o_pickerView.centerYAnchor.constraint(equalTo: view.subviews[0].centerYAnchor).isActive = true
        
        // select row
        if let unit =  o_selectedUnit {
            o_pickerView.selectRow(ProductGenericMethods.getUnitRow(ofUnit: unit), inComponent: 0, animated: false)
        }
    }
}



//===========================================================
// MARK: UIPickerViewDataSource
//===========================================================




extension UnitsAlertController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ProductGenericMethods.getUnitsCount()
    }
}



//===========================================================
// MARK: UIPickerViewDelegate
//===========================================================



extension UnitsAlertController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ProductGenericMethods.getUnit(ofRow: row)
    }
}
