//
//  AssetPriceListBlockChainCell.swift
//  BitcoinBlockChainMinimalist
//
//  Created by 陳囿豪 on 2017/07/11.
//  Copyright © 2017年 yasuoyuhao. All rights reserved.
//

import UIKit



class AssetPriceListBlockChainCell: UITableViewCell {
    
    var blockChainTickerData : BlockChainTickerData? {
        
        didSet {
            setupBlockChainTickerDatas()
        }
    }
    
    let blockChainAssetName : UILabel = {
        
        let lb = UILabel()
        lb.textColor = .lightGray
        lb.font = UIFont.boldSystemFont(ofSize: 9)
        
        return lb
    }()
    
    let blockChainAssetImage : UIImageView = {
        
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage()
        return iv
    }()
    
    let percentChangeLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.hightLightWhite
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.minimalLightGray
        
        self.textLabel?.textColor = UIColor.white
        self.textLabel?.numberOfLines = 0
        
        
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 56, y: textLabel!.frame.origin.y, width: textLabel!.frame.width - 32, height: textLabel!.frame.height)
        let separateLine = UIView()
        separateLine.backgroundColor = UIColor.lightGray
        
        addSubview(blockChainAssetImage)
        blockChainAssetImage.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 36, height: 36)
        blockChainAssetImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
        addSubview(blockChainAssetName)
        blockChainAssetName.anchor(top: blockChainAssetImage.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        blockChainAssetName.centerXAnchor.constraint(equalTo: blockChainAssetImage.centerXAnchor).isActive = true
        
        addSubview(separateLine)
        separateLine.anchor(top: nil, left: textLabel?.leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        addSubview(percentChangeLabel)
        percentChangeLabel.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        percentChangeLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    
    fileprivate func setupBlockChainTickerDatas() {
        
        guard let blockChainTickerData = blockChainTickerData else { return }
        
        let priceString = NSString(format: "%.3f", blockChainTickerData.last)
        let volume = NSString(format: "%.2f", blockChainTickerData.baseVolume)
        var percentChangeString = String(format: "%.2f", blockChainTickerData.percentChange * 100)
        
        let attributedText = NSMutableAttributedString.creativeNSMutableAttributedString()
        attributedText.append(NSAttributedString.addNSAttributedString(string: priceString as String, ofSize: 18, color: .white, bold: true))
        attributedText.append(NSAttributedString.enterN(ofSize: 6))
        attributedText.append(NSAttributedString.addNSAttributedString(string: "\(volume as String) USD", ofSize: 10, color: .lightGray))
        self.textLabel?.attributedText = attributedText
        
        
        if blockChainTickerData.percentChange < 0 {
            percentChangeString = percentChangeString + " % "
            percentChangeLabel.backgroundColor = UIColor.aboutMeGreen
        } else {
            percentChangeString = " +" + percentChangeString + " % "
            percentChangeLabel.backgroundColor = UIColor.alphabetRed
        }
        percentChangeLabel.text = percentChangeString
        percentChangeLabel.layer.cornerRadius = 3
        percentChangeLabel.layer.masksToBounds = true
        
        let blockChainName = NSString(string: blockChainTickerData.blockChainName)
        let range = NSRange(location: blockChainName.length - 3 ,length: 3)
        let blockChainNameString = blockChainName.substring(with: range)
        blockChainAssetName.text = blockChainNameString as String
        
        
        
        if let image = blockChainTickerData.image {
            self.blockChainAssetImage.image = image
            
            if blockChainNameString == "ETH" || blockChainNameString == "XMR" {
                self.blockChainAssetImage.backgroundColor = UIColor.lightGray
                self.blockChainAssetImage.layer.cornerRadius = 36 / 2
            }
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}







