//
//  MainTabBarViewController.swift
//  SquikitLite
//
//  Created by Benjamin on 22/06/2023.
//

import UIKit



//===========================================================
// MARK: MainTabBarViewController class
//===========================================================



class MainTabBarViewController: UITabBarController {
    
    // MARK: View did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMiddleButton()
    }
}



//===========================================================
// MARK: TabBar middle button
//===========================================================



extension MainTabBarViewController {
    
    func initMiddleButton() {
        guard let tabBar = tabBar as? MainTabBar else {return}
        
        tabBar.didTapMiddleButton = { [unowned self] in
            self.middleButtonTap()
        }
    }
    
    func middleButtonTap() {
        // get active item
        guard let selectedItem = tabBar.selectedItem else {return}
        guard let itemIndex = tabBar.items?.firstIndex(of: selectedItem) else {return}
        let addProvisionVC = storyboard?.instantiateViewController(withIdentifier: AddprovisionViewController.STORYBOARD_ID) as! AddprovisionViewController
        
        if itemIndex == 0 {
            addProvisionVC.o_currentVC = .inStock // provisions is active
        } else {
            addProvisionVC.o_currentVC = .inShop // shopping is active
        }
        //addProvisionVC.modalPresentationStyle = .fullScreen
        present(addProvisionVC, animated: true)
    }
}
