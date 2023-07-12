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
    private var o_multipleChoice = [ProductDisplayProvider]()
    
    // MARK: Outlets
    
    @IBOutlet weak var searchProvisionsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var multipleChoiceSwitch: UISwitch!
    @IBOutlet weak var productsChoiceCollectionView: UICollectionView!
    @IBOutlet weak var productsChoiceCVHeight: NSLayoutConstraint!
    
    // MARK: Actions
    
    @IBAction func multipleChoiceSwitchTap() {
        multipleChoiceSwitchTapAction()
    }
    
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
        
        // collectionView multiple choice
        initProductsChoiceCV()
    }
}



//===========================================================
// MARK: View transitions
//===========================================================



extension AddprovisionViewController {
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        if isViewLoaded {
            productsChoiceCollectionView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveMultipleSelection()
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
        
        let productDP: ProductDisplayProvider
        if o_searching {
            productDP = o_searchedProductsDP[indexPath.row]
        } else {
            productDP = o_productsDP[indexPath.row]
        }
        
        if let searchText = searchBar.text, searchText.count > 0 {
            searchProvCell.nameLabel.attributedText = getAttributedName(forName: productDP.name, andSearchedText: searchText)
            searchProvCell.categoryLabel.attributedText = getAttributedCat(forCategory: productDP.categoryAndSubCategory, andSearchedText: searchText)
        } else {
            searchProvCell.nameLabel.text = productDP.name
            searchProvCell.categoryLabel.text = productDP.categoryAndSubCategory
        }
        
        searchProvCell.productImageView.image = productDP.image
        
        // vérif si product existe déjà
        var productExist = false
        if o_currentVC == .inStock {
            if ProvGenericMethods.checkIfProductAlreadyAdded(fromId: productDP.product.Id, withState: .inStock) {
                productExist = true
            }
        } else {
            if ProvGenericMethods.checkIfProductAlreadyAdded(fromId: productDP.product.Id, withState: .inShopOrCart) {
                productExist = true
            }
        }
        
        if productExist {
            searchProvCell.addButton.isHidden = true
            searchProvCell.alreadyAddLabel.isHidden = false
            searchProvCell.background.backgroundColor = UIColor.mainBackground
        } else if o_multipleChoice.contains(where: { $0.product.Id == productDP.product.Id }) {
            searchProvCell.addButton.isHidden = true
            searchProvCell.alreadyAddLabel.isHidden = true
            searchProvCell.background.backgroundColor = UIColor.mainButton
        } else {
            searchProvCell.addButton.isHidden = false
            searchProvCell.alreadyAddLabel.isHidden = true
            searchProvCell.background.backgroundColor = UIColor.whiteBackground
        }
        
        return searchProvCell
    }
    
    private func getAttributedName(forName name: String, andSearchedText searchText: String) -> NSMutableAttributedString {
        // create attributed string
        let attributedString = NSMutableAttributedString(string: name, attributes: [NSAttributedString.Key.font : UIFont.productName!])
        // set attributes
        attributedString.setAttributes([NSAttributedString.Key.font : UIFont.productNameSearched!, NSAttributedString.Key.foregroundColor: UIColor.creole], range: (name.cleanUpForComparaison as NSString).range(of: searchText.cleanUpForComparaison))
        
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
            addNewProvision(fromProductDP: o_searchedProductsDP[indexPath.row], indexPath: indexPath)
        } else if indexPath.row < o_productsDP.count {
            addNewProvision(fromProductDP: o_productsDP[indexPath.row], indexPath: indexPath)
        }
    }
    
    private func addNewProvision(fromProductDP productDP: ProductDisplayProvider, indexPath: IndexPath) {
        if let switchChoice = multipleChoiceSwitch, switchChoice.isOn {
            addMultipleProvisions(fromProductDP: productDP)
            searchProvisionsTableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            addOneProvision(fromProductDP: productDP)
        }
    }
}



//===========================================================
// MARK: Add provision
//===========================================================



extension AddprovisionViewController {
    
