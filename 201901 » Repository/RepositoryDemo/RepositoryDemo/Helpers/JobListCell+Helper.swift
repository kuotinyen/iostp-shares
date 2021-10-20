//
//  JobListCell+Helper.swift
//  SingleSourceRepositoryDemo
//
//  Created by TING YEN KUO on 2019/1/24.
//  Copyright © 2019 TING YEN KUO. All rights reserved.
//

import UIKit 

class BaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {}
}

extension UIColor {
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

struct Theme {
    static var darkBlue01 = UIColor(rgb: 0x2e3550)
    static var whiteColor = UIColor.white
    static var grayColor = UIColor(rgb: 0xe8e9f2)
    static var blue01 = UIColor(rgb: 0x4d8fff)
    static var gray01 = UIColor(rgb: 0x827f8d)
    static let shadow00 = UIColor(rgb: 0x3F4B7A)
    static let shadow0216 = UIColor(rgb: 0x3f4b7a)
    static let actionPannelWhite = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 0.9)
}

extension UIView {
    
    @discardableResult
    func addCardShadow() -> Self {
        self.addShadow(ofColor: Theme.shadow0216, radius: 4, offset: CGSize(width: 0, height: 1), opacity: 0.16)
        return self
    }
    
    public func addShadow(ofColor color: UIColor = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0), radius: CGFloat = 3, offset: CGSize = .zero, opacity: Float = 0.5) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
    
}
