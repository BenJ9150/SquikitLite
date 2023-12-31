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
    
    // MARK: Common Outlets
    
    @IBOutlet weak var qtyTextField: UITextField!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var deleteProvLabel: UILabel!
    
    // MARK: Outlets prov
    
    @IBOutlet weak var addToShopButton: UIButton!
    @IBOutlet weak var addToShopLabel: UILabel!
    @IBOutlet weak var dlcViewFromShop: UIView!
    @IBOutlet weak var dlcLabel: UILabel!
    
    // MARK: Outlets shop
    
    @IBOutlet weak var dlcViewFromProv: UIView!
    @IBOutlet weak var estimateDlcLabel: UILabel!
    @IBOutlet weak var addToShopButtonView: UIStackView!
    
    // MARK: Common Actions
    
    @IBAction func lessQtyButtonTap() {
        lessQtyButtonTapAction()
    }
    
    @IBAction func moreQtyButtonTap() {
        moreQtyButtonTapAction()
    }
    
    @IBAction func changeUnitButtonTap() {
        changeUnitButtonTapAction()
    }
    
    @IBAction func deleteProvButtonTap() {
        deleteProvButtonTapAction()
    }
    
    @IBAction func editProvButtonTap() {
        //TODO, bouton masqué
    }
    
    @IBAction func dismissViewOutsideTap() {
        dismissViewOutsideTapAction()
    }
    
    @IBAction func dismissKeyboardOutsideTap(_ sender: Any) {
        dismissKeyboardOutsideTapAction()
    }
    
    // MARK: Actions prov
    
    @IBAction func addToShopButtonTap() {
        addToShopButtonTapAction()
    }
    
    @IBAction func editDlcButtonTap() {
        editDlcButtonTapAction()
    }
    
    // MARK: Actions shop
    
    @IBAction func editEstimateDlcButtonTap() {
        editDlcButtonTapAction()
    }
    
    @IBAction func lessDlcButtonTap() {
        lessDlcButtonTapAction()
    }
    
    @IBAction func moreDlcButtonTap() {
        moreDlcButtonTapAction()
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
        
        // on formatte en fonction de l'appelant
        guard let state = provProvider.state else {return}
        if state == .inStock {
            //DLC
            dlcViewFromProv.isHidden = false
            dlcViewFromShop.isHidden = true
            dlcLabel.text = provProvider.dlcToString
            // add to shop button
            addToShopButtonView.isHidden = false
            guard let productId = provProvider.product?.Id else {return}
            if ProvGenericMethods.checkIfProductAlreadyAdded(fromId: productId, withState: .inShopOrCart) {
                addToShopButton.isEnabled = false
                addToShopLabel.text = NSLocalizedString("bsdProv_shopButtonDisabled", comment: "")
            } else {
                addToShopButton.isEnabled = true
                addToShopLabel.text = NSLocalizedString("bsdProv_shopButtonEnabled", comment: "")
            }
            // Delete button
            deleteProvLabel.text = NSLocalizedString("bsdProv_deleteButtonFromStock", comment: "")
            return
        }
        
        // on vient des courses
        //DLC
        dlcViewFromProv.isHidden = true
        dlcViewFromShop.isHidden = false
        estimateDlcLabel.text = provProvider.dlcToString
        // add to shop button
        addToShopButtonView.isHidden = true
        // Delete button
        deleteProvLabel.text = NSLocalizedString("bsdProv_deleteButtonFromShop", comment: "")
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
        guard let state = provProvider.state else {return}
        
        // vérif si product en stock si on vient des courses
        if state == .inShop {
            if let productId = provProvider.product?.Id, ProvGenericMethods.checkIfProductAlreadyAdded(fromId: productId, withState: .inStock) {
                alertProductExistInStock(selectedUnitIfOk: provProvider.unit)
            }
        }
        
        // show alert unit choice
        showUnitChoiceAlert(withSelectedUnit: provProvider.unit)
    }
    
    private func alertProductExistInStock(selectedUnitIfOk selectedUnit: String) {
        let alert = UIAlertController(title: NSLocalizedString("alert_modifProductInStockTitle", comment: ""), message: NSLocalizedString("alert_modifProductInStockInfo", comment: ""), preferredStyle: .alert)
        
        // edit provision button
        let editButton = UIAlertAction(title: NSLocalizedString("alert_continue", comment: ""), style: .default) { _ in
            self.showUnitChoiceAlert(withSelectedUnit: selectedUnit)
        }
        
        alert.addAction(editButton)
        alert.addAction(AlertButton().cancel)
        present(alert, animated: true)
    }
    
    private func showUnitChoiceAlert(withSelectedUnit selectedUnit: String) {
        let alertUnits = UnitsAlertController(title: NSLocalizedString("alert_chooseUnitTitle", comment: ""), message: "", preferredStyle: .alert)
        alertUnits.o_selectedUnit = selectedUnit
        
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
        guard let state = provProvider.state else {return}
        
        let alertDLC = DlcAlertController(title: NSLocalizedString("alert_changeDlcTitle", comment: ""), message: "", preferredStyle: .alert)
        alertDLC.o_dateToDisplay = provProvider.dlc
        
        // ok button
        let okButton = UIAlertAction(title: NSLocalizedString("alert_choose", comment: ""), style: .default) { _ in
            self.o_newDlc = alertDLC.o_datePicker.date
            // maj IHM
            if state == .inStock {
                self.dlcLabel.text = ProvGenericMethods.dlcToString(fromDLC: self.o_newDlc)
            } else {
                self.estimateDlcLabel.text = ProvGenericMethods.dlcToString(fromDLC: self.o_newDlc)
            }
        }
        
        alertDLC.addAction(okButton)
        present(alertDLC, animated: true)
    }
}



