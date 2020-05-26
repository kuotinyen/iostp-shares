//
//  PNPaymentDutchHeader.swift
//  Payman
//
//  Created by tkuo on 2020/5/17.
//  Copyright © 2020 com.tykuo. All rights reserved.
//

import UIKit
import SnapKit
import Then

class PNPaymentDutchHeader: UITableViewHeaderFooterView {
    var tapDutchClosure: (() -> Void)?

    static let height: CGFloat = {
        Constant.Height.DutchHeader
    }()

    private let dutchTitleLabel = UILabel().then {
        $0.textColor = Constant.Color.TitleLabelText
        $0.font = Constant.Font.TitleLabel
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    @objc func handleTapDutch() {
        tapDutchClosure?()
    }

    func populateHeader(with title: String) {
        dutchTitleLabel.text = title
    }
}

// MARK: - Private helper

private extension PNPaymentDutchHeader {
    func commonInit() {
        setupViews()
    }

    func setupViews() {
        contentView.backgroundColor = Constant.Color.Background
        contentView.directionalLayoutMargins = Constant.Margins

        contentView.addSubview(dutchTitleLabel)
        dutchTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalTo(contentView.layoutMarginsGuide)
        }

        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(handleTapDutch))
        addGestureRecognizer(tapRecognizer)
    }
}

// MARK: - Constant

private extension PNPaymentDutchHeader {
    enum Constant {
        static let Margins = NSDirectionalEdgeInsets(top: 0,
                                                     leading: 20,
                                                     bottom: 0,
                                                     trailing: 20)
        enum Color {
            static let Background: UIColor = .systemBlue
            static let TitleLabelText: UIColor = .white
        }

        enum Font {
            static let TitleLabel: UIFont = UIFont.systemFont(ofSize: 16,
                                                              weight: UIFont.Weight.bold)
        }

        enum Height {
            static let DutchHeader: CGFloat = 45
        }
    }
}
