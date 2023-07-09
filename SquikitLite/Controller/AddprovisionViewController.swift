//
//  AddprovisionViewController.swift
//  SquikitLite
//
//  Created by Benjamin on 22/06/2023.
//

import UIKit



//===========================================================
// MARK: AddprovisionViewController class
//===========================================================



class AddprovisionViewController: UIViewController {
    
    // MARK: Properties
    
    static let STORYBOARD_ID = "AddprovisionViewController"
    var o_currentVC: ProvisionState = .inStock
    
    private var o_productsDP = [ProductDisplayProvider]()
    private var o_searchedProductsDP = [ProductDisplayProvider]()
    private var o_searching = false
    
    // MARK: Outlets
    
    @IBOutlet weak var searchProvisionsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
}



//===========================================================
// MARK: View did load
//===========================================================



extension AddprovisionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get all provions from database
        o_productsDP = ProductGenericMethods.productsDisplayProviderFromDatabase()
        
        // search provisions tableView
        searchProvisionsTableView.register(SearchProvisionsCell.nib, forCellReuseIdentifier: SearchProvisionsCell.key)
        
        // searchBar first responder
        searchBar.becomeFirstResponder()
    }
}



//===========================================================
// MARK: UISearchBarDelegate
//===========================================================



extension AddprovisionViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        o_searchedProductsDP = ProductGenericMethods.filterProductsByName(fromProductsDP: o_productsDP, withText: searchText)
        o_searching = true
        searchProvisionsTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        o_searching = false
        searchBar.text = ""
        searchProvisionsTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}



//===========================================================
// MARK: UITableViewDataSource
//===========================================================



extension AddprovisionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if o_searching {
            return o_searchedProductsDP.count
        }
        return o_productsDP.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchProvCell = tableView.dequeueReusableCell(withIdentifier: SearchProvisionsCell.key, for: indexPath) as! SearchProvisionsCell
        
        let productsDP: ProductDisplayProvider
        if o_searching {
            productsDP = o_searchedProductsDP[indexPath.row]
        } else {
            productsDP = o_productsDP[indexPath.row]
        }
        
        if let searchText = searchBar.text, searchText.count > 0 {
            searchProvCell.nameLabel.attributedText = getAttributedName(forName: productsDP.name, andSearchedText: searchText)
            searchProvCell.categoryLabel.attributedText = getAttributedCat(forCategory: productsDP.categoryAndSubCategory, andSearchedText: searchText)
        } else {
            searchProvCell.nameLabel.text = productsDP.name
            searchProvCell.categoryLabel.text = productsDP.categoryAndSubCategory
        }
        
        
        
        searchProvCell.productImageView.image = productsDP.image
        
        return searchProvCell
    }
    
    private func getAttributedName(forName name: String, andSearchedText searchText: String) -> NSMutableAttributedString {
        // create attributed string
        let attributedString = NSMutableAttributedString(string: name, attributes: [NSAttributedString.Key.font : UIFont.productName!])
        // set attributes
        attributedString.setAttributes([NSAttributedString.Key.font : UIFont.productNameSearched!, NSAttributedString.Key.foregroundColor: UIColor.black], range: (name.cleanUpForComparaison as NSString).range(of: searchText.cleanUpForComparaison))
        
        return attributedString
    }
    
    private func getAttributedCat(forCategory category: String, andSearchedText searchText: String) -> NSMutableAttributedString {
        // create attributed string
        let attributedString = NSMutableAttributedString(string: category, attributes: [NSAttributedString.Key.font : UIFont.category!])
        // set attributes
        attributedString.setAttributes([NSAttributedString.Key.font : UIFont.categorySearched!, NSAttributedString.Key.foregroundColor: UIColor.darkGray], range: (category.cleanUpForComparaison as NSString).range(of: searchText.cleanUpForComparaison))
        
        return attributedString
    }
}



//===========================================================
// MARK: UITableViewDelegate
//===========================================================



extension AddprovisionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if o_searching && indexPath.row < o_searchedProductsDP.count {
            addNewProvision(fromProductDP: o_searchedProductsDP[indexPath.row])
        } else if indexPath.row < o_productsDP.count {
            addNewProvision(fromProductDP: o_productsDP[indexPath.row])
        }
    }
}



//===========================================================
// MARK: Add provision
//===========================================================



extension AddprovisionViewController {
    
    private func addNewProvision(fromProductDP productDP: ProductDisplayProvider) {
        if ProvisionGenericMethods.addNewProvision(fromProduct: productDP.product, withState: o_currentVC) {
            dismiss(animated: true)
            return
        }
        let mess: String
        if o_currentVC == .inStock {
            mess = NSLocalizedString("alert_provAlreadyInStock", comment: "")
        } else {
            mess = NSLocalizedString("alert_provAlreadyInShop", comment: "")
        }
        
        let alert = UIAlertController(title: mess, message: "", preferredStyle: .alert)
        let okButton = UIAlertAction(title: NSLocalizedString("alert_ok", comment: ""), style: .cancel) { _ in
        }
        alert.addAction(okButton)
        present(alert, animated: true)
    }
}
