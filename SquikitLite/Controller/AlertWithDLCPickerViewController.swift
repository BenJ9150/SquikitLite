//
//  AlertWithDLCPickerViewController.swift
//  SquikitLite
//
//  Created by Benjamin on 01/07/2023.
//

import UIKit



//===========================================================
// MARK: CoursesViewController class
//===========================================================



class AlertWithDLCPickerViewController: UIAlertController {

    // MARK: Properties
    
}



//===========================================================
// MARK: View did load
//===========================================================



extension AlertWithDLCPickerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDatePicker()
        addAlertButtons()
    }
}



//===========================================================
// MARK: Add picker view
//===========================================================



extension AlertWithDLCPickerViewController {
    
    private func addDatePicker() {
        let pickerVC = UIViewController()
        pickerVC.preferredContentSize = CGSize(width: 250,height: 300)
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
        
        //pickerView.delegate = self
        //pickerView.dataSource = self
        pickerVC.view.addSubview(datePicker)
        
        /*
        view.addSubview(datePicker)//setValue(pickerVC, forKey: "PickerViewController")
        
        let height: NSLayoutConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 300)
        view.addConstraint(height)
        */
        /*
        let dateChooserAlert = UIAlertController(title: "Choose date...", message: nil, preferredStyle: .actionSheet)
        dateChooserAlert.view.addSubview(datePicker)
        dateChooserAlert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: { action in
                // Your actions here if "Done" clicked...
            }))
        let height: NSLayoutConstraint = NSLayoutConstraint(item: dateChooserAlert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 300)
        dateChooserAlert.view.addConstraint(height)
        self.present(dateChooserAlert, animated: true, completion: nil)
         */
    }
}



//===========================================================
// MARK: Add buttons
//===========================================================



extension AlertWithDLCPickerViewController {
    
    private func addAlertButtons() {
        // remove DLC button
        let removeDlcButton = UIAlertAction(title: NSLocalizedString("alert_removeDLC", comment: ""), style: .destructive) { _ in
            self.dismiss(animated: true)
        }
        addAction(removeDlcButton)
        addAction(UIAlertAction.cancelButton)
    }
}



//===========================================================
// MARK: Remove DLC
//===========================================================



extension AlertWithDLCPickerViewController {
    
    private func deleteProvButtonTapAction() {
        
        let deleteButton = UIAlertAction(title: NSLocalizedString("alert_delete", comment: ""), style: .destructive) { _ in
            // TO DO
            self.dismiss(animated: true)
        }
        
        let cancelButton = UIAlertAction(title: NSLocalizedString("alert_cancel", comment: ""), style: .cancel)
        
        let alert = UIAlertController(title: NSLocalizedString("alert_removeDlcTitle", comment: ""), message: "", preferredStyle: .actionSheet)
        alert.addAction(deleteButton)
        alert.addAction(cancelButton)
        
        present(alert, animated: true)
    }
}
