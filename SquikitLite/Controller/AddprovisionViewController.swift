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
        
        searchProvCell.nameLabel.text = productsDP.name
        searchProvCell.categoryLabel.text = productsDP.categoryAndSubCategory
        searchProvCell.productImageView.image = productsDP.image
        
        return searchProvCell
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
    
    private func addNewProvision(fromProductDP productDP: ProductDisplayProvider) {
        // check if product already in stock
        if Provision.checkIfProductAlreadyAdded(withProductId: productDP.product.Id) {
            let alert = UIAlertController(title: NSLocalizedString("alert_provAlreadyInStock", comment: ""), message: "", preferredStyle: .alert)
            let okButton = UIAlertAction(title: NSLocalizedString("alert_ok", comment: ""), style: .cancel) { _ in
                self.dismiss(animated: true)
            }
            alert.addAction(okButton)
            present(alert, animated: true)
            return
        }

        // on crée une nouvelle provision
        guard let newProv = Provision.addNewProvision(fromProduct: productDP.product) else {return}
        // on crée un nouveau display provider
        let newProvProvider = ProvisionDisplayProvider(forProvision: newProv)
        NotificationCenter.default.post(name: .userProvisionsAdded, object: newProvProvider)
        
        dismiss(animated: true)
    }
}
