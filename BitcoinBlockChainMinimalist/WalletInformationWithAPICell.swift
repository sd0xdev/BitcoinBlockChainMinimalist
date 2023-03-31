//
//  WalletInformationWithAPICell.swift
//  BitcoinBlockChainMinimalist
//
//  Created by 陳囿豪 on 2017/07/19.
//  Copyright © 2017年 yasuoyuhao. All rights reserved.
//

import UIKit


class WalletInformationWithAPICell: UITableViewCell {
    
    var listTitle : String? {
        didSet {
            setTitle()
        }
    }
    
    var listDatas : Dictionary<String, Any>? {
        didSet {
            setData()
        }
    }
    
    let titleLabel : UILabel = {
        
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        lb.textColor = .white
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = UIColor.minimalLightGray
        
        addSubview(titleLabel)
        titleLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        textLabel?.frame = CGRect(x: titleLabel.frame.maxX + 16, y: textLabel!.frame.origin.y, width: frame.width - titleLabel.frame.width - 16 - 12, height: textLabel!.frame.height)
        
        let separateLine = UIView()
        separateLine.backgroundColor = UIColor.lightGray
        
        addSubview(separateLine)
        separateLine.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 21, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
    }
    
    fileprivate func setTitle() {
        DispatchQueue.main.async {
            self.titleLabel.text = self.listTitle
        }
    }
    
    fileprivate func setData() {
        
        guard let listTitle = listTitle ,let listData = listDatas?[listTitle] else { return }
        
        if let int = listData as? Int {
            self.setStyle(dataString: int.description)
        } else if let number = listData as? Double {
            self.setStyle(dataString: String(format: "%.10f", number))
        } else if let string = listData as? String {
            self.setStyle(dataString: string)
        }
    }
    
    fileprivate func setStyle(dataString: String?) {
        
        DispatchQueue.main.async {
            
            if dataString == "nil" {
                self.textLabel?.text = "- "
                self.titleLabel.textColor = .gray
                self.textLabel?.textColor = .gray
                self.backgroundColor = UIColor.minimalGray
                
            } else {
                
                self.textLabel?.text = dataString
                self.textLabel?.adjustsFontSizeToFitWidth = true
                self.titleLabel.textColor = .white
                self.textLabel?.textColor = .white
                self.backgroundColor = UIColor.minimalLightGray
            }
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
