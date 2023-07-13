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
    
    private var o_productsDP = [ProductDisplayProvider]() // liste quand aucune recherche en cours (liste complète - produit en stock)
    private var o_searchedProductsDP = [ProductDisplayProvider]() // liste triée suivant recherche
    private var o_productsDPForSearch = [ProductDisplayProvider]() // liste complète utilisée pour créer la liste triée
    private var o_searching = false
    private var o_provsSelection = [ProductDisplayProvider]()
    
    // MARK: Outlets
    
    @IBOutlet weak var productsTV: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var productsChoiceCollectionView: UICollectionView!
    @IBOutlet weak var productsChoiceCVHeight: NSLayoutConstraint!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var addButtonView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var infoMultipleSelectionLabel: UILabel!
    @IBOutlet weak var multipleSelectionSwitch: UISwitch!
    
    // MARK: Actions
    
    @IBAction func addButtonTap() {
        saveSelection()
        dismiss(animated: true)
    }
    
    @IBAction func returnButtonTap() { // masqué
        dismiss(animated: true)
    }
    
    @IBAction func multipleSelectionSwitchTap() {
        multipleSelectionSwitchTapAction()
    }
}



//===========================================================
// MARK: View did load
//===========================================================



extension AddprovisionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get all provions from database
        loadProducts()
        
        // search provisions tableView
        productsTV.register(SearchProvisionsCell.nib, forCellReuseIdentifier: SearchProvisionsCell.key)
        
        // searchBar first responder
        searchBar.becomeFirstResponder()
        
        // collectionView multiple choice
        initProductsChoiceCV()
        
        // update navigation design
        returnButton.setImage(UIImage(named: "ic_return_blue")!.withTintColor(.provisionName), for: .normal)
        
        // update search bar design
        searchBar.backgroundImage = UIImage() // pour enlever le contour
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
            productsTV.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if o_provsSelection.count > 0 {
            saveSelection()
        }
    }
}


//===========================================================
// MARK: Load products
//===========================================================



extension AddprovisionViewController {
    
    private func loadProducts() {
        // liste complète utilisée pour créer la liste triée
        o_productsDPForSearch = ProductGenericMethods.productsDisplayProviderFromDatabase()
        
        // liste quand aucune recherche en cours (liste complète - produit en stock)
        let state: ProvisionState
        if o_currentVC == .inStock {
            state = .inStock
        } else {
            state = .inShopOrCart
        }
        
        for productDP in o_productsDPForSearch {
            if !ProvGenericMethods.checkIfProductAlreadyAdded(fromId: productDP.product.Id, withState: state) {
                // product n'existe pas
                o_productsDP.append(productDP)
            }
        }
    }
}



//===========================================================
// MARK: UISearchBarDelegate
//===========================================================



extension AddprovisionViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            o_searching = false
        } else {
            o_searching = true
        }
        o_searchedProductsDP = ProductGenericMethods.filterProductsByName(fromProductsDP: o_productsDPForSearch, withText: searchText, withMultipleSlection: multipleSelectionSwitch!.isOn)
        productsTV.reloadData()
    }
    /*
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        o_searching = false
        searchBar.text = ""
        searchProvisionsTableView.reloadData()
    }
    */
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
            searchProvCell.nameLabel.attributedText = NSAttributedString()
            searchProvCell.nameLabel.text = productDP.name
            searchProvCell.categoryLabel.attributedText = NSAttributedString()
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
            // existe déjà dans stock ou courses
            searchProvCell.addButton.isHidden = true
            searchProvCell.alreadyAddLabel.isHidden = false
            searchProvCell.background.backgroundColor = UIColor.mainBackground
            searchProvCell.categoryLabel.text = ""
        } else if o_provsSelection.contains(where: { $0.product.Id == productDP.product.Id }) {
            // existe déjà dans la sélection
            searchProvCell.addButton.isHidden = false
            searchProvCell.alreadyAddLabel.isHidden = true
            searchProvCell.background.backgroundColor = UIColor.rowSelection
            searchProvCell.addButton.image = UIImage(named: "ic_validation_128")
            searchProvCell.categoryLabel.text = ""
        } else {
            // n'existe pas
            searchProvCell.addButton.isHidden = false
            searchProvCell.addButton.image = UIImage(named: "ic_addButton")
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
        attributedString.setAttributes([NSAttributedString.Key.font : UIFont.categorySearched!, NSAttributedString.Key.foregroundColor: UIColor.creole], range: (category.cleanUpForComparaison as NSString).range(of: searchText.cleanUpForComparaison))
        
        return attributedString
    }
}



//===========================================================
// MARK: UITableViewDelegate
//===========================================================



