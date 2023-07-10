//
//  CoursesViewController.swift
//  SquikitLite
//
//  Created by Benjamin on 22/06/2023.
//

import UIKit



//===========================================================
// MARK: CoursesViewController class
//===========================================================



class CoursesViewController: UIViewController {

    // MARK: Properties
    
    private var o_tabBarTransforming = false
    private var o_tabBarIsHidden = false
    private var o_provisionsDP = [String: [ProvisionDisplayProvider]]()
    private var o_headers = [String]()
    
    // MARK: Outlets
    
    @IBOutlet weak var shoppingTableView: UITableView!
    @IBOutlet weak var explainLabel: UILabel!
    
}



//===========================================================
// MARK: View did load
//===========================================================



extension CoursesViewController {
    
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



extension CoursesViewController {
    
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



extension CoursesViewController {
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        if isViewLoaded {
            shoppingTableView.reloadData()
        }
    }
    
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
// MARK: Show/hide tabBar
//===========================================================


/*
extension CoursesViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            changeTabBar(hide: true)
        } else {
            changeTabBar(hide: false)
        }
    }
    
    private func changeTabBar(hide: Bool) {
        guard let tabBar = tabBarController?.tabBar else {return}
        if o_tabBarTransforming {return}
        if o_tabBarIsHidden == hide {return}
        o_tabBarTransforming = true
        
        if hide {
            UIView.animate(withDuration: 0.3) {
                tabBar.frame = CGRect(origin: CGPoint(x: tabBar.frame.origin.x, y: tabBar.frame.origin.y + tabBar.frame.height*2), size: tabBar.frame.size)
            } completion: { _ in
                self.o_tabBarIsHidden = true
                self.o_tabBarTransforming = false
            }

        } else {
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5) {
                tabBar.frame = CGRect(origin: CGPoint(x: tabBar.frame.origin.x, y: tabBar.frame.origin.y - tabBar.frame.height*2), size: tabBar.frame.size)
            } completion: { _ in
                self.o_tabBarIsHidden = false
                self.o_tabBarTransforming = false
            }
        }
    }
}
*/


//===========================================================
// MARK: Animation at start
//===========================================================



extension CoursesViewController {
    
    private func animationAtStart() {
        if o_provisionsDP.count <= 0 {
            explainLabel.isHidden = false
            MyAnimations.disappearAndReappear(forViews: [explainLabel])
        }
    }
}



//===========================================================
// MARK: Get shoppinglist
//===========================================================



extension CoursesViewController {
    
    private func getUserProvisions() {
        o_provisionsDP = ProvGenericMethods.getUserProvisionsDisplayProvider(fromState: .inShop, andUpdateCategories: &o_headers)
    }
}



//===========================================================
// MARK: Add provision to shop
//===========================================================



extension CoursesViewController {
    
    @objc func provAddedToShop(_ notif: NSNotification) {
        explainLabel.isHidden = true
        
        if let providerInNotif = notif.object as? ProvisionDisplayProvider {
            // on ajoute au provider existant
            let result = ProvGenericMethods.addItemToProvsDP(provDP: providerInNotif, toDico: &o_provisionsDP, andUpadeCategories: &o_headers)
            if let indexPath = result.index {
                if result.newSection {
                    shoppingTableView.insertSections(IndexSet(integer: indexPath.section), with: .automatic)
                } else {
                    shoppingTableView.insertRows(at: [indexPath], with: .automatic)
                }
                // scroll to cell
                shoppingTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
                return
            }
        } else if let providersInNotif = notif.object as? [ProvisionDisplayProvider] {
            // on ajoute au provider existant chaque provision
            for providerInNotif in providersInNotif {
                let _ = ProvGenericMethods.addItemToProvsDP(provDP: providerInNotif, toDico: &o_provisionsDP, andUpadeCategories: &o_headers)
            }
            shoppingTableView.reloadData()
            return
        }
        // on update tout au cas où...
        getUserProvisions()
        shoppingTableView.reloadData()
    }
}



//===========================================================
// MARK: Delete provision from shop
//===========================================================



extension CoursesViewController {
    
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
    }
}



//===========================================================
// MARK: Update shopping list
//===========================================================



extension CoursesViewController {
    
    @objc func updateProvInShop(_ notif: NSNotification) {
        if let provIndexPath = notif.object as? IndexPath {
            // on reload la cellule
            shoppingTableView.reloadRows(at: [provIndexPath], with: .automatic)
        } else {
            // on reload tout au cas où...
            shoppingTableView.reloadData()
        }
    }
    
    @objc func updateProductInShop() {
        shoppingTableView.reloadData()
    }
}



//===========================================================
// MARK: Init tableView
//===========================================================



extension CoursesViewController {
    
    private func initTableView() {
        shoppingTableView.register(ShoppingCell.nib, forCellReuseIdentifier: ShoppingCell.key)
        shoppingTableView.register(ShoppingHeader.nib, forHeaderFooterViewReuseIdentifier: ShoppingHeader.key)
        shoppingTableView.backgroundColor = UIColor.clear
        shoppingTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Dimensions.shoppingTableViewBottomInset, right: 0)
        shoppingTableView.separatorStyle = .none
        shoppingTableView.sectionHeaderTopPadding = Dimensions.shoppingTableViewTopInset
    }
}



//===========================================================
// MARK: UITableViewDataSource
//===========================================================



extension CoursesViewController: UITableViewDataSource {
    
    // MARK: TableView headers
    
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
        
        // add to cart button
        shoppingCell.addToCartButton.addTouchUpInsideAction {
            self.addToCart(provisionDP: provsDPInSection[indexPath.row], atIndexPath: indexPath)
        }
        
        return shoppingCell
    }
}



//===========================================================
// MARK: UITableViewDelegate
//===========================================================



extension CoursesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Dimensions.headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Dimensions.shoppingRowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        shoppingTableView.deselectRow(at: indexPath, animated: false)
        // BSD detail prov
        ComMethodsCV().showProvBSD(viewController: self,forProvisionDP: o_provisionsDP, atIndexPath: indexPath, withHeaderTab: o_headers)
    }
}



//===========================================================
// MARK: Add to cart
//===========================================================



extension CoursesViewController {
    
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



extension CoursesViewController {
    
    @objc func updateCartBadgeNotif() {
        updateCartBadge()
    }
    
    private func updateCartBadge() {
        if let item = navigationItem.rightBarButtonItem as? BarButtonItemWithBadge {
            item.badgeNumber = Provision.cartCount
        }
    }
}
