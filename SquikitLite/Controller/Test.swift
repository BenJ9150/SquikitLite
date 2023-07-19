//
//  ProvisionsDataSource.swift
//  SquikitLite
//
//  Created by Benjamin on 13/07/2023.
//

import Foundation
import UIKit



//===========================================================
// MARK: ProvisionsDataSource class
//===========================================================



class ProvisionsDataSource: NSObject, UICollectionViewDataSource {
        
    // MARK: CollectionView headers
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return o_headers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProvisionHeader.key, for: indexPath) as! ProvisionHeader
        
        if indexPath.section >= o_headers.count {return headerView}
        headerView.headerLabel.text = o_headers[indexPath.section]
        
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
