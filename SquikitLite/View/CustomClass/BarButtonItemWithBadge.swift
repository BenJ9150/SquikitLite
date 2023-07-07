//
//  BarButtonItemWithBadge.swift
//  SquikitLite
//
//  Created by Benjamin on 07/07/2023.
//

import UIKit

class BarButtonItemWithBadge: UIBarButtonItem {

    //@IBInspectable
    public var badgeNumber: Int = 0 {
        didSet {
            self.updateBadge()
        }
    }
    
    private let badgeLabel: UILabel
    private let badgeDim: CGFloat = 20
    
    required public init?(coder aDecoder: NSCoder)
    {
        let label = UILabel()
        label.backgroundColor = .dlcUrgent
        label.alpha = 1
        label.layer.cornerRadius = badgeDim/2
        label.clipsToBounds = true
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.font = .badgeNotification
        label.layer.zPosition = 1
        self.badgeLabel = label
        
        super.init(coder: aDecoder)
        
        self.addObserver(self, forKeyPath: "view", options: [], context: nil)
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        self.updateBadge()
    }
    
    private func updateBadge()
    {
        guard let view = self.value(forKey: "view") as? UIView else { return }
        
        self.badgeLabel.text = "\(badgeNumber)"
        
        if self.badgeNumber > 0 && self.badgeLabel.superview == nil
        {
            view.addSubview(self.badgeLabel)
            
            self.badgeLabel.widthAnchor.constraint(equalToConstant: badgeDim).isActive = true
            self.badgeLabel.heightAnchor.constraint(equalToConstant: badgeDim).isActive = true
            self.badgeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: badgeDim/2).isActive = true
            self.badgeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -badgeDim/2).isActive = true
        }
        else if self.badgeNumber == 0 && self.badgeLabel.superview != nil
        {
            self.badgeLabel.removeFromSuperview()
        }
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "view")
    }
}
