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
        badgeLabel.text = "\(badgeNumber)"
        
        if badgeNumber > 0 && badgeLabel.superview == nil
        {
            view.addSubview(self.badgeLabel)
            // contraintes
            badgeLabel.widthAnchor.constraint(equalToConstant: badgeDim).isActive = true
            badgeLabel.heightAnchor.constraint(equalToConstant: badgeDim).isActive = true
            badgeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: badgeDim/2).isActive = true
            badgeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -badgeDim/2).isActive = true
        }
        else if badgeNumber == 0 && badgeLabel.superview != nil
        {
            badgeLabel.removeFromSuperview()
            return
        }
        
        // animation
        MyAnimations.disappearAndReappear(forViews: [badgeLabel])
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "view")
    }
}
