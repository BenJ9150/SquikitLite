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
    
    var o_tabBarTransforming = false
    var o_tabBarIsHidden = false
    var o_provisionsDP = [ProvisionDisplayProvider]()
    
    // MARK: Outlets
    
    @IBOutlet weak var shoppingTableView: UITableView!
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
        shoppingTableView.register(ShoppingCell.nib, forCellReuseIdentifier: ShoppingCell.key)
        shoppingTableView.backgroundColor = UIColor.clear
        shoppingTableView.contentInset = UIEdgeInsets(top: Dimensions.shoppingTableViewTopInset, left: 0, bottom: Dimensions.shoppingTableViewBottomInset, right: 0)
        shoppingTableView.separatorStyle = .none
        
        // notifications
        addNotificationObservers()
    }
}



//===========================================================
// MARK: Notifications
//===========================================================



extension CoursesViewController {
    
    private func addNotificationObservers() {
        // notification user provisions added
        NotificationCenter.default.addObserver(self, selector: #selector(userProvisionsAdded(_ :)), name: .userProvisionsAdded, object: nil)
        // notification user provision deleted
        NotificationCenter.default.addObserver(self, selector: #selector(userProvisionDeleted(_ :)), name: .userProvisionsDeleted, object: nil)
        // notification user provision updated
        NotificationCenter.default.addObserver(self, selector: #selector(userProvisionUpdated(_ :)), name: .userProvisionUpdated, object: nil)
    }
}



//===========================================================
// MARK: View transitions
//===========================================================



extension CoursesViewController {
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        shoppingTableView.reloadData()
    }
}



//===========================================================
// MARK: Show/hide tabBar
//===========================================================

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



//===========================================================
// MARK: User provisions
//===========================================================



extension CoursesViewController {
    
    private func getUserProvisions() {
        o_provisionsDP = ProvisionGenericMethods.getUserProvisionsDisplayProviderOLD()
    }
    
    @objc func userProvisionsAdded(_ notif: NSNotification) {
        if let providerInNotif = notif.object as? ProvisionDisplayProvider {
            // on ajoute au provider existant
            o_provisionsDP.append(providerInNotif)
        } else if let providersInNotif = notif.object as? [ProvisionDisplayProvider] {
            // on ajoute au provider existant
            o_provisionsDP.append(contentsOf: providersInNotif)
        } else {
            // on update tout au cas où...
            getUserProvisions()
        }
        shoppingTableView.reloadData()
    }
    
    @objc func userProvisionDeleted(_ notif: NSNotification) {
        if let providerInNotif = notif.object as? ProvisionDisplayProvider {
            // on supprime du provider existant
            o_provisionsDP.removeAll { $0.uuid == providerInNotif.uuid }
        } else {
            // on update tout au cas où...
            getUserProvisions()
        }
        shoppingTableView.reloadData()
    }
    
    @objc func userProvisionUpdated(_ notif: NSNotification) {
        if let provIndexPath = notif.object as? IndexPath {
            // on reload la cellule
            shoppingTableView.reloadRows(at: [provIndexPath], with: .automatic)
        } else {
            // on reload tout au cas où...
            shoppingTableView.reloadData()
        }
    }
}



//===========================================================
// MARK: UITableViewDataSource
//===========================================================



extension CoursesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        o_provisionsDP.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let shoppingCell = tableView.dequeueReusableCell(withIdentifier: ShoppingCell.key, for: indexPath) as! ShoppingCell
        
        let provisionDP = o_provisionsDP[indexPath.row]
        
        shoppingCell.productImageView.image = provisionDP.image
        shoppingCell.nameLabel.text = provisionDP.name
        shoppingCell.qtyAndUnitLabel.text = provisionDP.quantityAndShoppingUnit
        shoppingCell.dlcLabel.text = provisionDP.dlcToString
        
        return shoppingCell
    }
}



//===========================================================
// MARK: UITableViewDelegate
//===========================================================



extension CoursesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // add to cart
    }
}
