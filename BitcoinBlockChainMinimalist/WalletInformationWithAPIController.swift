//
//  WalletInformationWithAPIController.swift
//  BitcoinBlockChainMinimalist
//
//  Created by 陳囿豪 on 2017/07/19.
//  Copyright © 2017年 yasuoyuhao. All rights reserved.
//

import UIKit

private let cellId = "cellId"

class WalletInformationWithAPIController: UITableViewController {
    
    var selectBlockChain : Dictionary<String,String>?
    var addRessInfo : FetchAddRessInfoMO?
    
    var listDatas : Dictionary<String, Any>?
    
    var btcWallet : BTCWallet?
    var ethWallet : ETHWallet?
    var zecWallet : ZECWallet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateFailed), name: GetDataClass.updateFailedNSNotification, object: nil)
        
        tableView.register(WalletInformationWithAPICell.self, forCellReuseIdentifier: cellId)
        tableView.backgroundColor = UIColor.minimalGray
        tableView.separatorStyle = .none
        
        setupNavigation()
        fetchWalletInformationWithAPI()
    }
    
    
    @objc func updateFailed() {
        self.endartactivityIndicator()
    }
    
    fileprivate func setupNavigation() {
        
        navigationItem.title = "\(selectBlockChain?["blockChain"] ?? "") 錢包查詢"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ok"), style: .plain, target: self, action: #selector(handleOK))
        
    }
    
    @objc func handleOK() {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func fetchWalletInformationWithAPI() {
        
        guard let selectBlockChain = selectBlockChain else { return }
        guard let select = selectBlockChain["select"] else { return }
        guard let url = selectBlockChain["URL"] else { return }
        guard let addRess = addRessInfo?.addRess else { return }
        
        let urlWithAddress = url + addRess
        
        getStartactivityIndicator()
        GetDataClass.getDataFormURL(url: urlWithAddress, postMethod: "GET") { (data) in
            
            do {
                guard let data = data else { return }
                
                let dictionaryFromJson = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject as? NSDictionary
                
                guard let dictionary = dictionaryFromJson else { return }
                
                if select == 0.description {
                    
                    let btcWallet = BTCWallet(dictionary: dictionary)
                    self.btcWallet = btcWallet
                    
                } else if select == 1.description {
                    guard let dictionary = (dictionary["data"] as? NSArray)?[0] as? NSDictionary else { return }
                    let ethWallet = ETHWallet(dictionary: dictionary)
                    self.ethWallet = ethWallet
                    
                } else if select == 2.description {
                    
                    let zecWallet = ZECWallet(dictionary: dictionary)
                    self.zecWallet = zecWallet
                }
                
                self.setData()
                
            } catch {
                self.endartactivityIndicator()
            }
        }
        
    }
    
    fileprivate func setData() {
        
        if let btcWallet = btcWallet {
            
            let million: Double = pow(10, 8)
            
            let listDatas = [btcWallet.address,
                             btcWallet.final_balance / million,
                             btcWallet.total_received / million,
                             btcWallet.total_sent / million,
                             btcWallet.n_tx,
                             btcWallet.hash160,
                             "nil"] as [Any]
            var dictionary = Dictionary<String, Any>()
            listTitle.forEach({ (string) in
                
                guard let index = listTitle.firstIndex(of: string) else { return }
                dictionary.updateValue(listDatas[index], forKey: listTitle[index])
            })
            
            self.listDatas = dictionary
            
            
        } else if let ethWallet = ethWallet {
            
            let millionss: Double = pow(10, 18)
            
            let listDatas = [ethWallet.address,
                             ethWallet.balance / millionss,
                             "nil",
                             "nil",
                             "nil",
                             "nil",
                             ethWallet.code] as [Any]
            var dictionary = Dictionary<String, Any>()
            listTitle.forEach({ (string) in
                
                guard let index = listTitle.firstIndex(of: string) else { return }
                dictionary.updateValue(listDatas[index], forKey: listTitle[index])
            })
            
            self.listDatas = dictionary
            
        } else if let zecWallet = zecWallet {
            
            let listDatas = [zecWallet.address,
                             zecWallet.balance,
                             zecWallet.totalRecv,
                             zecWallet.totalSent,
                             zecWallet.sentCount,
                             "nil",
                             "nil"] as [Any]
            var dictionary = Dictionary<String, Any>()
            listTitle.forEach({ (string) in
                
                guard let index = listTitle.firstIndex(of: string) else { return }
                dictionary.updateValue(listDatas[index], forKey: listTitle[index])
            })
            
            self.listDatas = dictionary
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.endartactivityIndicator()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    let listTitle = ["地址","總餘額(顆)","總接收(顆)","總發出(顆)","總發送次數","Hash160","ETHCode"]
    
    //     MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listTitle.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WalletInformationWithAPICell
        
        cell.listTitle = self.listTitle[indexPath.row]
        cell.listDatas = self.listDatas
        
        return cell
    }
    
    // didSelect
    
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




















