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
    private var o_selectedProducts = [ProductDisplayProvider]()
    
    // MARK: Outlets
    
    @IBOutlet weak var productsTV: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var selectedProductsCV: UICollectionView!
    @IBOutlet weak var selectedProductsCVHeight: NSLayoutConstraint!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var infoMultipleSelectionLabel: UILabel!
    @IBOutlet weak var multipleSelectionSwitch: UISwitch!
    @IBOutlet weak var selectedProductsView: UIView!
    
    // MARK: Actions
    
    @IBAction func addButtonTap() {
        saveSelection()
        dismiss(animated: true)
    }
    
    @IBAction func returnButtonTap() {
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
        
        // search bar
        initSearchBar()
        
        // products tableView
        productsTV.register(SearchProvisionsCell.nib, forCellReuseIdentifier: SearchProvisionsCell.key)
        
        // selected product collectionView
        initSelectedProductsCV()
    }
}



//===========================================================
// MARK: View transitions
//===========================================================



extension AddprovisionViewController {
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        if isViewLoaded {
            multipleSelectionSwitchTapAction() // pour modifier height de la collectionView
            if UIDevice.current.orientation.isLandscape {
                searchBar.spellCheckingType = .no
                searchBar.resignFirstResponder() // pour mettre à jour spell checking
            } else {
                searchBar.spellCheckingType = .default
                searchBar.resignFirstResponder() // pour mettre à jour spell checking
            }
            selectedProductsCV.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if o_selectedProducts.count > 0 {
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
        if o_selectedProducts.contains(where: { $0.product.Id == productDP.product.Id }) {
            // on retire de la sélection
            o_selectedProducts.removeAll { $0.product.Id == productDP.product.Id }
        } else {
            // on ajoute à la liste des nouveaux product
            o_selectedProducts.append(productDP)
        }
        
        updateSelectedProductsUI()
    }
    
    private func saveSelection() {
        if o_selectedProducts.count <= 0 {return}
        
        for productDP in o_selectedProducts {
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
            if UIDevice.current.userInterfaceIdiom == .phone && view.bounds.height < view.bounds.width {
                // iphone paysage
                selectedProductsCVHeight.constant = Dimensions.addProvsCellHeight + Dimensions.addProvsCellSpace + Dimensions.addProvsCellSpace
            } else {
                selectedProductsCVHeight.constant = Dimensions.addProvsCellHeight + Dimensions.addProvsCellTopInset + Dimensions.addProvsCellBottomInset
            }
            selectedProductsView.isHidden = false
            if o_selectedProducts.count > 0 {
                infoMultipleSelectionLabel.isHidden = true
                updateAddButtonUI(isEnabled: true)
            } else {
                infoMultipleSelectionLabel.isHidden = false
                updateAddButtonUI(isEnabled: false)
            }
        } else {
            // pas de sélection multiple
            o_selectedProducts.removeAll()
            selectedProductsCV.reloadData()
            productsTV.reloadData()
            infoMultipleSelectionLabel.isHidden = true
            selectedProductsView.isHidden = true
        }
        
    }
}



//===========================================================
// MARK: init selected prod. CV
//===========================================================



extension AddprovisionViewController {
    
    private func initSelectedProductsCV() {
        selectedProductsCV.register(MultipleProductsChoiceCell.nib, forCellWithReuseIdentifier: MultipleProductsChoiceCell.key)
        selectedProductsView.isHidden = true
        infoMultipleSelectionLabel.isHidden = true
    }
}



//===========================================================
// MARK: update selected prod. UI
//===========================================================



extension AddprovisionViewController {
    
    private func updateSelectedProductsUI() {
        if o_selectedProducts.count <= 0 {
            // rien de sélectionné
            infoMultipleSelectionLabel.isHidden = false
            updateAddButtonUI(isEnabled: false)
            selectedProductsCV.reloadData()
            return
        }
        // sélection en cours
        updateAddButtonUI(isEnabled: true)
        infoMultipleSelectionLabel.isHidden = true
        selectedProductsCV.reloadData()
    }
    
    private func updateAddButtonUI(isEnabled: Bool) {
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
// MARK: Selected prod. Delegate
//===========================================================



extension AddprovisionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // suppr selection
        let alert = UIAlertController(title: NSLocalizedString("alert_addProvsRemoveSelection", comment: ""), message: "", preferredStyle: .actionSheet)
        
        let removeButton = UIAlertAction(title: NSLocalizedString("alert_remove", comment: ""), style: .destructive) { _ in
            self.o_selectedProducts.remove(at: indexPath.row)
            self.productsTV.reloadData()
            self.updateSelectedProductsUI()
        }
        
        alert.addAction(removeButton)
        alert.addAction(AlertButton().cancel)
        present(alert, animated: true)
    }
}



//===========================================================
// MARK: Selected prod. DataSource
//===========================================================



extension AddprovisionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return o_selectedProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MultipleProductsChoiceCell.key, for: indexPath) as! MultipleProductsChoiceCell
        if indexPath.row >= o_selectedProducts.count {return cell}
        
        cell.nameLabel.text = o_selectedProducts[indexPath.row].name
        return cell
    }
}



//===========================================================
// MARK: Selected prod. FlowLayout
//===========================================================



extension AddprovisionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = CollViewGenericMethods.getCellWidth(forCV: collectionView, withTarget: Dimensions.addProvsCellWidth, andSpace: Dimensions.addProvsCellSpace) - 16
        // -16 pour voir que c'est scrollable (la 4ème cellule n'apparait pas entièrement)
        return CGSize(width: cellWidth, height: Dimensions.addProvsCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if UIDevice.current.userInterfaceIdiom == .phone && view.bounds.height < view.bounds.width {
            // iphone paysage
            return UIEdgeInsets(top: Dimensions.addProvsCellSpace, left: Dimensions.addProvsCellSpace, bottom: Dimensions.addProvsCellSpace, right: Dimensions.addProvsCellSpace)
        }
        return UIEdgeInsets(top: Dimensions.addProvsCellTopInset, left: Dimensions.addProvsCellSpace, bottom: Dimensions.addProvsCellBottomInset, right: Dimensions.addProvsCellSpace)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Dimensions.addProvsCellSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Dimensions.addProvsCellSpace
    }
}



//===========================================================
// MARK: Products Delegate
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
// MARK: Products DataSource
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
        } else if o_selectedProducts.contains(where: { $0.product.Id == productDP.product.Id }) {
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
// MARK: Init search bar
//===========================================================



extension AddprovisionViewController {
    
    func initSearchBar() {
        // searchBar first responder
        searchBar.becomeFirstResponder()
        
        // update search bar design
        searchBar.backgroundImage = UIImage() // pour enlever le contour
        if UIDevice.current.userInterfaceIdiom == .phone {
            if view.bounds.height > view.bounds.width {
                // portrait
                searchBar.spellCheckingType = .default
            } else {
                searchBar.spellCheckingType = .no
            }
        }
        
        // update return button design
        returnButton.setImage(UIImage(named: "ic_return_blue")!.withTintColor(.provisionName), for: .normal)
    }
}



//===========================================================
// MARK: Search bar delegate
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
