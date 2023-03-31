//
//  BlockChainStatsTableViewController.swift
//  BitcoinBlockChainMinimalist
//
//  Created by 陳囿豪 on 2017/07/17.
//  Copyright © 2017年 yasuoyuhao. All rights reserved.
//

import UIKit

private let cellId = "cellId"

class BlockChainStatsTableViewController: UITableViewController {
    
    var selectPriceListFromAssetPriceListBlockChainString : String? {
        didSet {
            guard let selectPriceListFromAssetPriceListBlockChain = selectPriceListFromAssetPriceListBlockChainString else { return }
            if selectPriceListFromAssetPriceListBlockChain == "USDT_BTC" {
                btcBlockChainStats = true
            } else if selectPriceListFromAssetPriceListBlockChain == "USDT_ETH" {
                ethBlockChainStats = true
            } else if selectPriceListFromAssetPriceListBlockChain == "USDT_ZEC" {
                zecBlockChainStats = true
            }
        }
    }
    
    lazy var btcBlockChainStats : Bool = false
    lazy var ethBlockChainStats : Bool = false
    lazy var zecBlockChainStats : Bool = false
    
    lazy var lists = [[String]]()
    
    var listDatas : [Dictionary<String, Any>]? {
        
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.endartactivityIndicator()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateFailed), name: GetDataClass.updateFailedNSNotification, object: nil)
        
        tableView.register(BlockChainStatsCell.self, forCellReuseIdentifier: cellId)
        tableView.backgroundColor = UIColor.minimalGray
        
        tableView.separatorStyle = .none
        
        lists.append(blockSummary)
        lists.append(transactionSunnary)
        lists.append(miningCosts)
        lists.append(haxingAndPowerConsumption)
        
    }
    
    @objc func updateFailed() {
        self.endartactivityIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if btcBlockChainStats {
            fetchDataFromApiBlockChainInfoOrZchaInStats(url: "https://api.blockchain.info/stats")
        } else if ethBlockChainStats {
            fetchDataFromApiEtherchainOrgStats(url: "https://etherchain.org/api/miningEstimator")
        } else if zecBlockChainStats {
            fetchDataFromApiBlockChainInfoOrZchaInStats(url: "https://api.zcha.in/v2/mainnet/network")
        }
    }
    
    fileprivate func fetchDataFromApiBlockChainInfoOrZchaInStats(url: String) {
        
        let returnTickerURL = url
        let postMethod = "GET"
        
        getStartactivityIndicator()
        GetDataClass.getDataFormURL(url: returnTickerURL, postMethod: postMethod) { (data) in
            
            do {
                
                guard let data = data else { return }
                
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject as? NSDictionary
                
                
                guard let jsonResults = jsonResult else { return }
                self.inPutBTCDataToClassFromApi(dictionary: jsonResults)
                
            } catch {
                
                print("Failed to jsonResult")
                self.endartactivityIndicator()
                return
            }
        }
    }
    
    fileprivate func inPutBTCDataToClassFromApi(dictionary: NSDictionary) {
        
        if btcBlockChainStats {
            
            let billion : Double = 100000000
            
            let btcBlockChainStats = BTCBlockChainStats(dictionary: dictionary)
            let blockSummary = [self.blockSummary[0]: btcBlockChainStats.n_blocks_mined,
                                self.blockSummary[1]: btcBlockChainStats.minutes_between_blocks * 60,
                                self.blockSummary[2]: btcBlockChainStats.n_btc_mined / billion,
                                self.blockSummary[3]: btcBlockChainStats.trade_volume_usd,
                                self.blockSummary[4]: btcBlockChainStats.trade_volume_btc] as [String : Any]
            let transactionSunnary = [self.transactionSunnary[0]: btcBlockChainStats.total_fees_btc / billion,
                                      self.transactionSunnary[1]: btcBlockChainStats.n_tx,
                                      self.transactionSunnary[2]: btcBlockChainStats.total_btc_sent / billion,
                                      self.transactionSunnary[3]: btcBlockChainStats.estimated_btc_sent / billion,
                                      self.transactionSunnary[4]: btcBlockChainStats.estimated_transaction_volume_usd] as [String : Any]
            
            let transactionCostPer = btcBlockChainStats.miners_revenue_usd / btcBlockChainStats.n_tx
            let transactionFeeIncomeAccountedFor = (btcBlockChainStats.total_fees_btc / billion) * btcBlockChainStats.market_price_usd  / btcBlockChainStats.miners_revenue_usd * 100
            
            let miningCosts = [self.miningCosts[0]: btcBlockChainStats.miners_revenue_usd,
                               self.miningCosts[1] : transactionFeeIncomeAccountedFor,
                               self.miningCosts[2] : transactionCostPer] as [String : Any]
            let difficulty = btcBlockChainStats.difficulty
            let haxingAndPowerConsumption = [self.haxingAndPowerConsumption[0] : difficulty,
                                             self.haxingAndPowerConsumption[1] : btcBlockChainStats.hash_rate / 1024] as [String : Any]
            var listDatas = [Dictionary<String, Any>]()
            listDatas.append(blockSummary)
            listDatas.append(transactionSunnary)
            listDatas.append(miningCosts)
            listDatas.append(haxingAndPowerConsumption)
            
            self.listDatas = listDatas
            
        } else if ethBlockChainStats {
            
            let ethBlockChainStats = ETHBlockChainStats(dictionary: dictionary)
            
            let blockSummary = [self.blockSummary[0]: 0,
                                self.blockSummary[1]: ethBlockChainStats.blockTime ,
                                self.blockSummary[2]: 0,
                                self.blockSummary[3]: 0,
                                self.blockSummary[4]: 0] as [String : Any]
            let transactionSunnary = [self.transactionSunnary[0]: 0,
                                      self.transactionSunnary[1]: 0,
                                      self.transactionSunnary[2]: 0,
                                      self.transactionSunnary[3]: 0,
                                      self.transactionSunnary[4]: 0] as [String : Any]
            
            let miningCosts = [self.miningCosts[0]: 0,
                               self.miningCosts[1] : 0,
                               self.miningCosts[2] : 0] as [String : Any]
            let th = ethBlockChainStats.hashRate / pow(1000 , 4)
            let difficulty = ethBlockChainStats.difficulty
            let haxingAndPowerConsumption = [self.haxingAndPowerConsumption[0] : difficulty,
                                             self.haxingAndPowerConsumption[1] : th ] as [String : Any]
            var listDatas = [Dictionary<String, Any>]()
            listDatas.append(blockSummary)
            listDatas.append(transactionSunnary)
            listDatas.append(miningCosts)
            listDatas.append(haxingAndPowerConsumption)
            
            self.listDatas = listDatas
            
        } else if zecBlockChainStats {
            
            let zecBlockChainStats = ZECBlockChainStats(dictionary: dictionary)
            
            let blockSummary = [self.blockSummary[0]: zecBlockChainStats.blockNumber,
                                self.blockSummary[1]: zecBlockChainStats.meanBlockTime ,
                                self.blockSummary[2]: zecBlockChainStats.totalAmount / 10000000,
                                self.blockSummary[3]: 0,
                                self.blockSummary[4]: 0] as [String : Any]
            let transactionSunnary = [self.transactionSunnary[0]: 0,
                                      self.transactionSunnary[1]: 0,
                                      self.transactionSunnary[2]: 0,
                                      self.transactionSunnary[3]: 0,
                                      self.transactionSunnary[4]: 0] as [String : Any]
            
            let miningCosts = [self.miningCosts[0]: 0,
                               self.miningCosts[1] : 0,
                               self.miningCosts[2] : 0] as [String : Any]
            let th = zecBlockChainStats.hashrate / pow(1000 , 3)
            let difficulty = zecBlockChainStats.difficulty
            let haxingAndPowerConsumption = [self.haxingAndPowerConsumption[0] : difficulty,
                                             self.haxingAndPowerConsumption[1] : th ] as [String : Any]
            var listDatas = [Dictionary<String, Any>]()
            listDatas.append(blockSummary)
            listDatas.append(transactionSunnary)
            listDatas.append(miningCosts)
            listDatas.append(haxingAndPowerConsumption)
            
            self.listDatas = listDatas
            
        }
        
        
        
    }
    
    fileprivate func fetchDataFromApiEtherchainOrgStats(url: String) {
        
        getStartactivityIndicator()
        GetDataClass.getDataFormURL(url: url, postMethod: "GET") { (data) in
            
            do {
                
                guard let data = data else { return }
                
                let jsonResultDictionaries = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject as? NSDictionary
                
                
                guard let jsonResultDictionary = (jsonResultDictionaries?["data"] as? NSArray)?[0] as? NSDictionary else { return }
                
                    self.inPutBTCDataToClassFromApi(dictionary: jsonResultDictionary)
                
            } catch {
                
                print("Failed to jsonResult")
                self.endartactivityIndicator()
                return
            }
        }
        
    }
    
    
    let blockSummary = ["已挖區塊","區塊間隔時間(秒)","已產出幣(千萬)","總交易量(美元)","總交易量(區塊幣)"]
    let transactionSunnary = ["交易費總額(區塊幣)","交易數量","輸出總量(區塊幣)","預計交易量(美元)","預計交易量(區塊幣)"]
    let miningCosts = ["總礦工收入(美元)","交易費收入佔比(%)","每次交易成本(美元)"]
    let haxingAndPowerConsumption = ["難度係數", "哈希律(總算力TH/s)"]
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return lists.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return lists[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let title = ["區塊概覽","交易概覽","挖礦成本","哈希律與耗電量"]
        return title[section]
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.minimalGray
        
        let headerLabel = UILabel(frame: CGRect(x: 16, y: 2, width:
            tableView.frame.width, height: tableView.frame.height))
        //bounds.size.height
        headerLabel.font = UIFont.boldSystemFont(ofSize: 12)
        headerLabel.textColor = UIColor.white
        headerLabel.text = self.tableView(self.tableView, titleForHeaderInSection: section)
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! BlockChainStatsCell
        let title = lists[indexPath.section][indexPath.row]
        cell.title = title
        cell.section = indexPath.section
        cell.listDatas = self.listDatas
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // activityIndicator
    
    var activityIndicator = UIActivityIndicatorView()
    
    func getStartactivityIndicator() {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0, width: 80 , height: 80 ))
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = tableView.center
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.backgroundColor = UIColor(red: 30/255, green: 32/255, blue: 40/255, alpha: 0.7)
        activityIndicator.layer.cornerRadius = 10
        activityIndicator.layer.masksToBounds = true
        self.view.addSubview(activityIndicator)
        self.activityIndicator.startAnimating()
    }
    
    func endartactivityIndicator() {
        
        self.activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    
    
}