extension AddprovisionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if o_searching && indexPath.row < o_searchedProductsDP.count {
            addProvToSelection(fromProductDP: o_searchedProductsDP[indexPath.row])
        } else if indexPath.row < o_productsDP.count {
            addProvToSelection(fromProductDP: o_productsDP[indexPath.row])
        }
        
        if indexPath.section < productsTV.numberOfSections && indexPath.row < productsTV.numberOfRows(inSection: indexPath.section) {
            productsTV.reloadRows(at: [indexPath], with: .automatic)
        } else {
            productsTV.reloadData()
        }
        
    }
}



//===========================================================
// MARK: Add provisions
//===========================================================



extension AddprovisionViewController {
    
    private func addProvToSelection(fromProductDP productDP: ProductDisplayProvider) {
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
        
        // pas de sélection multiple
        if !multipleSelectionSwitch!.isOn {
            let _ = ProvGenericMethods.addNewProvision(fromProduct: productDP.product, withState: o_currentVC)
            dismiss(animated: true)
            return
        }
        
        // check if product in selection
        if o_provsSelection.contains(where: { $0.product.Id == productDP.product.Id }) {
            // on retire de la sélection
            o_provsSelection.removeAll { $0.product.Id == productDP.product.Id }
        } else {
            // on ajoute à la liste des nouveaux product
            o_provsSelection.append(productDP)
        }
        
        updateIhmProductsChoiceCV()
    }
    
    private func saveSelection() {
        if o_provsSelection.count <= 0 {return}
        
        for productDP in o_provsSelection {
            let _ = ProvGenericMethods.addNewProvision(fromProduct: productDP.product, withState: o_currentVC)
        }
    }
}



//===========================================================
// MARK: switch multiple slection
//===========================================================



extension AddprovisionViewController {
    
    private func multipleSelectionSwitchTapAction() {
        if multipleSelectionSwitch!.isOn {
            // sélection multiple activée
            productsChoiceCVHeight.constant = Dimensions.addProvsCellHeight + Dimensions.addProvsCellTopInset + Dimensions.addProvsCellBottomInset
            infoMultipleSelectionLabel.isHidden = false
            addButtonView.isHidden = false
            addButtonState(isEnabled: false)
        } else {
            productsChoiceCVHeight.constant = 0
            o_provsSelection.removeAll()
            productsChoiceCollectionView.reloadData()
            productsTV.reloadData()
            infoMultipleSelectionLabel.isHidden = true
            addButtonView.isHidden = true
        }
        
    }
}



//===========================================================
// MARK: init collection view selection
//===========================================================



extension AddprovisionViewController {
    
    private func initProductsChoiceCV() {
        productsChoiceCollectionView.register(MultipleProductsChoiceCell.nib, forCellWithReuseIdentifier: MultipleProductsChoiceCell.key)
        productsChoiceCVHeight.constant = 0
        addButtonView.isHidden = true
        infoMultipleSelectionLabel.isHidden = true
    }
}



//===========================================================
// MARK: update IHM CV selection
//===========================================================



extension AddprovisionViewController {
    
    private func updateIhmProductsChoiceCV() {
        if o_provsSelection.count <= 0 {
            // rien de sélectionné
            infoMultipleSelectionLabel.isHidden = false
            addButtonState(isEnabled: false)
            productsChoiceCollectionView.reloadData()
            return
        }
        // sélection en cours
        addButtonState(isEnabled: true)
        infoMultipleSelectionLabel.isHidden = true
        productsChoiceCollectionView.reloadData()
    }
    
    private func addButtonState(isEnabled: Bool) {
        if isEnabled {
            addButton.backgroundColor = UIColor.mainButton
            addButton.addSmallShadow()
            addButton.isEnabled = true
        } else {
            addButton.backgroundColor = UIColor.inactiveButton
            addButton.removeShadow()
            addButton.isEnabled = false
        }
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
            self.o_provsSelection.remove(at: indexPath.row)
            self.productsTV.reloadData()
            self.updateIhmProductsChoiceCV()
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
        return o_provsSelection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MultipleProductsChoiceCell.key, for: indexPath) as! MultipleProductsChoiceCell
        if indexPath.row >= o_provsSelection.count {return cell}
        
        cell.nameLabel.text = o_provsSelection[indexPath.row].name
        return cell
    }
}



//===========================================================
// MARK: UICollectionViewDelegateFlowLayout
//===========================================================



extension AddprovisionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = CollViewGenericMethods.getCellWidth(forCV: collectionView, withTarget: Dimensions.addProvsCellWidth, andSpace: Dimensions.addProvsCellSpace) - 16
        // -16 pour voir que c'est scrollable (la 4ème cellule n'apparait pas entièrement)
        return CGSize(width: cellWidth, height: Dimensions.addProvsCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Dimensions.addProvsCellTopInset, left: Dimensions.addProvsCellSpace, bottom: Dimensions.addProvsCellBottomInset, right: Dimensions.addProvsCellSpace)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Dimensions.addProvsCellSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Dimensions.addProvsCellSpace
    }
}

