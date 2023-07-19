//
//  MainTabBar.swift
//  SquikitLite
//
//  Created by Benjamin on 22/06/2023.
//

import UIKit



//===========================================================
// MARK: MainTabBar class
//===========================================================



class MainTabBar: UITabBar {
    
    // MARK: Properties
    
    private var currentShapeLayer: CALayer?
    private var currentMiddleButton: UIButton?
    public var didTapMiddleButton: (() -> ())?
}



//===========================================================
// MARK: draw
//===========================================================



extension MainTabBar {
    
    override func draw(_ rect: CGRect) {
        addCustomBackground()
        addMiddleButton()
        unselectedItemTintColor = UIColor.inactiveButton
    }
}



//===========================================================
// MARK: Animation start appli
//===========================================================



extension MainTabBar {
    
    func middleButtonAnimation() {
        guard let middleButton = currentMiddleButton else {return}
        print(middleButton.frame.origin.y)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut) {
            middleButton.transform = CGAffineTransform(translationX: 0, y: -24)
        } completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5) {
                middleButton.transform = .identity
            }
        }
    }
}


//===========================================================
// MARK: Custom background
//===========================================================



extension MainTabBar {
        
    private func addCustomBackground() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.fillColor = CGColor.mainTabBar
        shapeLayer.lineWidth = 1.0
        shapeLayer.addLargeShadow()
        
        if let oldShapeLayer = currentShapeLayer {
            layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            layer.insertSublayer(shapeLayer, at: 0)
        }
        currentShapeLayer = shapeLayer
    }

    
    private func createPath() -> CGPath {
        let path = UIBezierPath()
        let centerWidth = frame.width / 2
        let spaceForButton = Dimensions.floatingButtonDim + 16
        
        // get tabBar height
        var mainTabBarHeight: CGFloat
        if self.traitCollection.verticalSizeClass == .compact {
            // iphone is landscape
            mainTabBarHeight = Dimensions.mainTabBarHeightCompact
        } else {
            mainTabBarHeight = Dimensions.mainTabBarHeight
        }
        
        // get tabBar horizontal margin
        let mainTabBarHorizontalMargin = frame.width / 4 - mainTabBarHeight/2 - 8.0 // -8 pour un peu plus d'espace entre les boutons et le background
        
        // start path
        path.move(to: CGPoint(x: mainTabBarHorizontalMargin + mainTabBarHeight/2, y: 0))
        path.addLine(to: CGPoint(x: centerWidth - spaceForButton/2, y: 0))
        // space for button
        path.addArc(
            withCenter: CGPoint(x: centerWidth, y: -Dimensions.mainTabBarMiddleButtonOffset),
            radius: spaceForButton/2,
            startAngle: CGFloat.pi - atan(Dimensions.mainTabBarMiddleButtonOffset*2/spaceForButton),
            endAngle: atan(Dimensions.mainTabBarMiddleButtonOffset*2/spaceForButton),
            clockwise: false)
        // right corner radius
        path.addLine(to: CGPoint(x: frame.width - mainTabBarHorizontalMargin - mainTabBarHeight/2, y: 0))
        path.addArc(
            withCenter: CGPoint(x: frame.width - mainTabBarHorizontalMargin - mainTabBarHeight/2, y: mainTabBarHeight/2),
            radius: mainTabBarHeight/2,
            startAngle: 3*CGFloat.pi/2,
            endAngle: CGFloat.pi/2,
            clockwise: true)
        // left corner radius
        path.addLine(to: CGPoint(x: mainTabBarHorizontalMargin + mainTabBarHeight/2, y: mainTabBarHeight))
        path.addArc(
            withCenter: CGPoint(x: mainTabBarHorizontalMargin + mainTabBarHeight/2, y: mainTabBarHeight/2),
            radius: mainTabBarHeight/2,
            startAngle: CGFloat.pi/2,
            endAngle: 3*CGFloat.pi/2,
            clockwise: true)
        // close path
        path.close()
        
        return path.cgPath
    }
}



//===========================================================
// MARK: add middle button
//===========================================================



extension MainTabBar {
    
    private func addMiddleButton() {
        if let middleButton = currentMiddleButton {
            // bouton déjà créé, update du frame
            middleButton.frame = CGRect(x: (frame.width / 2) - Dimensions.floatingButtonDim/2, y: -Dimensions.floatingButtonDim/2 - Dimensions.mainTabBarMiddleButtonOffset, width: Dimensions.floatingButtonDim, height: Dimensions.floatingButtonDim)
            return
        }
        // création bouton
        currentMiddleButton = UIButton(frame: CGRect(x: (frame.width / 2) - Dimensions.floatingButtonDim/2, y: -Dimensions.floatingButtonDim/2 - Dimensions.mainTabBarMiddleButtonOffset, width: Dimensions.floatingButtonDim, height: Dimensions.floatingButtonDim))
        
        guard let button = currentMiddleButton else {return}
        
        button.setBackgroundImage(UIImage(named: "ic_addButton"), for: .normal)
        button.addLargeShadow()
        button.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)
        addSubview(button)
    }
    
    @objc func menuButtonAction(sender: UIButton) {
        didTapMiddleButton?()
    }
}



//===========================================================
// MARK: change clickable zone for middle button
//===========================================================



extension MainTabBar {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if isHidden {
            return super.hitTest(point, with: event)
        }
        
        guard let button = currentMiddleButton else {
            return super.hitTest(point, with: event)
        }
    
        let from = point
        let to = button.center

        return sqrt((from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)) <= Dimensions.floatingButtonDim/2 ? currentMiddleButton : super.hitTest(point, with: event)
    }
}
