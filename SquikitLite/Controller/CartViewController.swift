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
        // TO DO
    }
}



//===========================================================
// MARK: Get cart
//===========================================================



extension CartViewController {
    
    private func getCartProvisions() {
        o_provisionsDP = ProvisionGenericMethods.getUserProvisionsDisplayProvider(fromState: .inCart, andUpadeCategories: &o_headers)
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
        // BSD edit
    }
}

