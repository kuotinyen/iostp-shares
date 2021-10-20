//
//  JobMapInfoCell.swift
//  ujob
//
//  Created by TING YEN KUO on 2019/1/6.
//  Copyright © 2019 Ting-Yen, Kuo. All rights reserved.
//

import UIKit
import SDWebImage
import MapKit
import ChainsKit
import ImageProvider

class JobMapInfoCell: BaseTableViewCell {
    
    var viewModel: JobListCellViewModel? {
        didSet {
            
            guard let job = viewModel?.job else { return }
            
            addressLabel.text = job.address
            
            map.removeAnnotationsOnMap(map.annotations)
               .addAnnotationOnMap(JobPinModel(with: job))
               .showAnnotationsOnMap(map.annotations, animated: false)
        }
    }
    
    let cardView: UIView = {
        
        let view = UIView()
            .backgroundColor(.white)
            .cornerRadius(10)
            .masksToBounds(true)
            .addCardShadow()
        
        return view
    }()
    
    let addressIcon: UIImageView = {
        
        let iv = UIImageView()
            .contentMode(.scaleAspectFit)
            .image(Images[ImageKeys.mapIcon]!)
        
        return iv
    }()
    
    let addressLabel: UILabel = {
        
        let label = UILabel()
            .text("")
            .textColor(Theme.darkBlue01)
            .font(UIFont.systemFont(ofSize: 14))
            .numberOfLines(2)
        
        return label
    }()
    
    let map: MKMapView = {
        
        let map = MKMapView()
            .isUserInteractionEnabled(false)
        
        return map
    }()
    
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
        
        cardView.addSubview(addressIcon)
        addressIcon.snp.makeConstraints { (make) in
            make.top.equalTo(cardView).offset(16.5)
            make.left.equalTo(cardView).offset(17.5)
            make.width.equalTo(10.5)
            make.height.equalTo(13.6)
        }
        
        cardView.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(addressIcon.snp.right).offset(3.1)
            make.centerY.equalTo(addressIcon)
            make.right.equalTo(cardView).offset(-18)
        }
        
        cardView.addSubview(map)
        map.snp.makeConstraints { (make) in
            make.top.equalTo(addressIcon.snp.bottom).offset(15)
            make.left.right.equalTo(cardView).inset(18)
            make.height.equalTo(150).priority(.low)
            make.bottom.equalTo(cardView).offset(-13)
        }
        
    }
    
}

