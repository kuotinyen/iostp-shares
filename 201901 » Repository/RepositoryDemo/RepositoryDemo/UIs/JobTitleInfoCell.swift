//
//  JobTitleInfoCell.swift
//  ujob
//
//  Created by TING YEN KUO on 2019/1/6.
//  Copyright © 2019 Ting-Yen, Kuo. All rights reserved.
//

import UIKit
import SDWebImage
import ImageProvider

class JobTitleInfoCell: BaseTableViewCell {
    
    let cardView: UIView = {
        return UIView()
            .backgroundColor(.white)
            .cornerRadius(10)
            .masksToBounds(true)
            .addCardShadow()
    }()
    
    let companyImageView: UIImageView = {
        return UIImageView()
            .contentMode(.scaleAspectFit)
            .masksToBounds(true)
    }()
    
    let jobTitleLabel: UILabel = {
        return UILabel()
            .text("-")
            .textColor(Theme.darkBlue01)
            .font(UIFont.systemFont(ofSize: 16))
    }()
    
    let companyNameLabel: UILabel = {
        return UILabel()
            .text("-")
            .textColor(Theme.gray01)
            .font(UIFont.systemFont(ofSize: 14))
    }()
    
    let salaryIcon: UIImageView = {
        return UIImageView()
            .contentMode(.scaleAspectFit)
            .image(Images[ImageKeys.salaryIcon]!)
    }()
    
    let salaryLabel: UILabel = {
        return UILabel()
            .text("-")
            .textColor(Theme.blue01)
            .font(UIFont.systemFont(ofSize: 14))
            .numberOfLines(2)
    }()
    
    var viewModel: JobListCellViewModel? {
        didSet {
            guard let job = viewModel?.job else { return }
            
            if let companyImageString = job.companyImageString {
                let url = URL(string: companyImageString)
                companyImageView.sd_setImage(with: url, completed: nil)
            }
            
            jobTitleLabel.text = job.title
            companyNameLabel.text = job.companyName
            salaryLabel.text = job.salary
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
        
        cardView.addSubview(companyImageView)
        companyImageView.snp.makeConstraints { (make) in
            make.top.equalTo(cardView).offset(19)
            make.width.height.equalTo(82)
            make.left.equalTo(cardView).offset(17)
        }
        
        cardView.addSubview(jobTitleLabel)
        jobTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(companyImageView).inset(17)
            make.left.equalTo(companyImageView.snp.right).offset(10)
            make.right.equalTo(cardView).offset(-10)
            make.height.equalTo(20)
        }
        
        cardView.addSubview(companyNameLabel)
        companyNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(jobTitleLabel.snp.bottom).offset(13)
            make.left.equalTo(jobTitleLabel)
            make.right.equalTo(cardView).offset(-10)
            make.bottom.equalTo(companyImageView).offset(-13)
        }
        
        cardView.addSubview(salaryIcon)
        salaryIcon.snp.makeConstraints { (make) in
            make.top.equalTo(companyImageView.snp.bottom).offset(14)
            make.left.equalTo(cardView).offset(21)
            make.width.height.equalTo(13)
        }
        
        cardView.addSubview(salaryLabel)
        salaryLabel.snp.makeConstraints { (make) in
            make.top.equalTo(salaryIcon).offset(-2)
            make.left.equalTo(salaryIcon.snp.right).offset(4)
            make.right.equalTo(cardView).offset(-15)
            make.bottom.equalTo(cardView).offset(-9)
        }
        
    }
    
}
