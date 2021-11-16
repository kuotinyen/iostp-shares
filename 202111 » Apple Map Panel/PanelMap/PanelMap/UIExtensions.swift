//
//  UIExtensions.swift
//  PanelMap
//
//  Created by TK on 2021/11/16.
//

import UIKit
import SnapKit

extension UIView {
    var heightUnderStatusBar: CGFloat {
        frame.height - UIApplication.shared.statusBarHeight
    }
}

extension UIApplication {
    var statusBarHeight: CGFloat {
        UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }
    
    var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .first(where: { $0 is UIWindowScene })
                .flatMap({ $0 as? UIWindowScene })?
                .windows
                .first(where: \.isKeyWindow)
        }
        return UIApplication.shared.keyWindow
    }
}

// Constraint = NSLayoutConstraint
// Constraint.value = NSLayoutConstraint.constant

extension Constraint {
    var value: CGFloat {
        get { layoutConstraints[0].constant }
        set { layoutConstraints[0].constant = newValue }
    }
}
