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
    var o_provisionDP: ProvisionDisplayProvider?
    var o_provIndexPath: IndexPath?
    private var o_newDlc: Date?
    
    // MARK: Outlets
    @IBOutlet weak var qtyTextField: UITextField!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dlcLabel: UILabel!
    @IBOutlet weak var addToShopButton: UIButton!
    
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
        guard let provProvider = o_provisionDP else {return}
        
        // Qty and unit
        qtyTextField.text = provProvider.quantityToString
        unitLabel.text = provProvider.unit
        // Info provision
        productImageView.image = provProvider.image
        nameLabel.text = provProvider.name
        dlcLabel.text = provProvider.dlcToString
        
        // check if already in shop
        guard let productId = provProvider.product?.Id else {return}
        if ProvisionGenericMethods.checkIfProductAlreadyAdded(fromId: productId, withState: .inShopOrCart) {
            addToShopButton.isEnabled = false
        }
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
        guard let provProvider = o_provisionDP else {return}
        
        // create alert
        let alertUnits = UnitsAlertController(title: NSLocalizedString("alert_chooseUnitTitle", comment: ""), message: "", preferredStyle: .alert)
        alertUnits.o_selectedUnit = provProvider.unit
        
        // ok button
        let okButton = UIAlertAction(title: NSLocalizedString("alert_choose", comment: ""), style: .default) { _ in
            let newUnit = ProductGenericMethods.getUnit(ofRow: alertUnits.o_pickerView.selectedRow(inComponent: 0))
            if newUnit != "" {
                self.unitLabel.text = newUnit
            }
        }
        
        alertUnits.addAction(okButton)
        present(alertUnits, animated: true)
    }
}



//===========================================================
// MARK: Edit DLC
//===========================================================



extension ProvisionsBSDViewController {
    
    private func editDlcButtonTapAction() {
        guard let provProvider = o_provisionDP else {return}
        
        let alertDLC = DlcAlertController(title: NSLocalizedString("alert_changeDlcTitle", comment: ""), message: "", preferredStyle: .alert)
        alertDLC.o_dateToDisplay = provProvider.dlc
        
        // ok button
        let okButton = UIAlertAction(title: NSLocalizedString("alert_choose", comment: ""), style: .default) { _ in
            self.o_newDlc = alertDLC.o_datePicker.date
            // maj IHM
            self.dlcLabel.text = ProvisionGenericMethods.dlcToString(fromDLC: self.o_newDlc)
        }
        
        alertDLC.addAction(okButton)
        present(alertDLC, animated: true)
    }
}



//===========================================================
// MARK: Alert remove DLC
//===========================================================



extension ProvisionsBSDViewController {
    
    private func removeDlcButtonTapAction() {
        let alert = UIAlertController(title: NSLocalizedString("alert_removeDlcTitle", comment: ""), message: "", preferredStyle: .actionSheet)
        
        let deleteButton = UIAlertAction(title: NSLocalizedString("alert_delete", comment: ""), style: .destructive) { _ in
            // TO DO
            self.dismiss(animated: true)
        }
        
        alert.addAction(deleteButton)
        alert.addAction(AlertButton().cancel)
        present(alert, animated: true)
    }
}

//===========================================================
// MARK: Add to shop
//===========================================================



extension ProvisionsBSDViewController {
    
    private func addToShopButtonTapAction() {
        guard let product = o_provisionDP?.product else {return}
        
        if ProvisionGenericMethods.addNewProvision(fromProduct: product, withState: .inShop) {
            dismiss(animated: true)
            return
        }
        let alert = UIAlertController(title: NSLocalizedString("alert_provAlreadyInShop", comment: ""), message: "", preferredStyle: .alert)
        let okButton = UIAlertAction(title: NSLocalizedString("alert_ok", comment: ""), style: .cancel) { _ in
            self.dismiss(animated: true)
        }
        alert.addAction(okButton)
        present(alert, animated: true)
    }
}



//===========================================================
// MARK: Update provision
//===========================================================



extension ProvisionsBSDViewController {
    
    private func checkIfUpdate() {
        // on met à jour si modification
        guard let provProvider = o_provisionDP else {return}
        
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
            provProvider.dlc = newDlc
            updated = true
        }
        
        // Notif si update
        if updated {
            if updated, let provIndexPath = o_provIndexPath {
                NotificationCenter.default.post(name: .updateUserProvision, object: provIndexPath)
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
        let alert = UIAlertController(title: NSLocalizedString("alert_deleteProvTitle", comment: ""), message: "", preferredStyle: .actionSheet)
        
        // delete provision button
        let deleteButton = UIAlertAction(title: NSLocalizedString("alert_delete", comment: ""), style: .destructive) { _ in
            guard let provProvider = self.o_provisionDP else {return}
            NotificationCenter.default.post(name: .deleteUserProvision, object: provProvider)
            self.dismiss(animated: true)
        }
        
        alert.addAction(deleteButton)
        alert.addAction(AlertButton().cancel)
        present(alert, animated: true)
    }
}
