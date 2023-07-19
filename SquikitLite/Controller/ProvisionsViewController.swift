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
    private var o_sortType: SortType = .byCategories
    
    enum SortType {
        case byCategories
        case byDlc
    }
    
    // MARK: Outlets

    @IBOutlet weak var provisionsCV: UICollectionView!
    @IBOutlet weak var explainLabel: UILabel!
    
    // MARK: Actions
    
    @IBAction func sortButtonTap(_ sender: Any) {
        sortButtonTapAction()
    }
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
        // notification product updated
        NotificationCenter.default.addObserver(self, selector: #selector(updateProductInStock), name: .updateProductInStock, object: nil)
    }
}



//===========================================================
// MARK: View transitions
//===========================================================



extension ProvisionsViewController {
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        if isViewLoaded {
            provisionsCV.reloadData()
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
// MARK: Animation at start
//===========================================================



extension ProvisionsViewController {
    
    private func animationAtStart() {
        guard let tabBar = tabBarController?.tabBar as? MainTabBar else {return}
        if o_provisionsDP.count <= 0 {
            // animation info label
            explainLabel.isHidden = false
            explainLabel.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5) {
                self.explainLabel.transform = .identity
            }
            // animation bouton add
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
        
        switch o_sortType {
        case .byCategories:
            o_provisionsDP = ProvGenericMethods.getUserProvisionsDisplayProvider(fromState: .inStock, andUpdateCategories: &o_headers)
        case .byDlc:
            o_provisionsDP = ProvGenericMethods.getUserProvisionsDisplayProviderByDlc(andUpdateCategories: &o_headers)
        }
        showOrNotSortButton()
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
            let result: (index: IndexPath?, newSection: Bool)
            switch o_sortType {
            case .byCategories:
                result = ProvGenericMethods.addItemToProvsDP(provDP: providerInNotif, toDico: &o_provisionsDP, andUpadeCategories: &o_headers)
            case .byDlc:
                result = ProvGenericMethods.addItemToProvsDPSortByDlc(provDP: providerInNotif, toDico: &o_provisionsDP, andUpadeCategories: &o_headers)
            }
            
            if let indexPath = result.index {
                if result.newSection {
                    provisionsCV.insertSections(IndexSet(integer: indexPath.section))
                } else {
                    self.provisionsCV.insertItems(at: [indexPath])
                }
                // scroll to cell
                provisionsCV.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
                showOrNotSortButton()
                return
            }
        } else if let providersInNotif = notif.object as? [ProvisionDisplayProvider] {
            // on ajoute au provider existant chaque provision
            for providerInNotif in providersInNotif {
                switch o_sortType {
                case .byCategories:
                    let _ = ProvGenericMethods.addItemToProvsDP(provDP: providerInNotif, toDico: &o_provisionsDP, andUpadeCategories: &o_headers)
                case .byDlc:
                    let _ = ProvGenericMethods.addItemToProvsDPSortByDlc(provDP: providerInNotif, toDico: &o_provisionsDP, andUpadeCategories: &o_headers)
                }
            }
            provisionsCV.reloadData()
            showOrNotSortButton()
            return
        }
        // on update tout
        getUserProvisions()
        provisionsCV.reloadData()
    }
}



//===========================================================
// MARK: Delete user provisions
//===========================================================



extension ProvisionsViewController {
    
    @objc func deleteUserProvision(_ notif: NSNotification) {
        guard let providerInNotif = notif.object as? ProvisionDisplayProvider else {return}
        
        // on supprime du provider existant
        let result: (index: IndexPath?, deleteSection: Int?)
        switch o_sortType {
        case .byCategories:
            result = ProvGenericMethods.deleteItemFromDP(provDP: providerInNotif, toDico: &o_provisionsDP, andUpadeCategories: &o_headers)
        case .byDlc:
            result = ProvGenericMethods.deleteItemFromDPSortByDlc(provDP: providerInNotif, toDico: &o_provisionsDP, andUpadeCategories: &o_headers)
        }
        
        if let index = result.index, index.section < provisionsCV.numberOfSections && index.row < provisionsCV.numberOfItems(inSection: index.section) {
            if let sectionToDelete = result.deleteSection {
                provisionsCV.deleteSections(IndexSet(integer: sectionToDelete))
            } else {
                provisionsCV.deleteItems(at: [index])
            }
        } else {
            // on reload tout au cas où...
            provisionsCV.reloadData()
        }
        // on supprime des provisions
        guard let uuid = providerInNotif.uuid else {return}
        ProvGenericMethods.deleteProvision(fromUUID: uuid)
        showOrNotSortButton()
    }
}



//===========================================================
// MARK: Update user provisions
//===========================================================



extension ProvisionsViewController {
    
