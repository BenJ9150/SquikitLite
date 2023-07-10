//
//  CartViewController.swift
//  SquikitLite
//
//  Created by Benjamin on 07/07/2023.
//

import UIKit



//===========================================================
// MARK: ProvisionsBSDViewController class
//===========================================================



class CartViewController: UIViewController {
    
    // MARK: Properties
    
    static let STORYBOARD_ID = "CartViewController"
    private var o_provisionsDP = [String: [ProvisionDisplayProvider]]()
    private var o_headers = [String]()
    
    // MARK: Outlets
    
    @IBOutlet weak var shoppingTableView: UITableView!
    @IBOutlet weak var addToProvButton: UIButton!
    
    // MARK: Actions
    
    @IBAction func addToProvButtonTap() {
        addToShopButtonTapAction()
    }
    
    @IBAction func dismissViewOutsideTap() {
        dismissViewOutsideTapAction()
    }
}



//===========================================================
// MARK: View did load
//===========================================================



extension CartViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get user provisions
        getCartProvisions()
        
        // tableView des provisions
        initTableView()
        
        // elevation button
        addToProvButton.addLargeShadow()
    }
}



//===========================================================
// MARK: View dismiss
//===========================================================



extension CartViewController {
    
    private func dismissViewOutsideTapAction() {
        dismiss(animated: true)
    }
}



//===========================================================
// MARK: View transitions
//===========================================================



extension CartViewController {
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        if isViewLoaded {
            shoppingTableView.reloadData()
        }
    }
}



//===========================================================
// MARK: Add to provisions
//===========================================================



extension CartViewController {
    
    private func addToShopButtonTapAction() {
        // on change l'état des provisions
        ProvGenericMethods.addProvsFromCart(fromProvisionsDP: o_provisionsDP)
        // on notifie pour mettre à jour le badge
        NotificationCenter.default.post(name: .updateBadgeNumber, object: nil)
        
        self.dismiss(animated: true)
    }
}



//===========================================================
// MARK: Get cart
//===========================================================



extension CartViewController {
    
    private func getCartProvisions() {
        o_provisionsDP = ProvGenericMethods.getUserProvisionsDisplayProvider(fromState: .inCart, andUpdateCategories: &o_headers)
    }
}



//===========================================================
// MARK: Init tableView
//===========================================================



extension CartViewController {
    
    private func initTableView() {
        shoppingTableView.register(ShoppingCell.nib, forCellReuseIdentifier: ShoppingCell.key)
        //shoppingTableView.register(ShoppingHeader.nib, forHeaderFooterViewReuseIdentifier: ShoppingHeader.key)
        shoppingTableView.contentInset = UIEdgeInsets(top: Dimensions.shoppingTableViewTopInset, left: 0, bottom: Dimensions.shoppingTableViewBottomInset, right: 0)
        shoppingTableView.separatorStyle = .none
        shoppingTableView.sectionHeaderTopPadding = Dimensions.shoppingTableViewTopInset
    }
}



//===========================================================
// MARK: UITableViewDataSource
//===========================================================



extension CartViewController: UITableViewDataSource {
    
    // MARK: TableView headers
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return o_headers.count
    }
    /*
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ShoppingHeader.key) as! ShoppingHeader
        guard section < o_headers.count, let firstProvInSection = o_provisionsDP[o_headers[section]]?.first else {
            headerView.headerLabel.text = ""
            return headerView
        }
        
        headerView.headerLabel.text = firstProvInSection.category
        return headerView
    }
    */
    // MARK: TableView Cell
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < o_headers.count, let provsDPInSection = o_provisionsDP[o_headers[section]] {
            return provsDPInSection.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let shoppingCell = tableView.dequeueReusableCell(withIdentifier: ShoppingCell.key, for: indexPath) as! ShoppingCell
        guard indexPath.section < o_headers.count, let provsDPInSection = o_provisionsDP[o_headers[indexPath.section]] else {return shoppingCell}
        if indexPath.row >= provsDPInSection.count {return shoppingCell}
        
        shoppingCell.productImageView.image = provsDPInSection[indexPath.row].image
        shoppingCell.nameLabel.text = provsDPInSection[indexPath.row].name
        shoppingCell.qtyAndUnitLabel.text = provsDPInSection[indexPath.row].quantityAndShoppingUnit
        shoppingCell.dlcLabel.text = provsDPInSection[indexPath.row].dlcToString
        
        if provsDPInSection[indexPath.row].quantityAndShoppingUnit == "" {
            shoppingCell.qtyAndUnitLabel.isHidden = true
        } else {
            shoppingCell.qtyAndUnitLabel.isHidden = false
        }
        
        // changement icone pour delete
        shoppingCell.addToCartButton.isEnabled = false
        
        return shoppingCell
    }
}



//===========================================================
// MARK: UITableViewDelegate
//===========================================================



extension CartViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0 //Dimensions.headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Dimensions.shoppingRowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        shoppingTableView.deselectRow(at: indexPath, animated: false)
        
        guard indexPath.section < o_headers.count, let provsDPInSection = o_provisionsDP[o_headers[indexPath.section]] else {return}
        if indexPath.row >= provsDPInSection.count {return}
        let alert = UIAlertController(title: NSLocalizedString("alert_deleteFromCart", comment: ""), message: "", preferredStyle: .actionSheet)
        
        let deleteButton = UIAlertAction(title: NSLocalizedString("alert_delete", comment: ""), style: .destructive) { _ in
            self.deleteItemFromDP(provisionDP: provsDPInSection[indexPath.row])
        }
        let putToShopButton = UIAlertAction(title: NSLocalizedString("alert_putBackToShop", comment: ""), style: .default) { _ in
            self.removeFromCartToShop(provisionDP: provsDPInSection[indexPath.row])
            self.dismiss(animated: true)
        }
        
        alert.addAction(putToShopButton)
        alert.addAction(deleteButton)
        alert.addAction(AlertButton().cancel)
        
        present(alert, animated: true)
    }
}



//===========================================================
// MARK: Delete provision
//===========================================================



extension CartViewController {
    
    private func deleteItemFromDP(provisionDP: ProvisionDisplayProvider) {
        // on supprime du provider existant
        let result = ProvGenericMethods.deleteItemFromDP(provDP: provisionDP, toDico: &o_provisionsDP, andUpadeCategories: &o_headers)
        if let indexPath = result.index {
            if let sectionToDelete = result.deleteSection {
                shoppingTableView.deleteSections(IndexSet(integer: sectionToDelete), with: .automatic)
            } else {
                shoppingTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        } else {
            // on reload tout au cas où...
            shoppingTableView.reloadData()
        }
        // on supprime des courses
        guard let uuid = provisionDP.uuid else {return}
        ProvGenericMethods.deleteProvision(fromUUID: uuid)
        // on notifie pour mettre à jour le badge
        NotificationCenter.default.post(name: .updateBadgeNumber, object: nil)
    }
}



//===========================================================
// MARK: Remove from cart to shop
//===========================================================



extension CartViewController {
    
    private func removeFromCartToShop(provisionDP: ProvisionDisplayProvider) {
        // on change l'état de la provision
        provisionDP.state = .inShop
        // on notifie pour mettre à jour le provider des courses
        NotificationCenter.default.post(name: .provAddedToShop, object: provisionDP)
        // on notifie pour mettre à jour le badge
        NotificationCenter.default.post(name: .updateBadgeNumber, object: nil)
        
        self.dismiss(animated: true)
    }
}
