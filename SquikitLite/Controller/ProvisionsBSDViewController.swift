//
//  ProvisionsBSDViewController.swift
//  SquikitLite
//
//  Created by Benjamin on 30/06/2023.
//

import UIKit



//===========================================================
// MARK: ProvisionsBSDViewController class
//===========================================================



class ProvisionsBSDViewController: UIViewController {
    
    // MARK: Properties
    
    static let STORYBOARD_ID = "ProvisionsBSDViewController"
    var o_provDisplayProvider: ProvisionDisplayProvider?
    var o_provIndexPath: IndexPath?
    private var o_newDlc: Date?
    
    // MARK: Outlets
    @IBOutlet weak var qtyTextField: UITextField!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dlcLabel: UILabel!
    
    // MARK: Actions
    
    @IBAction func lessQtyButtonTap() {
        lessQtyButtonTapAction()
    }
    
    @IBAction func moreQtyButtonTap() {
        moreQtyButtonTapAction()
    }
    
    @IBAction func changeUnitButtonTap() {
        changeUnitButtonTapAction()
    }
    
    @IBAction func editDlcButtonTap() {
        editDlcButtonTapAction()
    }
    
    @IBAction func deleteProvButtonTap() {
        deleteProvButtonTapAction()
    }
    
    @IBAction func editProvButtonTap() {
        //TODO, bouton masqué
    }
    
    @IBAction func addToShopButtonTap() {
        addToShopButtonTapAction()
    }
    
    @IBAction func dismissViewOutsideTap() {
        dismissViewOutsideTapAction()
    }
    
    @IBAction func dismissKeyboardOutsideTap(_ sender: Any) {
        dismissKeyboardOutsideTapAction()
    }
    
}



//===========================================================
// MARK: View did load
//===========================================================



extension ProvisionsBSDViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProduct()
        initTexfieldKeyboard()
    }
}



//===========================================================
// MARK: View dismiss
//===========================================================



extension ProvisionsBSDViewController {
    
    private func dismissViewOutsideTapAction() {
        dismiss(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        checkIfUpdate()
    }
}



//===========================================================
// MARK: Keyboard
//===========================================================



extension ProvisionsBSDViewController {
    
    private func initTexfieldKeyboard() {
        qtyTextField.addDoneOnNumericPad()
    }
    
    private func dismissKeyboardOutsideTapAction() {
        qtyTextField.resignFirstResponder()
    }
}



//===========================================================
// MARK: Load product
//===========================================================



extension ProvisionsBSDViewController {
    
    private func loadProduct() {
        guard let provProvider = o_provDisplayProvider else {return}
        
        // Qty and unit
        qtyTextField.text = provProvider.quantityToString
        unitLabel.text = provProvider.unit
        // Info provision
        productImageView.image = provProvider.image
        dlcLabel.text = provProvider.dlcToString
    }
    
}



//===========================================================
// MARK: Change quantity
//===========================================================



extension ProvisionsBSDViewController {
    
    private func lessQtyButtonTapAction() {
        guard var stringQty = qtyTextField.text else {return}
        if stringQty == "" {return}
        // enlève 1
        stringQty.toConvertibleString()
        guard var qty = Double(stringQty) else {return}
        qty -= 1
        
        if qty < 0 {
            qtyTextField.text = ""
        } else {
            qtyTextField.text = qty.toRoundedString
        }
        
    }
    
    private func moreQtyButtonTapAction() {
        guard var stringQty = qtyTextField.text else {return}
        if stringQty == "" {
            qtyTextField.text = "1"
            return
        }
        // on ajoute 1 à la valeur existante
        stringQty.toConvertibleString()
        guard var qty = Double(stringQty) else {return}
        qty += 1
        qtyTextField.text = qty.toRoundedString
    }
}



//===========================================================
// MARK: Change unit
//===========================================================



extension ProvisionsBSDViewController {
    
    private func changeUnitButtonTapAction() {
    }
}



//===========================================================
// MARK: Edit DLC
//===========================================================



extension ProvisionsBSDViewController {
    
    private func editDlcButtonTapAction() {
    }
}



//===========================================================
// MARK: Add to shop
//===========================================================



extension ProvisionsBSDViewController {
    
    private func addToShopButtonTapAction() {
    }
}



//===========================================================
// MARK: Update provision
//===========================================================



extension ProvisionsBSDViewController {
    
    private func checkIfUpdate() {
        // on met à jour si modification
        guard let provProvider = o_provDisplayProvider else {return}
        
        var updated = false
        
        // qty
        updated = checkQtyUpdate(provProvider: provProvider)
        // unit
        if let unit = unitLabel.text {
            if unit != provProvider.unit {
                provProvider.unit = unit
                updated = true
            }
        }
        // DLC
        if let newDlc = o_newDlc {
            provProvider.customDlc = newDlc
            updated = true
        }
        
        // Notif si update
        if updated {
            if updated, let provIndexPath = o_provIndexPath {
                ProvisionsGenericMethods.updateUserProvision(atIndexPath: provIndexPath)
            }
        }
    }
    
    private func checkQtyUpdate(provProvider: ProvisionDisplayProvider) -> Bool {
        guard var stringQty = qtyTextField.text else {return false}
        
        if stringQty == "" && provProvider.quantity >= 0 {
            // -1 pour annuler l'affichage d'une quantité
            provProvider.quantity = -1
            return true
        }
        
        stringQty.toConvertibleString()
        guard let qty = Double(stringQty) else {return false}
        
        if qty != provProvider.quantity {
            provProvider.quantity = qty
            return true
        }
        return false
    }
}



//===========================================================
// MARK: Delete provision
//===========================================================



extension ProvisionsBSDViewController {
    
    private func deleteProvButtonTapAction() {
        
        let deleteButton = UIAlertAction(title: NSLocalizedString("alert_delete", comment: ""), style: .destructive) { _ in
            guard let provProvider = self.o_provDisplayProvider else {return}
            
            ProvisionsGenericMethods.deleteUserProvision(ofProvDisplayProvider: provProvider)
            self.dismiss(animated: true)
        }
        
        let cancelButton = UIAlertAction(title: NSLocalizedString("alert_cancel", comment: ""), style: .cancel)
        
        let alert = UIAlertController(title: NSLocalizedString("alert_deleteProvTitle", comment: ""), message: "", preferredStyle: .actionSheet)
        alert.addAction(deleteButton)
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
}
