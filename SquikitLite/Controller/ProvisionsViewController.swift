//
//  ProvisionViewController.swift
//  SquikitLite
//
//  Created by Benjamin on 22/06/2023.
//

import UIKit



//===========================================================
// MARK: ProvisionsViewController class
//===========================================================



class ProvisionsViewController: UIViewController {
    
    // MARK: properties
    
    var tabBarTransforming = false
    var tabBarIsHidden = false
    var provsDisplayProvider = [ProvisionDisplayProvider]()
    
    // MARK: Outlets

    @IBOutlet weak var provisionsCollectionView: UICollectionView!
    
    // MARK: View did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get user provisions
        getUserProvisions()
        
        // collectionView des provisions
        provisionsCollectionView.register(ProvisionCell.nib, forCellWithReuseIdentifier: ProvisionCell.key)
        provisionsCollectionView.backgroundColor = UIColor.clear
        
        // notification user provisions added
        NotificationCenter.default.addObserver(self, selector: #selector(userProvisionsAdded(_ :)), name: .userProvisionsAdded, object: nil)
        
        // notification user provision deleted
        NotificationCenter.default.addObserver(self, selector: #selector(userProvisionDeleted(_ :)), name: .userProvisionsDeleted, object: nil)
    }
}



//===========================================================
// MARK: View transitions
//===========================================================



extension ProvisionsViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        provisionsCollectionView.reloadData()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        provisionsCollectionView.reloadData()
    }
}



//===========================================================
// MARK: Show/hide tabBar
//===========================================================

extension ProvisionsViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            changeTabBar(hide: true)
        } else {
            changeTabBar(hide: false)
        }
    }
    
    private func changeTabBar(hide: Bool) {
        guard let tabBar = tabBarController?.tabBar else {return}
        if tabBarTransforming {return}
        if tabBarIsHidden == hide {return}
        tabBarTransforming = true
        
        if hide {
            UIView.animate(withDuration: 0.3) {
                tabBar.frame = CGRect(origin: CGPoint(x: tabBar.frame.origin.x, y: tabBar.frame.origin.y + tabBar.frame.height*2), size: tabBar.frame.size)
            } completion: { _ in
                self.tabBarIsHidden = true
                self.tabBarTransforming = false
            }

        } else {
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5) {
                tabBar.frame = CGRect(origin: CGPoint(x: tabBar.frame.origin.x, y: tabBar.frame.origin.y - tabBar.frame.height*2), size: tabBar.frame.size)
            } completion: { _ in
                self.tabBarIsHidden = false
                self.tabBarTransforming = false
            }
        }
    }
}



//===========================================================
// MARK: UICollectionViewDelegateFlowLayout
//===========================================================



extension ProvisionsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // largeur de l'écran
        let viewWidth = collectionView.bounds.width//view.safeAreaLayoutGuide.layoutFrame.width
        
        // nombre de colonne possible
        let columnNb = (viewWidth - Dimensions.provisionsCellSpace) / (Dimensions.provisionsCellWidth + Dimensions.provisionsCellSpace)
        //let roundedColumNb = columnNb.rounded(.awayFromZero) // 3 colonnes sur iphone 14
        var roundedColumNb = columnNb.rounded(.down)
        if columnNb - roundedColumNb > 0.7 {
            roundedColumNb += 1
        }
        
        // largeur de la cellule
        let cellWidth = ((viewWidth - Dimensions.provisionsCellSpace) / roundedColumNb) - Dimensions.provisionsCellSpace
        
        return CGSize(width: cellWidth, height: Dimensions.provisionsCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Dimensions.provisionsCellSpace, left: Dimensions.provisionsCellSpace, bottom: Dimensions.provisionsCellSpace, right: Dimensions.provisionsCellSpace)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Dimensions.provisionsCellSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Dimensions.provisionsCellSpace
    }
}


//===========================================================
// MARK: UICollectionViewDelegate
//===========================================================



extension ProvisionsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete?", message: "", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "Ok", style: .destructive) { _ in
            // delete prov
            ProvisionsGenericMethods.deleteUserProvision(ofProvDisplayProvider: self.provsDisplayProvider[indexPath.row])
        }
        alert.addAction(okButton)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelButton)
        
        present(alert, animated: true)
    }
}



//===========================================================
// MARK: UICollectionViewDataSource
//===========================================================



extension ProvisionsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return provsDisplayProvider.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProvisionCell.key, for: indexPath) as! ProvisionCell
        let provisionCell = provsDisplayProvider[indexPath.row]
        
        // Info cell
        cell.nameLabel.text = provisionCell.name
        cell.qtyAndUnitLabel.text = provisionCell.quantityAndShoppingUnit
        cell.productImage.image = provisionCell.image
        cell.expirationButton.setTitle(provisionCell.stringExpirationCountDown, for: .normal)
        setColorExpiration(forButton: cell.expirationButton, inProvProvider: provisionCell)
        
        return cell
    }
    
    private func setColorExpiration(forButton button: UIButton, inProvProvider provProvider: ProvisionDisplayProvider) {
        if !provProvider.havePeremption || provProvider.expirationCountDown == Int.max {
            button.backgroundColor = UIColor.dlcDesactivated
            return
        }
        if provProvider.expirationCountDown <= AppSettings.ConsoLimitNowValue {
            button.backgroundColor = UIColor.dlcUrgent
            return
        }
        if provProvider.expirationCountDown <= AppSettings.ConsoLimitSoonValue {
            button.backgroundColor = UIColor.dlcMoyen
            return
        }
        
        button.backgroundColor = UIColor.dlcNormal
        return
    }
}



//===========================================================
// MARK: User provisions
//===========================================================



extension ProvisionsViewController {
    
    private func getUserProvisions() {
        provsDisplayProvider = ProvisionsGenericMethods.getUserProvisionsDisplayProvider()
    }
    
    @objc func userProvisionsAdded(_ notif: NSNotification) {
        if let providerInNotif = notif.object as? ProvisionDisplayProvider {
            // on ajoute au provider existant
            provsDisplayProvider.append(providerInNotif)
        } else if let providersInNotif = notif.object as? [ProvisionDisplayProvider] {
            // on ajoute au provider existant
            provsDisplayProvider.append(contentsOf: providersInNotif)
        } else {
            // on update tout au cas où...
            provsDisplayProvider = ProvisionsGenericMethods.getUserProvisionsDisplayProvider()
        }
        provisionsCollectionView.reloadData()
    }
    
    @objc func userProvisionDeleted(_ notif: NSNotification) {
        provsDisplayProvider = ProvisionsGenericMethods.getUserProvisionsDisplayProvider()
        provisionsCollectionView.reloadData()
    }
}
