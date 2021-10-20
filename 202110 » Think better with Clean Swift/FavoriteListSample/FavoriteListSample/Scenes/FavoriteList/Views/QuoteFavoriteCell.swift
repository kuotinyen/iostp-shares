//
//  QuoteFavoriteCell.swift
//  MultipleSelectionSample
//
//  Created by TK on 2021/10/19.
//

import UIKit

class QuoteFavoriteCell: UITableViewCell {
    private let nameLabel = UILabel()
    private let symbolLabel = UILabel()
    private let actionImageView: UIImageView = {
        let iv = UIImageView()
        iv.snp.makeConstraints { $0.size.equalTo(CGSize(width: 24, height: 24)) }
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        selectionStyle = .none
        [nameLabel, symbolLabel].forEach { $0.textColor = .black }
        
        let quoteStackView = UIStackView(arrangedSubviews: [nameLabel, symbolLabel])
        quoteStackView.axis = .vertical
        quoteStackView.alignment = .leading
        quoteStackView.spacing = 4
        
        let stackView = UIStackView(arrangedSubviews: [quoteStackView, actionImageView])
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalTo(contentView.layoutMarginsGuide) }
    }
    
    func populate(with viewModel: QuoteViewModel) {
        self.nameLabel.text = viewModel.name
        self.symbolLabel.text = viewModel.symbol
        self.actionImageView.image = viewModel.actionImage
    }
}

