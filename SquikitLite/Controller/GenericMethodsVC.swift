//
//  GenericMethodsVC.swift
//  SquikitLite
//
//  Created by Benjamin on 08/07/2023.
//

import Foundation
import UIKit


//===========================================================
// MARK: GenericMethodsVC class
//===========================================================



class GenericMethodsVC {
    
}



//===========================================================
// MARK: BSD detail prov
//===========================================================



extension GenericMethodsVC {
    
    static func showProvBSD(viewController: UIViewController, forProvisionDP provDP: [String: [ProvisionDisplayProvider]], atIndexPath indexPath: IndexPath, withHeaderTab headers: [String]) {
        guard indexPath.section < headers.count, let provsDPInSection = provDP[headers[indexPath.section]] else {return}
        if indexPath.row >= provsDPInSection.count {return}
        
        // BSD détail provision
        let provisionBSD = viewController.storyboard?.instantiateViewController(withIdentifier: ProvisionsBSDViewController.STORYBOARD_ID) as! ProvisionsBSDViewController
        provisionBSD.o_provisionDP = provsDPInSection[indexPath.row]
        provisionBSD.o_provIndexPath = indexPath
        viewController.present(provisionBSD, animated: true)
    }
}
