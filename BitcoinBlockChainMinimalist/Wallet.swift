//
//  Wallet.swift
//  BitcoinBlockChainMinimalist
//
//  Created by 陳囿豪 on 2017/07/19.
//  Copyright © 2017年 yasuoyuhao. All rights reserved.
//

import UIKit


struct BTCWallet {
    
    let hash160: String
    let address: String
    let n_tx: Int
    let total_received: Double
    let total_sent: Double
    let final_balance: Double
    
    init(dictionary: NSDictionary) {
        
        self.hash160 = dictionary["hash160"] as? String ?? ""
        self.address = dictionary["address"] as? String ?? ""
        self.n_tx = dictionary["n_tx"] as? Int ?? 0
        self.total_received = dictionary["total_received"] as? Double ?? 0
        self.total_sent = dictionary["total_sent"] as? Double ?? 0
        self.final_balance = dictionary["final_balance"] as? Double ?? 0
    }
    
}

struct ETHWallet {
    
    let address :String
    let balance : Double
    let code : String
    
    init(dictionary: NSDictionary) {
        self.address = dictionary["address"] as? String ?? ""
        self.balance = dictionary["balance"] as? Double ?? 0
        self.code = dictionary["code"] as? String ?? ""
    }

}

struct ZECWallet {

    let address:String
    let balance: Double
    let sentCount: Int
    let recvCount: Int
    let totalSent: Double
    let totalRecv: Double
    
    init(dictionary: NSDictionary) {
        
        self.address = dictionary["address"] as? String ?? ""
        self.balance = dictionary["balance"] as? Double ?? 0
        self.sentCount = dictionary["sentCount"] as? Int ?? 0
        self.recvCount = dictionary["recvCount"] as? Int ?? 0
        self.totalSent = dictionary["totalSent"] as? Double ?? 0
        self.totalRecv = dictionary["totalRecv"] as? Double ?? 0
    }
    
    
}










