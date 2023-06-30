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
    private var databaseProvsProvider = [ProvisionDisplayProvider]()
    private var searchedProvsProvider = [ProvisionDisplayProvider]()
    private var searching = false
    
    // MARK: Outlets
    
    @IBOutlet weak var searchProvisionsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: View did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get all provions from database
        databaseProvsProvider = ProvisionsGenericMethods.getDataBaseProvisionsDisplayProvider()
        
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
        searchedProvsProvider = ProvisionsGenericMethods.filterProvisionsByName(fromProvsProvider: databaseProvsProvider, withText: searchText)
        searching = true
        searchProvisionsTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        searchProvisionsTableView.reloadData()
    }
}



//===========================================================
// MARK: UITableViewDataSource
//===========================================================



extension AddprovisionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedProvsProvider.count
        }
        return databaseProvsProvider.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchProvCell = tableView.dequeueReusableCell(withIdentifier: SearchProvisionsCell.key, for: indexPath) as! SearchProvisionsCell
        
        let provsProvider: ProvisionDisplayProvider
        if searching {
            provsProvider = searchedProvsProvider[indexPath.row]
        } else {
            provsProvider = databaseProvsProvider[indexPath.row]
        }
        
        searchProvCell.nameLabel.text = provsProvider.name
        searchProvCell.categoryLabel.text = provsProvider.categoryAndSubCategory
        searchProvCell.productImageView.image = provsProvider.image
        
        return searchProvCell
    }
}



//===========================================================
// MARK: UITableViewDelegate
//===========================================================



extension AddprovisionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // update user provisions
        if searching && indexPath.row < searchedProvsProvider.count {
            ProvisionsGenericMethods.addUserProvision(ofProvDisplayProvider: searchedProvsProvider[indexPath.row])
            
        } else if indexPath.row < databaseProvsProvider.count {
            ProvisionsGenericMethods.addUserProvision(ofProvDisplayProvider: databaseProvsProvider[indexPath.row])
        }
        dismiss(animated: true)
    }
}
