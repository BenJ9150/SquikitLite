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
    
    private var o_tabBarTransforming = false
    private var o_tabBarIsHidden = false
    private var o_provisionsDP = [String: [ProvisionDisplayProvider]]()
    private var o_headers = [String]()
    
    // MARK: Outlets

    @IBOutlet weak var provisionsCollectionView: UICollectionView!
    @IBOutlet weak var explainLabel: UILabel!
    
}



//===========================================================
// MARK: View did load
//===========================================================



extension ProvisionsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get user provisions
        getUserProvisions()
        
        // collectionView des provisions
        initCollectionView()
        
        // notifications
        addNotificationObservers()
    }
}



//===========================================================
// MARK: Notifications
//===========================================================



extension ProvisionsViewController {
    
    private func addNotificationObservers() {
        // notification user provisions added
        NotificationCenter.default.addObserver(self, selector: #selector(userProvisionsAdded(_ :)), name: .userProvisionsAdded, object: nil)
        // notification user provision deleted
        NotificationCenter.default.addObserver(self, selector: #selector(deleteUserProvision(_ :)), name: .deleteUserProvision, object: nil)
        // notification user provision updated
        NotificationCenter.default.addObserver(self, selector: #selector(updateUserProvision(_ :)), name: .updateUserProvision, object: nil)
    }
}



//===========================================================
// MARK: View transitions
//===========================================================



extension ProvisionsViewController {
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        if isViewLoaded {
            provisionsCollectionView.reloadData()
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
}



//===========================================================
// MARK: Show/hide tabBar
//===========================================================


/*
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



extension ProvisionsViewController {
    
    private func animationAtStart() {
        guard let tabBar = tabBarController?.tabBar as? MainTabBar else {return}
        if o_provisionsDP.count <= 0 {
            explainLabel.isHidden = false
            MyAnimations.disappearAndReappear(forViews: [explainLabel])
            Task {
                while !self.explainLabel.isHidden {
                    do { try await Task.sleep(nanoseconds: 1000000000) } catch {}
                    if !self.explainLabel.isHidden {
                        tabBar.middleButtonAnimation()
                    }
                    do { try await Task.sleep(nanoseconds: 1000000000) } catch {}
                }
            }
        }
    }
}



//===========================================================
// MARK: Get user provisions
//===========================================================



extension ProvisionsViewController {
    
    private func getUserProvisions() {
        o_provisionsDP = ProvGenericMethods.getUserProvisionsDisplayProvider(fromState: .inStock, andUpadeCategories: &o_headers)
    }
}



//===========================================================
// MARK: Add user provisions
//===========================================================



extension ProvisionsViewController {
    
    @objc func userProvisionsAdded(_ notif: NSNotification) {
        explainLabel.isHidden = true
        
        if let providerInNotif = notif.object as? ProvisionDisplayProvider {
            // on ajoute au provider existant
            let result = ProvGenericMethods.addItemToProvsDP(provDP: providerInNotif, toDico: &o_provisionsDP, andUpadeCategories: &o_headers)
            if let indexPath = result.index {
                if result.newSection {
                    provisionsCollectionView.insertSections(IndexSet(integer: indexPath.section))
                } else {
                    self.provisionsCollectionView.insertItems(at: [indexPath])
                }
                // scroll to cell
                provisionsCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
                return
            }
        } else if let providersInNotif = notif.object as? [ProvisionDisplayProvider] {
            // on ajoute au provider existant chaque provision
            for providerInNotif in providersInNotif {
                let _ = ProvGenericMethods.addItemToProvsDP(provDP: providerInNotif, toDico: &o_provisionsDP, andUpadeCategories: &o_headers)
            }
            provisionsCollectionView.reloadData()
            return
        }
        // on update tout
        getUserProvisions()
        provisionsCollectionView.reloadData()
    }
}



//===========================================================
// MARK: Delete user provisions
//===========================================================



extension ProvisionsViewController {
    
    @objc func deleteUserProvision(_ notif: NSNotification) {
        guard let providerInNotif = notif.object as? ProvisionDisplayProvider else {return}
        
        // on supprime du provider existant
        let result = ProvGenericMethods.deleteItemFromDP(provDP: providerInNotif, toDico: &o_provisionsDP, andUpadeCategories: &o_headers)
        if let indexPath = result.index {
            if let sectionToDelete = result.deleteSection {
                provisionsCollectionView.deleteSections(IndexSet(integer: sectionToDelete))
            } else {
                provisionsCollectionView.deleteItems(at: [indexPath])
            }
        } else {
            // on reload tout au cas où...
            provisionsCollectionView.reloadData()
        }
        // on supprime des provisions
        guard let uuid = providerInNotif.uuid else {return}
        ProvGenericMethods.deleteProvision(fromUUID: uuid)
    }
}



//===========================================================
// MARK: Update user provisions
//===========================================================



extension ProvisionsViewController {
    
    @objc func updateUserProvision(_ notif: NSNotification) {
        if let provIndexPath = notif.object as? IndexPath {
            // on reload la cellule
            provisionsCollectionView.reloadItems(at: [provIndexPath])
        } else {
            // on reload tout au cas où...
            provisionsCollectionView.reloadData()
        }
    }
}



//===========================================================
// MARK: Init collectionView
//===========================================================



extension ProvisionsViewController {
    
    private func initCollectionView() {
        provisionsCollectionView.register(ProvisionCell.nib, forCellWithReuseIdentifier: ProvisionCell.key)
        provisionsCollectionView.register(ProvisionHeader.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProvisionHeader.key)
        provisionsCollectionView.backgroundColor = UIColor.clear
        provisionsCollectionView.contentInset = UIEdgeInsets(top: Dimensions.provisionCollectionViewTopInset, left: 0, bottom: Dimensions.provisionCollectionViewBottomInset, right: 0)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: Dimensions.headerHeight)
    }
}


//===========================================================
// MARK: UICollectionViewDelegate
//===========================================================



extension ProvisionsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // BSD detail prov
        ComMethodsCV().showProvBSD(viewController: self,forProvisionDP: o_provisionsDP, atIndexPath: indexPath, withHeaderTab: o_headers)
    }
}



//===========================================================
// MARK: UICollectionViewDataSource
//===========================================================



extension ProvisionsViewController: UICollectionViewDataSource {
        
    // MARK: CollectionView headers
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return o_headers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProvisionHeader.key, for: indexPath) as! ProvisionHeader
        guard indexPath.section < o_headers.count, let firstProvInSection = o_provisionsDP[o_headers[indexPath.section]]?.first else {
            headerView.headerLabel.text = ""
            return headerView
        }
        
        headerView.headerLabel.text = firstProvInSection.category
        return headerView
    }
    
    // MARK: CollectionView Cell
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section < o_headers.count, let provsDPInSection = o_provisionsDP[o_headers[section]] {
            return provsDPInSection.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProvisionCell.key, for: indexPath) as! ProvisionCell
        guard indexPath.section < o_headers.count, let provsDPInSection = o_provisionsDP[o_headers[indexPath.section]] else {return cell}
        if indexPath.row >= provsDPInSection.count {return cell}
        
        // Info cell
        cell.nameLabel.text = provsDPInSection[indexPath.row].name
        cell.qtyAndUnitLabel.text = provsDPInSection[indexPath.row].quantityAndShoppingUnit
        cell.productImage.image = provsDPInSection[indexPath.row].image
        cell.expirationButton.setTitle(provsDPInSection[indexPath.row].stringExpirationCountDown, for: .normal)
        setColorExpiration(forButton: cell.expirationButton, inProvProvider: provsDPInSection[indexPath.row])
        
        // DLC button action
        cell.expirationButton.addAction(forControlEvent: .touchUpInside) {
            self.updateDlcOf(provisionDP: provsDPInSection[indexPath.row], atIndexPath: indexPath)
        }
        
        return cell
    }
    
    private func setColorExpiration(forButton button: UIButton, inProvProvider provProvider: ProvisionDisplayProvider) {
        if provProvider.expirationCountDown == Int.max {
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
// MARK: Update DLC
//===========================================================



extension ProvisionsViewController {
    
    
    private func updateDlcOf(provisionDP: ProvisionDisplayProvider, atIndexPath indexPath: IndexPath) {
        // display alert
        let alertDLC = DlcAlertController(title: NSLocalizedString("alert_changeDlcTitle", comment: ""), message: "", preferredStyle: .alert)
        alertDLC.o_dateToDisplay = provisionDP.dlc
        
        // ok button
        let okButton = UIAlertAction(title: NSLocalizedString("alert_choose", comment: ""), style: .default) { _ in
            // maj provision
            provisionDP.dlc = alertDLC.o_datePicker.date
            // maj IHM
            self.provisionsCollectionView.reloadItems(at: [indexPath])
        }
        alertDLC.addAction(okButton)
        present(alertDLC, animated: true)
    }
}


