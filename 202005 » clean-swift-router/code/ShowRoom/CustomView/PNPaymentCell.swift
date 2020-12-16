//
//  PNPaymentCell.swift
//  Payman
//
//  Created by tkuo on 2020/5/6.
//  Copyright © 2020 com.tykuo. All rights reserved.
//

import UIKit
import SnapKit

class PNPaymentCell: UITableViewCell {
    private let nameLabel = UILabel().then {
        $0.font = Constant.Font.Name
        $0.textColor = Constant.TextColor.Name
    }

    private let payerLabel = UILabel().then {
        $0.font = Constant.Font.Payer
        $0.textColor = Constant.TextColor.Payer
    }

    private let costLabel = UILabel().then {
        $0.font = Constant.Font.Cost
        $0.textColor = Constant.TextColor.Cost.Unknown
    }

    private let dateLabel = UILabel().then {
        $0.font = Constant.Font.Date
        $0.textColor = Constant.TextColor.Date
    }

    private let separator = UIView().then {
        $0.backgroundColor = Constant.SeparatorColor
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func populateCell(with viewModel: PaymentViewModel) {
        nameLabel.text = viewModel.name
        payerLabel.text = viewModel.payerName
        costLabel.text = viewModel.cost
        dateLabel.text = viewModel.dateString

        switch viewModel.payType {
        case .plus: costLabel.textColor = Constant.TextColor.Cost.Plus
        case .minus: costLabel.textColor = Constant.TextColor.Cost.Minus
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        costLabel.textColor = Constant.TextColor.Cost.Unknown
    }
}

// MARK: - Private Helper

extension PNPaymentCell {
    private func setupViews() {
        selectionStyle = .none
        contentView.directionalLayoutMargins = Constant.Margins

        let payerStackView = UIStackView(arrangedSubviews: [nameLabel, payerLabel])
        payerStackView.axis = .vertical
        payerStackView.alignment = .leading
        payerStackView.spacing = Constant.Spacing.PaymentStackView

        let paymentStackView = UIStackView(arrangedSubviews: [costLabel, dateLabel])
        paymentStackView.axis = .vertical
        paymentStackView.alignment = .trailing
        paymentStackView.spacing = Constant.Spacing.PaymentStackView

        let stackView = UIStackView(arrangedSubviews: [payerStackView, paymentStackView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill

        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView.layoutMarginsGuide)
        }
    }
}

// MARK: - Constant

extension PNPaymentCell {
    private enum Constant {
        static let Margins = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        static let SeparatorColor = UIColor(hex: 0xa8a8a8)

        enum TextColor {
            static let Name = UIColor(hex: 0x2e3550)
            static let Payer = UIColor(hex: 0x827f8d)
            static let Date = UIColor(hex: 0x827f8d)

            enum Cost {
                static let Unknown = UIColor.darkGray
                static let Plus = UIColor.systemGreen
                static let Minus = UIColor.systemRed
            }
        }

        enum Font {
            static let Name: UIFont = .systemFont(ofSize: 18, weight: .medium)
            static let Payer: UIFont = .systemFont(ofSize: 16, weight: .regular)
            static let Cost: UIFont = .systemFont(ofSize: 22, weight: .medium)
            static let Date: UIFont = .systemFont(ofSize: 16, weight: .regular)
        }

        enum Spacing {
            static let PaymentStackView: CGFloat = 3
        }
    }
}