//===========================================================
// MARK: Adjust DLC with buttons
//===========================================================



extension ProvisionsBSDViewController {
    
    private func lessDlcButtonTapAction() {
        addOrRemoveDayToDlc(value: -1)
    }
    
    private func moreDlcButtonTapAction() {
        addOrRemoveDayToDlc(value: 1)
    }
    
    private func addOrRemoveDayToDlc(value: Int) {
        // si dlc déjà changé, on modifie à partir de o_newDLC
        if let currentDlc = o_newDlc {
            if let newDlc = Calendar.current.date(byAdding: .day, value: value, to: currentDlc) {
                o_newDlc = newDlc
                // maj IHM
                estimateDlcLabel.text = ProvGenericMethods.dlcToString(fromDLC: o_newDlc)
                return
            }
        }
        // on modifie par rapport à la dlc originale
        guard let provProvider = o_provisionDP else {return}
        guard let dlc = provProvider.dlc else {return}
        if let newDlc = Calendar.current.date(byAdding: .day, value: value, to: dlc) {
            o_newDlc = newDlc
            // maj IHM
            estimateDlcLabel.text = ProvGenericMethods.dlcToString(fromDLC: o_newDlc)
        }
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
        
        if ProvGenericMethods.addNewProvision(fromProduct: product, withState: .inShop) {
            // animation ajout aux courses
            addToShopLabel.text = NSLocalizedString("bsdProv_provAddedToShop", comment: "")
            addToShopButton.isEnabled = false
            addToShopLabel.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5) {
                self.addToShopLabel.transform = .identity
            } completion: { _ in
                self.dismiss(animated: true)
            }
            
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
        guard let state = provProvider.state else {return}
        var provUpdated = false
        var productUpdated = false
        
        // qty
        provUpdated = checkQtyUpdate(provProvider: provProvider)
        // unit
        if let unit = unitLabel.text {
            if unit != provProvider.unit {
                provProvider.unit = unit
                provUpdated = true
                productUpdated = true
            }
        }
        
        // DLC
        if let newDlc = o_newDlc {
            provProvider.dlc = newDlc
            provUpdated = true
        }
        
        // notif si update provision
        guard let provIndexPath = o_provIndexPath else {return}
        if provUpdated {
            if state == .inStock {
                NotificationCenter.default.post(name: .updateUserProvision, object: provIndexPath)
            } else {
                NotificationCenter.default.post(name: .updateProvInShop, object: provIndexPath)
            }
        }
        // notif si update product
        if productUpdated {
            if state == .inStock {
                NotificationCenter.default.post(name: .updateProductInShop, object: nil)
            } else {
                NotificationCenter.default.post(name: .updateProductInStock, object: nil)
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
        guard let provProvider = self.o_provisionDP else {return}
        guard let state = provProvider.state else {return}
        
        let mess: String
        if state == .inStock {
            mess = NSLocalizedString("alert_deleteProvFromStockTitle", comment: "")
        } else {
            mess = NSLocalizedString("alert_deleteProvFromShopTitle", comment: "")
        }
        
        let alert = UIAlertController(title: mess, message: "", preferredStyle: .actionSheet)
        
        // delete provision button
        let deleteButton = UIAlertAction(title: NSLocalizedString("alert_delete", comment: ""), style: .destructive) { _ in
            
            if state == .inStock {
                NotificationCenter.default.post(name: .deleteUserProvision, object: provProvider)
            } else {
                NotificationCenter.default.post(name: .deleteProvFromShop, object: provProvider)
            }
            self.dismiss(animated: true)
        }
        
        alert.addAction(deleteButton)
        alert.addAction(AlertButton().cancel)
        present(alert, animated: true)
    }
}
