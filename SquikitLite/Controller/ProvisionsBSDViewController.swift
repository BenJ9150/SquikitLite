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
    var provDisplayProvider: ProvisionDisplayProvider?
    
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
}



//===========================================================
// MARK: View did load
//===========================================================



extension ProvisionsBSDViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProduct()
    }
}



//===========================================================
// MARK: View dismiss
//===========================================================



extension ProvisionsBSDViewController {
    
    private func dismissViewOutsideTapAction() {
        dismiss(animated: true)
    }
}



//===========================================================
// MARK: Load product
//===========================================================



extension ProvisionsBSDViewController {
    
    private func loadProduct() {
        guard let provProvider = provDisplayProvider else {return}
        
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
        
    }
    private func moreQtyButtonTapAction() {
        
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
// MARK: Delete provision
//===========================================================



extension ProvisionsBSDViewController {
    
    private func deleteProvButtonTapAction() {
        
        let deleteButton = UIAlertAction(title: NSLocalizedString("alert_delete", comment: ""), style: .destructive) { _ in
            guard let provProvider = self.provDisplayProvider else {return}
            
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
