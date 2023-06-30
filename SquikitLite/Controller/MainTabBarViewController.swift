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
    
    // MARK: Properties
    
    var middleButton: UIButton?
    
}



//===========================================================
// MARK: View did load
//===========================================================



extension MainTabBarViewController {
    
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
        let addProvisionVC = storyboard?.instantiateViewController(withIdentifier: AddprovisionViewController.STORYBOARD_ID) as! AddprovisionViewController
        present(addProvisionVC, animated: true)
    }
}
