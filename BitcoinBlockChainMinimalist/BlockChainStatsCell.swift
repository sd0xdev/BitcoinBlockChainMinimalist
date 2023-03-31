//
//  BlockChainStatsCell.swift
//  BitcoinBlockChainMinimalist
//
//  Created by 陳囿豪 on 2017/07/17.
//  Copyright © 2017年 yasuoyuhao. All rights reserved.
//

import UIKit



class BlockChainStatsCell: UITableViewCell {
    
    var section : Int?
    
    var title : String? {
        didSet {
            guard let title = title else { return }
            blockChainAssetName.text = title + "： "
        }
    }
    
    var listDatas: [Dictionary<String, Any>]? {
        didSet {
            setData()
        }
    }
    
    var blockChainStats : String? {
        
        didSet{
            textLabel?.text = blockChainStats
        }
    }
    
    let blockChainAssetName : UILabel = {
        
        let lb = UILabel()
        lb.textColor = UIColor.white
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.minimalLightGray
        
        self.textLabel?.textColor = UIColor.white
        self.textLabel?.numberOfLines = 0
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let separateLine = UIView()
        separateLine.backgroundColor = UIColor.lightGray
        
        addSubview(blockChainAssetName)
        blockChainAssetName.anchor(top: nil, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        blockChainAssetName.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(separateLine)
        separateLine.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 21, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        textLabel?.frame = CGRect(x: frame.midX, y: textLabel!.frame.origin.y, width: frame.width / 2 - 12 , height: textLabel!.frame.height)
        
        
    }
    
    fileprivate func setData() {
        
        guard let listDatas = listDatas, let section = section, let title = title else { return }
        
        if let data = listDatas[section][title] {
            
            let format = NumberFormatter()
            format.numberStyle = .decimal
            
            guard let number = data as? NSNumber else { return }
            let dataString = format.string(from: number)
            
            if dataString == "0" {
                textLabel?.text = "- "
                blockChainAssetName.textColor = .gray
                textLabel?.textColor = .gray
                backgroundColor = UIColor.minimalGray
            } else {
                
                textLabel?.text = dataString
                textLabel?.adjustsFontSizeToFitWidth = true
                blockChainAssetName.textColor = .white
                textLabel?.textColor = .white
                backgroundColor = UIColor.minimalLightGray
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
