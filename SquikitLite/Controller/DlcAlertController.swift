//
//  DlcAlertController.swift
//  SquikitLite
//
//  Created by Benjamin on 01/07/2023.
//

import UIKit



//===========================================================
// MARK: DlcAlertController class
//===========================================================



class DlcAlertController: UIAlertController {

    // MARK: Properties
    
    var o_dateToDisplay: Date?
    let o_datePicker = UIDatePicker(frame: CGRect.zero)
}



//===========================================================
// MARK: View did load
//===========================================================



extension DlcAlertController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButtonsAndPicker()
    }
}



//===========================================================
// MARK: Add buttons and picker
//===========================================================



extension DlcAlertController {
    
    private func addButtonsAndPicker() {
        // picker pattern
        o_datePicker.datePickerMode = .date
        o_datePicker.preferredDatePickerStyle = .inline
        
        // change message for space
        message = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
        
        // add cancel button and picker
        addAction(AlertButton().cancel)
        view.addSubview(o_datePicker)
        
        // picker contraintes
        o_datePicker.translatesAutoresizingMaskIntoConstraints = false
        //o_datePicker.heightAnchor.constraint(equalToConstant: 180).isActive = true
        o_datePicker.leadingAnchor.constraint(equalTo: view.subviews[0].leadingAnchor, constant: 0).isActive = true
        o_datePicker.centerXAnchor.constraint(equalTo: view.subviews[0].centerXAnchor).isActive = true
        o_datePicker.centerYAnchor.constraint(equalTo: view.subviews[0].centerYAnchor).isActive = true
        
        // select row
        if let date =  o_dateToDisplay {
            o_datePicker.setDate(date, animated: false)
        }
    }
}
