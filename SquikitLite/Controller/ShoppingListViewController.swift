//
//  ShoppingListViewController.swift
//  SquikitLite
//
//  Created by Benjamin on 22/06/2023.
//

import UIKit



//===========================================================
// MARK: CoursesViewController class
//===========================================================



class ShoppingListViewController: UIViewController {

    // MARK: Properties
    
    private var o_tabBarTransforming = false
    private var o_tabBarIsHidden = false
    private var o_provisionsDP = [String: [ProvisionDisplayProvider]]()
    private var o_headers = [String]()
    
    // MARK: Outlets
    
    @IBOutlet weak var shoppingTV: UITableView!
    @IBOutlet weak var explainLabel: UILabel!
    
}



//===========================================================
// MARK: View did load
//===========================================================



extension ShoppingListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get user provisions
        getUserProvisions()
        
        // tableView des provisions
        initTableView()
        
        // notifications
        addNotificationObservers()
        
        // update cart badge
        updateCartBadge()
    }
}



//===========================================================
// MARK: Notifications
//===========================================================



extension ShoppingListViewController {
    
    private func addNotificationObservers() {
        // notification user provisions added
        NotificationCenter.default.addObserver(self, selector: #selector(provAddedToShop(_ :)), name: .provAddedToShop, object: nil)
        // notification user provision deleted
        NotificationCenter.default.addObserver(self, selector: #selector(deleteProvFromShop(_ :)), name: .deleteProvFromShop, object: nil)
        // notification user provision updated
        NotificationCenter.default.addObserver(self, selector: #selector(updateProvInShop(_ :)), name: .updateProvInShop, object: nil)
        // notification update badge cart
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartBadgeNotif), name: .updateBadgeNumber, object: nil)
        // notification app become active
        NotificationCenter.default.addObserver(self, selector: #selector(appBecomeActive), name: .appBecomeActive, object: nil)
        // notification product updated
        NotificationCenter.default.addObserver(self, selector: #selector(updateProductInShop), name: .updateProductInShop, object: nil)
    }
}



//===========================================================
// MARK: View transitions
//===========================================================



extension ShoppingListViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationAtStart()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        explainLabel.isHidden = true
    }
    
    @objc func appBecomeActive() {
        // update des dates d'achat si besoin
        ProvGenericMethods.reinitPurchaseDate(forProvisionsDP: o_provisionsDP)
    }
}



//===========================================================
// MARK: Animation at start
//===========================================================



extension ShoppingListViewController {
    
    private func animationAtStart() {
        if o_provisionsDP.count <= 0 {
            explainLabel.isHidden = false
            explainLabel.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5) {
                self.explainLabel.transform = .identity
            }
        }
    }
}



//===========================================================
// MARK: Get shoppinglist
//===========================================================



extension ShoppingListViewController {
    
    private func getUserProvisions() {
        o_provisionsDP = ProvGenericMethods.getUserProvisionsDisplayProvider(fromState: .inShop, andUpdateCategories: &o_headers)
    }
}



//===========================================================
// MARK: Add provision to shop
//===========================================================



extension ShoppingListViewController {
    
    @objc func provAddedToShop(_ notif: NSNotification) {
        explainLabel.isHidden = true
        
        if let providerInNotif = notif.object as? ProvisionDisplayProvider {
            // on ajoute au provider existant
            let result = ProvGenericMethods.addItemToProvsDP(provDP: providerInNotif, toDico: &o_provisionsDP, andUpadeCategories: &o_headers)
            if let indexPath = result.index {
                if result.newSection {
                    shoppingTV.insertSections(IndexSet(integer: indexPath.section), with: .automatic)
                } else {
                    shoppingTV.insertRows(at: [indexPath], with: .automatic)
                }
                // scroll to cell
                shoppingTV.scrollToRow(at: indexPath, at: .middle, animated: true)
                return
            }
        } else if let providersInNotif = notif.object as? [ProvisionDisplayProvider] {
            // on ajoute au provider existant chaque provision
            for providerInNotif in providersInNotif {
                let _ = ProvGenericMethods.addItemToProvsDP(provDP: providerInNotif, toDico: &o_provisionsDP, andUpadeCategories: &o_headers)
            }
            shoppingTV.reloadData()
            return
        }
        // on update tout au cas où...
        getUserProvisions()
        shoppingTV.reloadData()
    }
}



//===========================================================
// MARK: Delete provision from shop
//===========================================================



extension ShoppingListViewController {
    
    @objc func deleteProvFromShop(_ notif: NSNotification) {
        guard let providerInNotif = notif.object as? ProvisionDisplayProvider else {return}
        // on supprime du provider existant
        deleteItemFromDP(provisionDP: providerInNotif)
        // on supprime des courses
        guard let uuid = providerInNotif.uuid else {return}
        ProvGenericMethods.deleteProvision(fromUUID: uuid)
    }
    
