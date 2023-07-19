//
//  CartViewController.swift
//  SquikitLite
//
//  Created by Benjamin on 07/07/2023.
//

import UIKit



//===========================================================
// MARK: CartViewController class
//===========================================================



class CartViewController: UIViewController {
    
    // MARK: Properties
    
    static let STORYBOARD_ID = "CartViewController"
    private var o_provisionsDP = [String: [ProvisionDisplayProvider]]()
    private var o_headers = [String]()
    
    // MARK: Outlets
    
    @IBOutlet weak var cartTV: UITableView!
    @IBOutlet weak var addToProvButton: UIButton!
    @IBOutlet weak var emptyCartLabel: UILabel!
    
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
// MARK: View transitions
//===========================================================



extension CartViewController {
    
    private func dismissViewOutsideTapAction() {
        dismiss(animated: true)
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
        updateCartUI()
    }
}



//===========================================================
// MARK: Init tableView
//===========================================================



extension CartViewController {
    
    private func initTableView() {
        cartTV.register(ShoppingCell.nib, forCellReuseIdentifier: ShoppingCell.key)
        cartTV.contentInset = UIEdgeInsets(top: Dimensions.shoppingTableViewTopInset, left: 0, bottom: Dimensions.shoppingTableViewBottomInset, right: 0)
        cartTV.separatorStyle = .none
        cartTV.sectionHeaderTopPadding = Dimensions.shoppingTableViewTopInset
    }
}



//===========================================================
// MARK: Delete provision
//===========================================================



extension CartViewController {
    
    private func deleteItemFromDP(provisionDP: ProvisionDisplayProvider) {
        // on supprime du provider existant
        let result = ProvGenericMethods.deleteItemFromDP(provDP: provisionDP, toDico: &o_provisionsDP, andUpadeCategories: &o_headers)
        if let index = result.index, index.section < cartTV.numberOfSections && index.row < cartTV.numberOfRows(inSection: index.section) {
            if let sectionToDelete = result.deleteSection {
                cartTV.deleteSections(IndexSet(integer: sectionToDelete), with: .automatic)
            } else {
                cartTV.deleteRows(at: [index], with: .automatic)
            }
        } else {
            // on reload tout au cas où...
            cartTV.reloadData()
        }
        // if empty
        updateCartUI()
        
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



//===========================================================
// MARK: Update cart UI if empty
//===========================================================



extension CartViewController {
    
    private func updateCartUI() {
        if o_provisionsDP.count <= 0 {
            emptyCartLabel.isHidden = false
            addToProvButton.isHidden = true
        } else {
            emptyCartLabel.isHidden = true
            addToProvButton.isHidden = false
        }
    }
}



//===========================================================
// MARK: TableView DataSource
//===========================================================



extension CartViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return o_headers.count
    }
    
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
// MARK: TableView Delegate
//===========================================================



extension CartViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0 //Dimensions.headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Dimensions.shoppingRowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cartTV.deselectRow(at: indexPath, animated: false)
        
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
