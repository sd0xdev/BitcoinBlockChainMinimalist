//
//  SelectedPriceListCell.swift
//  BitcoinBlockChainMinimalist
//
//  Created by 陳囿豪 on 2017/07/17.
//  Copyright © 2017年 yasuoyuhao. All rights reserved.
//

import UIKit

class SelectedPriceListCell: UICollectionViewCell {
    
    var list : String? {
        didSet {
            titleLabel.text = list
        }
    }
    let titleLabel : UILabel = {
       
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.minimalLightGray
        
        addSubview(titleLabel)
        titleLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
