    @objc func updateUserProvision(_ notif: NSNotification) {
        if let index = notif.object as? IndexPath, index.section < provisionsCV.numberOfSections && index.row < provisionsCV.numberOfItems(inSection: index.section) {
            // on reload la cellule
            provisionsCV.reloadItems(at: [index])
        } else {
            // on reload tout au cas où...
            provisionsCV.reloadData()
        }
    }
    
    @objc func updateProductInStock() {
        provisionsCV.reloadData()
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
            if indexPath.section < self.provisionsCV.numberOfSections && indexPath.row < self.provisionsCV.numberOfItems(inSection: indexPath.section) {
                self.provisionsCV.reloadItems(at: [indexPath])
            } else {
                self.provisionsCV.reloadData()
            }
            
        }
        alertDLC.addAction(okButton)
        present(alertDLC, animated: true)
    }
}



//===========================================================
// MARK: Change Sort
//===========================================================



extension ProvisionsViewController {
    
    
    private func sortButtonTapAction() {
        
        if o_sortType == .byCategories {
            o_sortType = .byDlc
        } else {
            o_sortType = .byCategories
        }
        getUserProvisions()
        provisionsCV.reloadData()
    }
    
    private func showOrNotSortButton() {
        guard let rightItem = navigationItem.rightBarButtonItem else {return}
        if o_provisionsDP.count > 0 {
            rightItem.isHidden = false
            return
        }
        rightItem.isHidden = true
    }
}



//===========================================================
// MARK: Init collectionView
//===========================================================



extension ProvisionsViewController {
    
    private func initCollectionView() {
        provisionsCV.register(ProvisionCell.nib, forCellWithReuseIdentifier: ProvisionCell.key)
        provisionsCV.register(ProvisionHeader.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProvisionHeader.key)
        provisionsCV.backgroundColor = UIColor.clear
        provisionsCV.contentInset = UIEdgeInsets(top: Dimensions.provisionCollectionViewTopInset, left: 0, bottom: Dimensions.provisionCollectionViewBottomInset, right: 0)
    }
}



//===========================================================
// MARK: CollectionView FlowLayout
//===========================================================



extension ProvisionsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = CollViewGenericMethods.getCellWidth(forCV: collectionView, withTarget: Dimensions.provisionsCellWidth, andSpace: Dimensions.provisionsCellSpace)
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
// MARK: CollectionView Delegate
//===========================================================



extension ProvisionsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section < o_headers.count, let provsDPInSection = o_provisionsDP[o_headers[indexPath.section]] else {return}
        if indexPath.row >= provsDPInSection.count {return}
        
        // BSD détail provision
        let provisionBSD = storyboard?.instantiateViewController(withIdentifier: ProvisionsBSDViewController.STORYBOARD_ID) as! ProvisionsBSDViewController
        provisionBSD.o_provisionDP = provsDPInSection[indexPath.row]
        provisionBSD.o_provIndexPath = indexPath
        present(provisionBSD, animated: true)
    }
}



//===========================================================
// MARK: CollectionView DataSource
//===========================================================



extension ProvisionsViewController: UICollectionViewDataSource {
        
    // MARK: Header DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return o_headers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProvisionHeader.key, for: indexPath) as! ProvisionHeader
        
        if indexPath.section >= o_headers.count {return headerView}
        headerView.headerLabel.text = o_headers[indexPath.section]
        
        return headerView
    }
    
    // MARK: Cell DataSource
    
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
        cell.expirationButton.addTouchUpInsideAction {
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

