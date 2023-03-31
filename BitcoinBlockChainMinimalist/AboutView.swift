//
//  AboutView.swift
//  BitcoinBlockChainMinimalist
//
//  Created by 陳囿豪 on 2017/07/13.
//  Copyright © 2017年 yasuoyuhao. All rights reserved.
//

import UIKit

private let cellId = "cellId"

class AboutView: UITableViewController {
    
    override func viewDidLoad() {
        
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let top : CGFloat = 5
        
        tableView.contentInset = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
        
        tableView.layoutMargins = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 0)
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.minimalGray
    }
    
    let list = ["關於 - 極簡比特幣"]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = list[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.minimalLightGray
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            
            let aboutBitcoin = AboutBitcoin(collectionViewLayout: UICollectionViewFlowLayout())
            navigationController?.pushViewController(aboutBitcoin, animated: true)
        }
        
        
    }
    
    
    
}















