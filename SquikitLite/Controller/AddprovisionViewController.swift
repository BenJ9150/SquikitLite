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
    private var databaseProvsProvider: [ProvisionDisplayProvider]?
    
    // MARK: Outlets
    
    @IBOutlet weak var searchProvisionsTableView: UITableView!
    
    
    // MARK: View did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get all provions from database
        databaseProvsProvider = ProvisionsGenericMethods.getDataBaseProvisionsDisplayProvider()
        
        // search provisions tableView
        searchProvisionsTableView.register(SearchProvisionsCell.nib, forCellReuseIdentifier: SearchProvisionsCell.key)
    }
}



//===========================================================
// MARK: UITableViewDataSource
//===========================================================



extension AddprovisionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProvisionsGenericMethods.getDataBaseProvisionsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchProvCell = tableView.dequeueReusableCell(withIdentifier: SearchProvisionsCell.key, for: indexPath) as! SearchProvisionsCell
        
        guard let provsProvider = databaseProvsProvider?[indexPath.row] else {return searchProvCell}
        
        searchProvCell.nameLabel.text = provsProvider.name
        searchProvCell.categoryLabel.text = provsProvider.category
        searchProvCell.productImageView.image = provsProvider.image
        
        return searchProvCell
    }
    
    
}



//===========================================================
// MARK: UITableViewDelegate
//===========================================================



extension AddprovisionViewController: UITableViewDelegate {
    
    
}
