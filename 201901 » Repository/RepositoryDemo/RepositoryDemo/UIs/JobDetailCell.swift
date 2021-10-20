//
//  JobDetailCell.swift
//  ujob
//
//  Created by TING YEN KUO on 2019/1/6.
//  Copyright © 2019 Ting-Yen, Kuo. All rights reserved.
//

import UIKit
import SnapKit
import ChainsKit

class JobDetailCell: BaseTableViewCell {
    
    let cardView: UIView = {
        
        let view = UIView()
            .backgroundColor(.white)
            .cornerRadius(10)
            .masksToBounds(true)
            .addCardShadow()
        
        return view
    }()
    
    let titleLabel: UILabel = {
        
        let label = UILabel()
            .text("工作敘述")
            .textColor(Theme.gray01)
            .font(UIFont.systemFont(ofSize: 15))
            .numberOfLines(2)
        
        return label
    }()
    
    let contentLabel: UILabel = {
        
        let label = UILabel()
            .text("")
            .textColor(Theme.darkBlue01)
            .font(UIFont.systemFont(ofSize: 15))
            .numberOfLines(0)
        
        return label
    }()
    
    var viewModel: JobListCellViewModel? {
        didSet {
            guard let job = viewModel?.job else { return }
            contentLabel.text = job.requirement
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        self.backgroundColor(.clear)
            .selectionStyle(.none)
        
        contentView.backgroundColor(.clear)
        
        contentView.addSubview(cardView)
        cardView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(8)
            make.left.right.equalTo(contentView).inset(12)
            make.bottom.equalTo(contentView)
        }
        
        cardView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(cardView).offset(14)
            make.left.equalTo(cardView).offset(17)
        }
        
        cardView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(13)
            make.left.right.equalTo(cardView).inset(17)
            make.bottom.equalTo(cardView).offset(-15)
        }
        
    }
    
}

