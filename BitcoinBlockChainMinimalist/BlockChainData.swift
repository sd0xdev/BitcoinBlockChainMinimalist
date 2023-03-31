//
//  ChartData.swift
//  BitcoinBlockChainMinimalist
//
//  Created by 陳囿豪 on 2017/07/11.
//  Copyright © 2017年 yasuoyuhao. All rights reserved.
//

import UIKit


struct BlockChainChartData {
    
    let blockChainName : String
    let close : Double
    let date : Double
    let high : Double
    let low : Double
    let open : Double
    let quoteVolume : Double
    let volume : Double
    let weightedAverage : Double
    
    init(blockChainName:String, dictionary: NSDictionary) {
        
        self.blockChainName = blockChainName
        self.close = dictionary["close"] as? Double ?? 0.0
        self.date = dictionary["date"] as? Double ?? 0.0
        self.high = dictionary["high"] as? Double ?? 0.0
        self.low = dictionary["low"] as? Double ?? 0.0
        self.open = dictionary["open"] as? Double ?? 0.0
        self.quoteVolume = dictionary["quoteVolume"] as? Double ?? 0.0
        self.volume = dictionary["volume"] as? Double ?? 0.0
        self.weightedAverage = dictionary["weightedAverage"] as? Double ?? 0.0
    }
    
    
    
}


struct BlockChainTickerData {
    
    
    let blockChainName: String
    let id: Int
    let last: Double
    let lowestAsk: Double
    let highestBid: Double
    let percentChange: Double
    let baseVolume: Double
    let quoteVolume: Double
    let isFrozen: Int
    let high24hr: Double
    let low24hr: Double
    let image: UIImage?
    
    
    init(blockChainName:String, blockChainImage: UIImage? = nil , dictionary: NSDictionary) {
        
        self.blockChainName = blockChainName
        self.id = dictionary["id"] as? Int ?? 0
        self.last = (dictionary["last"] as? NSString)?.doubleValue ?? 0.0
        self.lowestAsk = (dictionary["lowestAsk"] as? NSString)?.doubleValue ?? 0.0
        self.highestBid = (dictionary["highestBid"] as? NSString)?.doubleValue ?? 0.0
        self.percentChange = (dictionary["percentChange"] as? NSString)?.doubleValue ?? 0.0
        self.baseVolume = (dictionary["baseVolume"] as? NSString)?.doubleValue ?? 0.0
        self.quoteVolume = (dictionary["quoteVolume"] as? NSString)?.doubleValue ?? 0.0
        self.isFrozen = dictionary["isFrozen"] as? Int ?? 0
        self.high24hr = (dictionary["high24hr"] as? NSString)?.doubleValue ?? 0.0
        self.low24hr = (dictionary["low24hr"] as? NSString)?.doubleValue ?? 0.0
        self.image = blockChainImage
    }
    
}

struct BTCBlockChainStats {
    
    let market_price_usd : Double
    let hash_rate : Double
    let total_fees_btc : Double
    let n_btc_mined : Double
    let n_tx : Double
    let n_blocks_mined : Int
    let minutes_between_blocks : Double
    let totalbc : Int
    let n_blocks_total  : Int
    let estimated_transaction_volume_usd : Double
    let blocks_size : Int
    let miners_revenue_usd : Double
    let nextretarget : Int
    let difficulty : Double
    let estimated_btc_sent : Double
    let miners_revenue_btc : Int
    let total_btc_sent : Double
    let trade_volume_btc : Double
    let trade_volume_usd : Double
    let timestamp : Int
    
    init(dictionary: NSDictionary) {
        
        self.market_price_usd = dictionary["market_price_usd"] as? Double ?? 0.0
        self.hash_rate = dictionary["hash_rate"] as? Double ?? 0.0
        self.total_fees_btc = dictionary["total_fees_btc"] as? Double ?? 0
        self.n_btc_mined = dictionary["n_btc_mined"] as? Double ?? 0
        self.n_tx = dictionary["n_tx"] as? Double ?? 0
        self.n_blocks_mined = dictionary["n_blocks_mined"] as? Int ?? 0
        self.minutes_between_blocks = dictionary["minutes_between_blocks"] as? Double ?? 0.0
        self.totalbc = dictionary["totalbc"] as? Int ?? 0
        self.n_blocks_total = dictionary["n_blocks_total"] as? Int ?? 0
        self.estimated_transaction_volume_usd = dictionary["estimated_transaction_volume_usd"] as? Double ?? 0.0
        self.blocks_size = dictionary["blocks_size"] as? Int ?? 0
        self.miners_revenue_usd = dictionary["miners_revenue_usd"] as? Double ?? 0.0
        self.nextretarget = dictionary["nextretarget"] as? Int ?? 0
        self.difficulty = dictionary["difficulty"] as? Double ?? 0
        self.estimated_btc_sent = dictionary["estimated_btc_sent"] as? Double ?? 0
        self.miners_revenue_btc = dictionary["miners_revenue_btc"] as? Int ?? 0
        self.total_btc_sent = dictionary["total_btc_sent"] as? Double ?? 0
        self.trade_volume_btc = dictionary["trade_volume_btc"] as? Double ?? 0.0
        self.trade_volume_usd = dictionary["trade_volume_usd"] as? Double ?? 0.0
        self.timestamp = dictionary["timestamp"] as? Int ?? 0
    }
}


struct ETHBlockChainStats {
    
    let blockTime: Double
    let difficulty: Double
    let hashRate: Double
    
    init(dictionary: NSDictionary) {
        
        self.blockTime = dictionary["blockTime"] as? Double ?? 0
        self.difficulty = dictionary["difficulty"] as? Double ?? 0
        self.hashRate = dictionary["hashRate"] as? Double ?? 0
    }
    
}

struct ZECBlockChainStats {
    
    let accounts: Int
    let blockHash: String
    let blockNumber: Int
    let difficulty: Double
    let hashrate: Double
    let meanBlockTime: Double
    let name: String
    let peerCount: Int
    let protocolVersion: Int
    let relayFee: Double
    let subVersion : String
    let totalAmount: Double
    let transactions: Int
    let version : Int
    
    init(dictionary: NSDictionary) {
        
        self.accounts = dictionary["accounts"] as? Int ?? 0
        self.blockHash = dictionary["blockHash"] as? String ?? ""
        self.blockNumber = dictionary["blockNumber"] as? Int ?? 0
        self.difficulty = dictionary["difficulty"] as? Double ?? 0
        self.hashrate = dictionary["hashrate"] as? Double ?? 0
        self.meanBlockTime = dictionary["meanBlockTime"] as? Double ?? 0
        self.name = dictionary["name"] as? String ?? ""
        self.peerCount = dictionary["peerCount"] as? Int ?? 0
        self.protocolVersion = dictionary["protocolVersion"] as? Int ?? 0
        self.relayFee = dictionary["relayFee"] as? Double ?? 0
        self.subVersion  = dictionary["subVersion"] as? String ?? ""
        self.totalAmount = dictionary["totalAmount"] as? Double ?? 0
        self.transactions = dictionary["transactions"] as? Int ?? 0
        self.version = dictionary["version"] as? Int ?? 0
    }
    
}


struct FetchAddRessInfoMO {
    
    let addRess : String
    let kind : String
    let indexPath : IndexPath
    
    init(addRessMO: AddRessMo, indexPath: IndexPath) {
        
        self.addRess = addRessMO.address ?? ""
        self.kind = addRessMO.kind ?? ""
        self.indexPath = indexPath
    }
    
}
























