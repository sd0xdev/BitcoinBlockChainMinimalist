//
//  WalletQueryController.swift
//  BitcoinBlockChainMinimalist
//
//  Created by 陳囿豪 on 2017/07/18.
//  Copyright © 2017年 yasuoyuhao. All rights reserved.
//

import UIKit
import CoreData

private let cellId = "cellId"

class WalletQueryController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    lazy var selectBlockChain = Dictionary<String,String>()
    
    lazy var walletQuerySegmentedControl: UISegmentedControl = {
        
        let sc = UISegmentedControl(items: [ "BTC" , "ETH", "ZEC" ])
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(walletQueryChange), for: .valueChanged)
        return sc
    }()
    
    @objc func walletQueryChange() {
        
        setupSelectBlockChainAndURL()
        setDataByCategory()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        tableView.backgroundColor = UIColor.minimalGray
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setNavigationItem()
        setupSelectBlockChainAndURL()
        setupFetchRequest()
    }
    
    fileprivate func setNavigationItem() {
        
        self.navigationItem.title = ""
        guard let bar = navigationController?.navigationBar else { return }
        bar.addSubview(walletQuerySegmentedControl)
        walletQuerySegmentedControl.anchor(top: nil, left: bar.leftAnchor, bottom: nil, right: bar.rightAnchor, paddingTop: 0 , paddingLeft: 20, paddingBottom: 0, paddingRight: 56, width: 0, height: 22)
        walletQuerySegmentedControl.centerYAnchor.constraint(equalTo: bar.centerYAnchor).isActive = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "search"), style: .plain, target: self, action: #selector(handleAddAddress))
    }
    
    @objc func handleAddAddress() {
        
        let kind = self.walletQuerySegmentedControl.selectedSegmentIndex.description
        guard self.selectBlockChain["select"] == kind else { return }
        guard let kindString = self.selectBlockChain["blockChain"] else { return }
        
        let alertController = UIAlertController(title: "請輸入錢包地址", message: nil, preferredStyle: .alert)
        alertController.addTextField { (text) in
            text.placeholder = "請輸入" + kindString + "地址"
            text.keyboardType = .emailAddress
        }
        
        alertController.addChild(AssetPriceListBlockChain())
        let alertActionToReLoadChart = UIAlertAction(title: "完成", style: .default) { (alertAction) in
            guard let address = alertController.textFields?.first!.text else { return }
            var addressRemoveBlank = address as NSString
            addressRemoveBlank = addressRemoveBlank.replacingOccurrences(of: " ", with: "") as NSString
            self.setupAddRessAndKindToPersistentContainer(address: addressRemoveBlank as String, kind: kindString)
        }
        
        let alertActionCancel = UIAlertAction(title: "取消", style: .destructive) { (alertAction) in
            
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(alertActionToReLoadChart)
        alertController.addAction(alertActionCancel)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // set BlockChainType
    
    fileprivate func setupSelectBlockChainAndURL() {
        
        let select = walletQuerySegmentedControl.selectedSegmentIndex
        
        if select == 0 {
            selectBlockChain = ["blockChain" : "BTC",
                                "select" : String(select) ,
                                "URL": "https://blockchain.info/zh-cn/rawaddr/"]
        } else if select == 1 {
            selectBlockChain = ["blockChain" : "ETH",
                                "select" : String(select),
                                "URL": "https://etherchain.org/api/account/"]
        } else if select == 2 {
            selectBlockChain = ["blockChain" : "ZEC",
                                "select" : String(select),
                                "URL":"https://api.zcha.in/v2/mainnet/accounts/"]
        }
    }
    
    // set addressData
    
    lazy var addRessFetchedResultsController = NSFetchedResultsController<AddRessMo>()
    lazy var addRessInfos = [AddRessMo]()
    lazy var fetchAddRessInfos = [FetchAddRessInfoMO]()
    
    func setupFetchRequest() {
        
        let fetchRequest: NSFetchRequest<AddRessMo> = AddRessMo.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "address", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        addRessFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        addRessFetchedResultsController.delegate = self
        
        do {
            
            try addRessFetchedResultsController.performFetch()
            
            if let fetchedObjects = addRessFetchedResultsController.fetchedObjects {
                
                addRessInfos = fetchedObjects
                setDataByCategory()
            }
            
        } catch {
            print(error)
        }
        
    }
    
    fileprivate func setDataByCategory() {
        
        fetchAddRessInfos.removeAll()
        
        addRessInfos.forEach({ (address) in
            
            guard let index = addRessInfos.firstIndex(of: address) else { return }
            let indexPath = IndexPath(row: index, section: 0)
            
            if selectBlockChain["blockChain"] == address.kind {
                let fetchAddRessInfo = FetchAddRessInfoMO(addRessMO: address, indexPath: indexPath)
                fetchAddRessInfos.append(fetchAddRessInfo)
            }
        })
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // add addRess
    
    fileprivate func setupAddRessAndKindToPersistentContainer(address: String, kind: String) {
        
        guard address != "" else { return }
        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else { return }
        
        // new catdata
        let addressMO = AddRessMo(context: appDelegate.persistentContainer.viewContext)
        addressMO.address = address
        addressMO.kind = kind
        
        appDelegate.saveContext()
        
        setupFetchRequest()
    }
    
    
    // table view
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchAddRessInfos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        cell.textLabel?.text = fetchAddRessInfos[indexPath.row].addRess
        cell.backgroundColor = UIColor.minimalLightGray
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    //didSelectRow
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let walletInformationWithAPIController = WalletInformationWithAPIController()
        walletInformationWithAPIController.addRessInfo = fetchAddRessInfos[indexPath.row]
        walletInformationWithAPIController.selectBlockChain = selectBlockChain
        
        let navWalletInformationWithAPIController = UINavigationController(rootViewController: walletInformationWithAPIController)
        
        present(navWalletInformationWithAPIController, animated: true, completion: nil)
        
    }
    
    // delete row
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else { return }
            let context = appDelegate.persistentContainer.viewContext
            let delete = addRessFetchedResultsController.object(at: fetchAddRessInfos[indexPath.row].indexPath)
            context.delete(delete)
            appDelegate.saveContext()
            
            DispatchQueue.main.async {
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.tableView.endUpdates()
            }
            setupFetchRequest()
        }
    }
    
    
    
    
}





























