//
//  JobListCell.swift
//  ujob
//
//  Created by TING YEN KUO on 2019/1/4.
//  Copyright © 2019 Ting-Yen, Kuo. All rights reserved.
//

import UIKit
import ChainsKit
import ImageProvider
import SDWebImage
import SnapKit

class JobListCell: BaseTableViewCell {
    
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
            .text("iOS 工程師")
            .textColor(Theme.darkBlue01)
            .font(UIFont.systemFont(ofSize: 16))
    }()
    
    let companyNameLabel: UILabel = {
        
        return UILabel()
            .text("bandzo 伴奏王")
            .textColor(Theme.gray01)
            .font(UIFont.systemFont(ofSize: 14))
    }()
    
    let addressLabel: UILabel = {
        
        let label = UILabel()
            .text("台北市 內湖區")
            .textColor(Theme.darkBlue01)
            .font(UIFont.systemFont(ofSize: 14))
        
        return label
    }()
    
    let salaryIcon: UIImageView = {
        
        let image = Images[ImageKeys.salaryIcon]!
        
        return UIImageView()
            .contentMode(.scaleAspectFit)
            .image(image)
    }()
    
    let salaryLabel: UILabel = {
        
        return UILabel()
            .text("月薪 TWD 40000 ~ 100000")
            .textColor(Theme.blue01)
            .font(UIFont.systemFont(ofSize: 14))
            .numberOfLines(2)
    }()
    
    lazy var rightBgView: UIView = {
        
        let tagGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(handleRightBgViewClicked))
        
        let view = UIView()
            .backgroundColor(.clear)
            .addGestureRecognizerOnView(tagGestureRecognizer)
        
        return view
    }()
    
    lazy var collectIcon: UIButton = {
        
        let image = Images[ImageKeys.collectIcon]!
        let imageSel = Images[ImageKeys.collectIconSel]!
        
        let button = UIButton()
            .image(image, for: .normal)
            .image(imageSel, for: .selected)
        
        return button
    }()
    
    @objc func handleRightBgViewClicked() {}
    
    var viewModel: JobListCellViewModel? {
        didSet {
            guard let job = viewModel?.job else { return }
            
            if let companyImageString = job.companyImageString {
                let url = URL(string: companyImageString)
                companyImageView.sd_setImage(with: url, completed: nil)
            } else {
                companyImageView.image = nil
            }
            
            jobTitleLabel.text = job.title
            companyNameLabel.text = job.companyName
            salaryLabel.text = job.salary
            addressLabel.text = job.address
            collectIcon.isSelected = job.isCollected
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle(.none)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        super.setupViews()
        
        setupUI()
    }
    
}

// ----------------------------------------------------------------------------------
/// UI Layout
// MARK: - UI Layout
// ----------------------------------------------------------------------------------

extension JobListCell {
    
    func setupUI() {
        self.backgroundColor(.clear)
        contentView.backgroundColor(.clear)
        
        contentView.addSubview(cardView)
        cardView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(8)
            make.left.right.equalTo(contentView).inset(12)
            make.bottom.equalTo(contentView)
        }
        
        cardView.addSubview(rightBgView)
        rightBgView.snp.makeConstraints { (make) in
            make.top.bottom.right.equalTo(cardView)
            make.width.equalTo(70)
        }
        
        cardView.addSubview(companyImageView)
        companyImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(cardView)
            make.width.height.equalTo(82)
            make.left.equalTo(cardView).offset(17)
        }
        
        cardView.addSubview(jobTitleLabel)
        jobTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(cardView).inset(16)
            make.left.equalTo(companyImageView.snp.right).offset(10)
            make.right.equalTo(rightBgView.snp.left).offset(-10)
        }
        
        cardView.addSubview(companyNameLabel)
        companyNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(jobTitleLabel.snp.bottom).offset(5)
            make.left.equalTo(jobTitleLabel)
            make.right.equalTo(rightBgView.snp.left).offset(-10)
        }
        
        cardView.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(companyNameLabel.snp.bottom).offset(4)
            make.left.equalTo(jobTitleLabel)
            //            make.right.equalTo(cardView).offset(-15)
            make.right.equalTo(rightBgView.snp.left).offset(-10)
        }
        
        cardView.addSubview(salaryIcon)
        salaryIcon.snp.makeConstraints { (make) in
            make.top.equalTo(addressLabel.snp.bottom).offset(7)
            make.left.equalTo(jobTitleLabel)
            make.width.height.equalTo(13)
        }
        
        cardView.addSubview(salaryLabel)
        salaryLabel.snp.makeConstraints { (make) in
            make.top.equalTo(salaryIcon).offset(-2)
            make.left.equalTo(salaryIcon.snp.right).offset(4)
            make.right.equalTo(rightBgView.snp.left).offset(-10)
            make.bottom.equalTo(cardView).offset(-16)
        }
        
        rightBgView.addSubview(collectIcon)
        collectIcon.snp.makeConstraints { (make) in
            make.width.equalTo(20)
            make.height.equalTo(18)
            make.right.equalTo(rightBgView).offset(-15)
            make.bottom.equalTo(rightBgView).offset(-17)
        }
    }
    
}