    private func addOneProvision(fromProductDP productDP: ProductDisplayProvider) {
        if ProvGenericMethods.addNewProvision(fromProduct: productDP.product, withState: o_currentVC) {
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



//===========================================================
// MARK: Add multiple provs
//===========================================================



extension AddprovisionViewController {
    
    private func addMultipleProvisions(fromProductDP productDP: ProductDisplayProvider) {
        // check if product exist
        var productExist = false
        var messProductExist = ""
        if o_currentVC == .inStock {
            if ProvGenericMethods.checkIfProductAlreadyAdded(fromId: productDP.product.Id, withState: .inStock) {
                productExist = true
                messProductExist = NSLocalizedString("alert_provAlreadyInStock", comment: "")
            }
        } else {
            if ProvGenericMethods.checkIfProductAlreadyAdded(fromId: productDP.product.Id, withState: .inShopOrCart) {
                productExist = true
                messProductExist = NSLocalizedString("alert_provAlreadyInShop", comment: "")
            }
        }
        
        if productExist {
            let alert = UIAlertController(title: messProductExist, message: "", preferredStyle: .alert)
            alert.addAction(AlertButton().cancel)
            present(alert, animated: true)
            return
        }
        
        // check if product in selection
        if o_multipleChoice.contains(where: { $0.product.Id == productDP.product.Id }) {
            // on retire de la sélection
            o_multipleChoice.removeAll { $0.product.Id == productDP.product.Id }
        } else {
            // on ajoute à la liste des nouveaux product
            o_multipleChoice.append(productDP)
        }
        
        productsChoiceCollectionView.reloadData()
        
        let productsCVHeight = productsChoiceCollectionView.collectionViewLayout.collectionViewContentSize.height
        if productsCVHeight < Dimensions.addProvsCellHeight + Dimensions.addProvsCellSpace*2 {
            productsChoiceCVHeight.constant = Dimensions.addProvsCellHeight + Dimensions.addProvsCellSpace*2
        } else {
            productsChoiceCVHeight.constant = productsCVHeight
        }
    }
    
    func multipleChoiceSwitchTapAction() {
        if let switchChoice = multipleChoiceSwitch, !switchChoice.isOn {
            o_multipleChoice.removeAll()
            productsChoiceCollectionView.reloadData()
            productsChoiceCVHeight.constant = 0
            searchProvisionsTableView.reloadData()
        } else {
            // is on
            productsChoiceCVHeight.constant = Dimensions.addProvsCellHeight + Dimensions.addProvsCellSpace*2
        }
    }
    
    private func saveMultipleSelection() {
        if let switchChoice = multipleChoiceSwitch, !switchChoice.isOn {return}
        if o_multipleChoice.count <= 0 {return}
        
        for productDP in o_multipleChoice {
            let _ = ProvGenericMethods.addNewProvision(fromProduct: productDP.product, withState: o_currentVC)
        }
    }
}



//===========================================================
// MARK: init collection view multiple selection
//===========================================================



extension AddprovisionViewController {
    
    private func initProductsChoiceCV() {
        productsChoiceCollectionView.register(MultipleProductsChoiceCell.nib, forCellWithReuseIdentifier: MultipleProductsChoiceCell.key)
        productsChoiceCVHeight.constant = 0
    }
}



//===========================================================
// MARK: UICollectionViewDelegate
//===========================================================



extension AddprovisionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // suppr selection
        let alert = UIAlertController(title: NSLocalizedString("alert_addProvsRemoveSelection", comment: ""), message: "", preferredStyle: .actionSheet)
        
        let removeButton = UIAlertAction(title: NSLocalizedString("alert_remove", comment: ""), style: .destructive) { _ in
            self.o_multipleChoice.remove(at: indexPath.row)
            self.productsChoiceCollectionView.reloadData()
            self.productsChoiceCVHeight.constant = self.productsChoiceCollectionView.collectionViewLayout.collectionViewContentSize.height
        }
        
        alert.addAction(removeButton)
        alert.addAction(AlertButton().cancel)
        present(alert, animated: true)
    }
}



//===========================================================
// MARK: UICollectionViewDataSource
//===========================================================



extension AddprovisionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return o_multipleChoice.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MultipleProductsChoiceCell.key, for: indexPath) as! MultipleProductsChoiceCell
        if indexPath.row >= o_multipleChoice.count {return cell}
        
        cell.nameLabel.text = o_multipleChoice[indexPath.row].name
        return cell
    }
}



//===========================================================
// MARK: UICollectionViewDelegateFlowLayout
//===========================================================



extension AddprovisionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = CollViewGenericMethods.getCellWidth(forCV: collectionView, withTarget: Dimensions.addProvsCellWidth, andSpace: Dimensions.addProvsCellSpace)
        return CGSize(width: cellWidth, height: Dimensions.addProvsCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Dimensions.addProvsCellSpace, left: Dimensions.addProvsCellSpace, bottom: Dimensions.addProvsCellSpace, right: Dimensions.addProvsCellSpace)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Dimensions.addProvsCellSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Dimensions.addProvsCellSpace
    }
}

