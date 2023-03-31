//
//  AssetPriceListBlockChain.swift
//  BitcoinBlockChainMinimalist
//
//  Created by 陳囿豪 on 2017/07/11.
//  Copyright © 2017年 yasuoyuhao. All rights reserved.
//

import UIKit

private let cellId = "cellId"
private let footerId = "footerId"

class AssetPriceListBlockChain : UITableViewController {
    
    
    override func viewDidLoad() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateFailed), name: GetDataClass.updateFailedNSNotification, object: nil)
        
        tableView.register(AssetPriceListBlockChainCell.self, forCellReuseIdentifier: cellId)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: footerId)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        let top : CGFloat = 0
        
        tableView.contentInset = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
        
        tableView.layoutMargins = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 0)
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.minimalGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDataFormAPI()
        setNavigation()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        tableView.reloadData()
    }
    
    // Navigation
    fileprivate func setNavigation() {
        
        self.title = "區塊鏈價格"
    }
    
    // refreshControl
    @objc func refreshTable() {
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        fetchDataFormAPI()
        tableView.refreshControl?.endRefreshing()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    @objc func updateFailed() {
        tableView.refreshControl?.endRefreshing()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    // footer
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd, yyyy, hh:mm:ss" //自訂時間格式
        let dateFormatterString = dateFormatter.string(from: currentDate)
        date = "上次更新： " + dateFormatterString
        
        return date
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.minimalGray
        
        let footerLabel = UILabel(frame: CGRect(x: 16, y: 2, width:
            tableView.frame.width, height: tableView.frame.height))
        //bounds.size.height
        footerLabel.font = UIFont.boldSystemFont(ofSize: 9)
        footerLabel.textColor = UIColor.lightGray
        footerLabel.text = self.tableView(self.tableView, titleForFooterInSection: section)
        footerLabel.sizeToFit()
        footerView.addSubview(footerLabel)
        
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
    }
    
    
    // setupCell
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return blockChainTickerDatas.count
    }
    
    var date : String?
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AssetPriceListBlockChainCell
        cell.blockChainTickerData = blockChainTickerDatas[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }
    
    // didSelect
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
            let selectedPriceListController = SelectedPriceListController(collectionViewLayout: UICollectionViewFlowLayout())
            selectedPriceListController.selectPriceListFromAssetPriceListBlockChain = self.blockChainTickerDatas[indexPath.row]
            selectedPriceListController.date = self.date
            navigationController?.pushViewController(selectedPriceListController, animated: true)
    }
    
    
    
    // fetchDataFormAPI
    
    var blockChainTickerDatas = [BlockChainTickerData]()
    
    fileprivate func fetchDataFormAPI() {
        
        
        let listBlockChain = ["USDT_BTC","USDT_ETH","USDT_ZEC","USDT_LTC","USDT_ETC","USDT_NXT","USDT_STR","USDT_XMR","USDT_XRP"]
        
        GetDataClass.fetchDataFormReturnTickerAPI { (dictionary) in
            
            self.blockChainTickerDatas.removeAll()
            listBlockChain.forEach({ (blockChainName) in
                self.fetchDictionaryFromReturnTickerAndInPutTickers(blockChainName: blockChainName, dataDictionaries: dictionary)
            })
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    fileprivate func fetchDictionaryFromReturnTickerAndInPutTickers(blockChainName : String, dataDictionaries: NSDictionary) {
        
        guard let dictionary = dataDictionaries[blockChainName] as? NSDictionary else { return }
        let image = setupImageBlockChainAsset(blockChainName: blockChainName)
        let blockChainTickerData = BlockChainTickerData(blockChainName: blockChainName, blockChainImage: image, dictionary: dictionary)
        self.blockChainTickerDatas.append(blockChainTickerData)
        self.blockChainTickerDatas.sort(by: { (bt1, bt2) -> Bool in
            return bt1.last > bt2.last
        })
        
        
    }
    
    
    fileprivate func setupImageBlockChainAsset(blockChainName: String) -> UIImage? {
        
        let listBlockChain = ["USDT_BTC","USDT_ETH","USDT_ZEC","USDT_LTC","USDT_ETC","USDT_NXT","USDT_STR","USDT_XMR","USDT_XRP"]
        
        switch blockChainName {
        case listBlockChain[0]:
            return #imageLiteral(resourceName: "BTC")
        case listBlockChain[1]:
            return #imageLiteral(resourceName: "eth")
        case listBlockChain[2]:
            return #imageLiteral(resourceName: "ZEC")
        case listBlockChain[3]:
            return #imageLiteral(resourceName: "ltc")
        case listBlockChain[4]:
            return #imageLiteral(resourceName: "etc")
        case listBlockChain[5]:
            return #imageLiteral(resourceName: "NXT")
        case listBlockChain[6]:
            return #imageLiteral(resourceName: "STR")
        case listBlockChain[7]:
            return #imageLiteral(resourceName: "XMR")
        case listBlockChain[8]:
            return #imageLiteral(resourceName: "XRP")
        default:
            return nil
        }
    }
    
    // activityIndicator
    
    var activityIndicator = UIActivityIndicatorView()
    
    func getStartactivityIndicator() {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0, width: 80 , height: 80 ))
        activityIndicator.center = self.tableView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.backgroundColor = UIColor(red: 30/255, green: 32/255, blue: 40/255, alpha: 0.7)
        activityIndicator.layer.cornerRadius = 10
        activityIndicator.layer.masksToBounds = true
        self.view.addSubview(activityIndicator)
        self.activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func endartactivityIndicator() {
        
        self.activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    
}

























