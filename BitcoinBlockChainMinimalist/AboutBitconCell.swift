//
//  AboutBitconCell.swift
//  BitcoinBlockChainMinimalist
//
//  Created by 陳囿豪 on 2017/07/13.
//  Copyright © 2017年 yasuoyuhao. All rights reserved.
//

import UIKit

class AboutBitcoinCell : UICollectionViewCell {
    
    let messageLabel : UILabel = {
        
        let lb = UILabel()
        lb.numberOfLines = 0
        return lb
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(messageLabel)
        messageLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}

