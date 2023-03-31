//
//  AboutBitcoin.swift
//  BitcoinBlockChainMinimalist
//
//  Created by 陳囿豪 on 2017/07/13.
//  Copyright © 2017年 yasuoyuhao. All rights reserved.
//

import UIKit


private let cellId = "cellId"

class AboutBitcoin: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.rgb(red: 247, green: 249, blue: 242)
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(AboutBitcoinCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.contentInset = UIEdgeInsets(top: -16, left: 0, bottom: 0, right: 0)
        setupAbout()
        setupSignature()
    }

    let enterN = NSAttributedString.enterN(ofSize: 4)
    let enterNL = NSAttributedString.enterN(ofSize: 13)
    
    lazy var attributedTextForAbout = NSMutableAttributedString.creativeNSMutableAttributedString()
    
    lazy var attributedTextForSignature = NSMutableAttributedString.creativeNSMutableAttributedString()
    
    fileprivate func setupSignature() {
        
        attributedTextForSignature = NSMutableAttributedString.creativeNSMutableAttributedString()
        attributedTextForSignature.append(NSAttributedString.addNSAttributedString(string: "  Copyright © 2017年 yasuoyuhao. All rights reserved.", ofSize: 12, color: nil))
    }
    
    
    
    fileprivate func setupAbout() {
        
        let title = "極簡比特幣"
        
        let contentTag1 = "本服務與價格來自：Poloniex.com。"
        
        let contentTag2 = "圖片來源：WiKi與各數位資產官方網站。"
        
        let contentTag3 = "開發者：yasuoyuhao"
        
        let contentTag4 = "有任何問題可以寄信至：yasuoyuhao@gmail.com"
        
        let ofSize17:CGFloat = 17
        
        attributedTextForAbout.append(enterN)
        
        attributedTextForAbout.append(NSMutableAttributedString.addNSAttributedString(string: title, ofSize: 21.51, color: nil, bold: true))
        attributedTextForAbout.append(enterN)
        
        attributedTextForAbout.append(NSMutableAttributedString.addNSAttributedString(string: contentTag1, ofSize: ofSize17, color: nil))
        attributedTextForAbout.append(enterN)
        
        attributedTextForAbout.append(NSMutableAttributedString.addNSAttributedString(string: contentTag2, ofSize: ofSize17, color: nil))
        attributedTextForAbout.append(enterN)
        
        attributedTextForAbout.append(NSMutableAttributedString.addNSAttributedString(string: contentTag3, ofSize: ofSize17, color: nil))
        
        attributedTextForAbout.append(enterN)
        
        attributedTextForAbout.append(NSMutableAttributedString.addNSAttributedString(string: contentTag4, ofSize: 15, color: UIColor.gray))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .justified
        attributedTextForAbout = NSMutableAttributedString.paragraphSpaceLine(attributedText: attributedTextForAbout, paragraphStyle: paragraphStyle)
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AboutBitcoinCell
        
        if indexPath.item == 0 {
            cell.messageLabel.attributedText = attributedTextForAbout
        } else {
            cell.messageLabel.attributedText = attributedTextForSignature
        }
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == 0 {
            
            let height = attributedTextForAbout.heightWithConstrainedWidth(width: view.frame.width - 12 - 16) + 20
            
            return CGSize(width: view.frame.width, height: height)
            
        } else if indexPath.item == 1 {
            
            let height = attributedTextForSignature.heightWithConstrainedWidth(width: view.frame.width - 12 - 16) + 20
            
            return CGSize(width: view.frame.width, height: height)
            
        } else {
            return CGSize(width: view.frame.width, height: view.frame.width)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
