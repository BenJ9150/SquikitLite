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
    let pickerView = UIPickerView(frame: CGRect.zero)
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
        //let pickerView = UIPickerView(frame: CGRect.zero)
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // add cancel button and picker
        addAction(UIAlertAction.cancelButton)
        view.addSubview(pickerView)
        
        // picker contraintes
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        pickerView.leadingAnchor.constraint(equalTo: view.subviews[0].leadingAnchor, constant: 16).isActive = true
        pickerView.centerXAnchor.constraint(equalTo: view.subviews[0].centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: view.subviews[0].centerYAnchor).isActive = true
        
        // select row
        if let unit =  o_selectedUnit {
            pickerView.selectRow(ProductsGenericMethods.getUnitRow(ofUnit: unit), inComponent: 0, animated: false)
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
        return ProductsGenericMethods.getUnitsCount()
    }
}



//===========================================================
// MARK: UIPickerViewDelegate
//===========================================================



extension UnitsAlertController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ProductsGenericMethods.getUnit(ofRow: row)
    }
}