    private func deleteItemFromDP(provisionDP: ProvisionDisplayProvider) {
        // on supprime du provider existant
        let result = ProvGenericMethods.deleteItemFromDP(provDP: provisionDP, toDico: &o_provisionsDP, andUpadeCategories: &o_headers)
        if let index = result.index, index.section < shoppingTV.numberOfSections && index.row < shoppingTV.numberOfRows(inSection: index.section) {
            if let sectionToDelete = result.deleteSection {
                shoppingTV.deleteSections(IndexSet(integer: sectionToDelete), with: .automatic)
            } else {
                shoppingTV.deleteRows(at: [index], with: .automatic)
            }
        } else {
            // on reload tout au cas où...
            shoppingTV.reloadData()
        }
    }
}



//===========================================================
// MARK: Update shopping list
//===========================================================



extension ShoppingListViewController {
    
    @objc func updateProvInShop(_ notif: NSNotification) {
        if let index = notif.object as? IndexPath, index.section < shoppingTV.numberOfSections && index.row < shoppingTV.numberOfRows(inSection: index.section) {
            // on reload la cellule
            shoppingTV.reloadRows(at: [index], with: .automatic)
        } else {
            // on reload tout au cas où...
            shoppingTV.reloadData()
        }
    }
    
    @objc func updateProductInShop() {
        shoppingTV.reloadData()
    }
}



//===========================================================
// MARK: Add to cart
//===========================================================



extension ShoppingListViewController {
    
    private func addToCart(provisionDP: ProvisionDisplayProvider, atIndexPath indexPath: IndexPath) {
        // on change l'état de la provision
        Provision.printAllProvisions(note: "début de addToCart")
        provisionDP.state = .inCart
        // on supprime du provider existant
        Provision.printAllProvisions(note: "après changement state dans addToCart")
        deleteItemFromDP(provisionDP: provisionDP)
        // update badge
        updateCartBadge()
    }
}



//===========================================================
// MARK: Update cart badge
//===========================================================



extension ShoppingListViewController {
    
    @objc func updateCartBadgeNotif() {
        updateCartBadge()
    }
    
    private func updateCartBadge() {
        if let item = navigationItem.rightBarButtonItem as? BarButtonItemWithBadge {
            item.badgeNumber = Provision.cartCount
        }
    }
}



//===========================================================
// MARK: Init tableView
//===========================================================



extension ShoppingListViewController {
    
    private func initTableView() {
        shoppingTV.register(ShoppingCell.nib, forCellReuseIdentifier: ShoppingCell.key)
        shoppingTV.register(ShoppingHeader.nib, forHeaderFooterViewReuseIdentifier: ShoppingHeader.key)
        shoppingTV.backgroundColor = UIColor.clear
        shoppingTV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Dimensions.shoppingTableViewBottomInset, right: 0)
        shoppingTV.separatorStyle = .none
        shoppingTV.sectionHeaderTopPadding = Dimensions.shoppingTableViewTopInset
    }
}



//===========================================================
// MARK: TableView DataSource
//===========================================================



extension ShoppingListViewController: UITableViewDataSource {
    
    // MARK: Header DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return o_headers.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ShoppingHeader.key) as! ShoppingHeader
        guard section < o_headers.count, let firstProvInSection = o_provisionsDP[o_headers[section]]?.first else {
            headerView.headerLabel.text = ""
            return headerView
        }
        
        headerView.headerLabel.text = firstProvInSection.category
        return headerView
    }
    
    // MARK: Cell DataSource
    
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
        
        // add to cart button
        shoppingCell.addToCartButton.addTouchUpInsideAction {
            self.addToCart(provisionDP: provsDPInSection[indexPath.row], atIndexPath: indexPath)
        }
        
        return shoppingCell
    }
}



//===========================================================
// MARK: TableView Delegate
//===========================================================



extension ShoppingListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Dimensions.headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Dimensions.shoppingRowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section < o_headers.count, let provsDPInSection = o_provisionsDP[o_headers[indexPath.section]] else {return}
        if indexPath.row >= provsDPInSection.count {return}
        shoppingTV.deselectRow(at: indexPath, animated: false)
        
        // BSD détail provision
        let provisionBSD = storyboard?.instantiateViewController(withIdentifier: ProvisionsBSDViewController.STORYBOARD_ID) as! ProvisionsBSDViewController
        provisionBSD.o_provisionDP = provsDPInSection[indexPath.row]
        provisionBSD.o_provIndexPath = indexPath
        present(provisionBSD, animated: true)
    }
}
