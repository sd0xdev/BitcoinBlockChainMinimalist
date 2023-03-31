//
//  SelectedPriceListController.swift
//  BitcoinBlockChainMinimalist
//
//  Created by 陳囿豪 on 2017/07/15.
//  Copyright © 2017年 yasuoyuhao. All rights reserved.
//

import UIKit

private let cellId = "cellId"
private let headerId = "headerId"

class SelectedPriceListController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
    
    var selectPriceListFromAssetPriceListBlockChain : BlockChainTickerData? {
        
        didSet {
            guard let selectPriceListFromAssetPriceListBlockChain = selectPriceListFromAssetPriceListBlockChain else { return }
            let openBlockChainStats = selectPriceListFromAssetPriceListBlockChain.blockChainName == "USDT_BTC" ||
                selectPriceListFromAssetPriceListBlockChain.blockChainName == "USDT_ZEC" ||
                selectPriceListFromAssetPriceListBlockChain.blockChainName == "USDT_ETH"
            self.openBlockChainStats = openBlockChainStats
        }
    }
    
    var date : String?
    var openBlockChainStats : Bool = false
    var day : Double = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.minimalGray
        
        collectionView?.register(SelectedPriceListHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(SelectedPriceListCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.alwaysBounceVertical = true
        
        setNavigation()
        if self.openBlockChainStats {
            lists = ["區塊鏈狀態", "基本資料"]
        } else {
            lists = ["基本資料"]
        }
        fetchChartDataFormAPI(day: day)
    }
    
    
    // Navigation
    fileprivate func setNavigation() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "horizontal_settings_mixer"), style: .plain, target: self, action: #selector(handleChart))
        navigationItem.title = selectPriceListFromAssetPriceListBlockChain?.blockChainName
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    @objc func handleChart() {
        
        let alertController = UIAlertController(title: "請輸入圖表週期（天）", message: nil, preferredStyle: .alert)
        alertController.addTextField { (text) in
            text.placeholder = "天數"
            text.keyboardType = .numberPad
        }
        
        alertController.addChild(AssetPriceListBlockChain())
        let alertActionToReLoadChart = UIAlertAction(title: "完成", style: .default) { (alertAction) in
            guard let text = alertController.textFields?.first!.text else { return }
            guard let dayStringToDouble = Double(text) else { return }
            self.day = dayStringToDouble
            self.fetchChartDataFormAPI(day: self.day)
        }
        
        let alertActionCancel = UIAlertAction(title: "取消", style: .destructive) { (alertAction) in
            
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(alertActionToReLoadChart)
        alertController.addAction(alertActionCancel)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        DispatchQueue.main.async {
            self.header?.blockChainChartDatas = self.blockChainChartDatas
        }
        collectionView?.collectionViewLayout.invalidateLayout()
        
    }
    
    // header,footer
    
    var header : SelectedPriceListHeader?
    
    var blockChainChartDatas : [BlockChainChartData]? {
        didSet {
            DispatchQueue.main.async {
                self.header?.blockChainChartDatas = self.blockChainChartDatas
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 250)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! SelectedPriceListHeader
        
        if let selectPriceListFromAssetPriceListBlockChain = self.selectPriceListFromAssetPriceListBlockChain {
            header.selectPriceListFromAssetPriceListBlockChain = selectPriceListFromAssetPriceListBlockChain
        }
        
        if let date = date {
            header.date = date
        }
        
        self.header = header
        
        return header
    }
    
    fileprivate func fetchChartDataFormAPI(day: Double) {
        
        guard let selectPriceListFromAssetPriceListBlockChain = selectPriceListFromAssetPriceListBlockChain else { return }
        
        let startDate = NSDate().timeIntervalSince1970 - 60 * 60 * 24 * day
        
        GetDataClass.fetchDataFormReturnChartDataAPI(currencyPair: selectPriceListFromAssetPriceListBlockChain.blockChainName, startDate: startDate) { (dataArray) in
            self.fetchDictionaryInPutChartDatas(currencyPair: selectPriceListFromAssetPriceListBlockChain.blockChainName, dataArray: dataArray)
        }
        
    }
    
    
    fileprivate func fetchDictionaryInPutChartDatas(currencyPair: String, dataArray: NSArray) {
        
        var blockChainChartDatas = [BlockChainChartData]()
        
        dataArray.forEach { (dictionary) in
            
            if let dictionary = dictionary as? NSDictionary {
                
                let blockChainChartData = BlockChainChartData(blockChainName: currencyPair, dictionary: dictionary)
                
                blockChainChartDatas.append(blockChainChartData)
            }
        }
        self.blockChainChartDatas = blockChainChartDatas
        
    }
    
    // cell
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lists.count
    }
    
    lazy var lists = [String]()
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SelectedPriceListCell
        cell.list = lists[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = indexPath.item
        
        if openBlockChainStats {
            
            if item == 0 {
                
                let blockChainStatsTableViewController = BlockChainStatsTableViewController(style: .grouped)
                blockChainStatsTableViewController.selectPriceListFromAssetPriceListBlockChainString = selectPriceListFromAssetPriceListBlockChain?.blockChainName
                navigationController?.pushViewController(blockChainStatsTableViewController, animated: true)
                
            } else if item == 1 {
                
                guard let blockChainName = selectPriceListFromAssetPriceListBlockChain?.blockChainName else { return }
                goJumPage(blockChainName: blockChainName)
                
            } else if item == 2 {
                
                print("錢包")
            }
            
        } else {
            
            if item == 0 {
                
                guard let blockChainName = selectPriceListFromAssetPriceListBlockChain?.blockChainName else { return }
                goJumPage(blockChainName: blockChainName)
                
            } else if item == 1 {
                
                print("錢包")
            }
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(1)
        header?.priceChart.touchesEnded(touches, with: event)
        header?.priceChart.isSelected = false
    }
    
    func goJumPage(blockChainName: String) {
        
        let listBlockChain = ["USDT_BTC","USDT_ETH","USDT_ZEC","USDT_LTC","USDT_ETC","USDT_NXT","USDT_STR","USDT_XMR","USDT_XRP"]
        
        let btcAbout = BTCAbout(collectionViewLayout: UICollectionViewFlowLayout())
        
        switch blockChainName {
            
        case listBlockChain[0]:
            let infoDictionary = ["title":"比特幣",
                                  "content" : "比特幣是一種用區塊鏈作為支付系統的加密貨幣。以一種被稱為挖礦的方法產生，任何人都可以參與。由中本聰在2009年基於無國界的對等網路，用共識主動性開源軟體發明創立，透過加密數位簽章，不需通過任何第三方信用機構，解決了電子貨幣的一幣多付和交易安全問題，從而演化成為一個超主權貨幣體系。比特幣的問世是人們憎恨商品經濟中國家主權貨幣超發、以及貨幣政策干預、嚮往禮物經濟中社群共識貨幣自主的結果；比特幣的匯率是全球投資者增加或者減少的反應，比特幣的價值是其底層技術區塊鏈，得到各行各業廣泛地認可和使用的體現。目前流通中比特幣約一千六百多萬個，而最終發行量將在2100萬個。\n\n作為記帳系統，比特幣不依賴中央機構發行新錢、維護交易，而是由區塊鏈完成，用數位加密演算法、全網抵禦51%算力攻擊保證交易安全。交易記錄以被全體網路電腦收錄維護，每筆交易的有效性都必須經過區塊鏈檢驗確認。作為記帳單位，比特幣的最小單位是 0.00000001 （一億分之一）比特幣，稱為「1聰」。如有必要，也可以修改協議將其分割為更小的單位，以保證其流通方便，區塊回報每產出21萬個區塊減半一次，大約4年，最近一次減半在2016年7月9日，而此種收斂等比數列的和必然是有限的，到2140年時，將不再有新的比特幣產生，最終流通中的比特幣將總是略低於2100萬個"]
            btcAbout.infoDictionary = infoDictionary
            
        case listBlockChain[1]:
            let infoDictionary = ["title":"以太坊",
                                  "content" : "以太坊（英語：Ethereum）是一個開源的有智慧型合約功能的公共區段鏈平台。通過其專用加密貨幣以太幣（Ether，又稱「乙太幣」）提供去中心化的虛擬機器（稱為「以太虛擬機」Ethereum Virtual Machine）來處理對等合約。以太坊的概念首次在2013至2014年間由程式設計師Vitalik Buterin，受比特幣啟發後提出，大意為「下一代加密貨幣與去中心化應用平台」，在2014年透過ICO眾籌得以開始發展。截至2017年5月，以太幣是市值第二高的加密貨幣，僅次於比特幣。\n\n相較於較大多數其他加密貨幣或區塊鏈技術，以太坊的特點包括下列：\n\n智慧型合約（smart contract）：儲存在區塊鏈上的程式，由各節點執行，需要執行程式的人支付手續費給結點的礦工或權益人。\n\n叔塊（uncle block）：將因為速度較慢而未及時被收入母鏈的較短區塊鏈併入。使用的是有向無環圖的相關技術。\n\n權益證明（proof-of-stake）：相較於工作量證明，可節省大量在挖礦時浪費的電腦資源，並避免特殊應用積體電路造成網路中心化。（尚未實作）\n\n閃電網路（lightning network）：可提升交易速度、降低區塊鏈的負擔，提高可擴展性。（尚未實作）\n\n開發社群穩固，不斷成長，勇於使用硬分叉（hard fork）"]
            btcAbout.infoDictionary = infoDictionary
            
        case listBlockChain[2]:
            let infoDictionary = ["title":"ZCash",
                                  "content" : "Zcash是一種去中心化、開源的加密網際網路貨幣。與比特幣相比，其更注重於隱私，以及對交易透明的可控性。具體體現為：公有區段鏈加密了交易記錄中的傳送人、接收人、交易量；用戶可裁量選擇是否向其他人提供檢視金鑰，僅擁有此金鑰的人才能看到交易的內容。Zcash團隊認為Zcash有能力與比特幣競爭。"]
            btcAbout.infoDictionary = infoDictionary
            
        case listBlockChain[3]:
            let infoDictionary = ["title":"萊特幣",
                                  "content" : "萊特幣（英語：Litecoin，簡寫：LTC，貨幣符號：Ł）是一種點對點的電子加密貨幣，也是MIT/X11許可下的一個開源軟體項目。萊特幣受到了比特幣（BTC）的啟發，並且在技術上具有相同的實現原理，萊特幣的創造和轉讓基於一種開源的加密協議，不受到任何中央機構的管理。萊特幣旨在改進比特幣，與其相比，萊特幣具有三種顯著差異。第一，萊特幣網絡大約每2.5分鐘（而不是10分鐘）就可以處理一個塊，因此可以提供更快的交易確認。第二，萊特幣網絡預期產出8400萬個萊特幣，是比特幣網絡發行貨幣量的四倍之多。第三，萊特幣在其工作量證明算法中使用了由Colin Percival首次提出的scrypt加密算法，這使得相比於比特幣，在普通計算機上進行萊特幣挖掘更為容易（在ASIC礦機誕生之前）。每一個萊特幣被分成100,000,000個更小的單位，通過八位小數來界定。"]
            btcAbout.infoDictionary = infoDictionary
            
        case listBlockChain[4]:
            let infoDictionary = ["title":"古典以太坊",
                                  "content" : "2016年6月，在第三次硬分叉時，拒絕修改交易紀錄的區塊鏈分支成了「古典以太坊」（Ethereum Classic）。在分叉以前就持有以太幣的人會同時持有以太幣和古典以太幣（Classic Ether, ETC），存在交易所或線上錢包中的以太幣也不例外。這些線上服務大多選擇只支援其中一種以太幣，並讓使用者領回另一種以太幣。截至2016年8月，兩種以太幣都可以在匯市上交易。之後古典以太坊在2016年10月進行了硬分叉，調整以太虛擬機的一些操作碼（op code），以提高濫發垃圾訊息或進行阻斷服務攻擊的成本。當時以太坊和古典以太坊都已遭受了一個月的阻斷服務攻擊。"]
            btcAbout.infoDictionary = infoDictionary
            
        case listBlockChain[5]:
            let infoDictionary = ["title":"未來幣",
                                  "content" : "未來幣（Nxt、Nextcoin）是第二代去中心化虛擬貨幣。它使用全新的代碼編寫，不是比特幣（第一代去中心化虛擬貨幣）的山寨幣。它第一個採用100%的股權證明，有資產交易、任意消息、去中心化域名、帳戶租賃等多種功能，部分實現了透明鍛造功能，計劃實現更多的功能"]
            btcAbout.infoDictionary = infoDictionary
            
        case listBlockChain[6]:
            let infoDictionary = ["title":"恆星幣",
                                  "content" : "恆星幣（Stellar），一個由前瑞波幣（Ripple）創始人Jed McCaleb發起的數字貨幣項目，用於搭建一個數字貨幣與法定貨幣之間傳輸的去中心化網關。將通過免費發放的形式提供給用戶，其供應上線為1000億，其中95%數量的恆星幣用於免費發放。恆星是一個多元化的團隊，董事會成員有包括前Square首席運營官Keith Rabois，Stripe首席執行官Patrick Collison，而狗狗幣聯合創始人Jackson Palmer以及AngelList聯合創始人Naval Ravikant 將作為該項目的顧問。"]
            btcAbout.infoDictionary = infoDictionary
            
        case listBlockChain[7]:
            let infoDictionary = ["title":"門羅幣",
                                  "content" : "門羅幣（Monero，代號XMR）是一個創建於2014年4月開源加密貨幣，它著重於隱私、分權和可擴展性。與自比特幣衍生的許多加密貨幣不同，Monero基於CryptoNote協議，並在區塊鏈模糊化方面有顯著的算法差異。Monero的模塊化代碼結構得到了比特幣核心維護者之一的Wladimir J. van der Laan的讚賞。Monero在2016年經歷了市值（從5百萬美元至1.85億美元)和交易量的快速增長，這部分是因為它在2016年夏季末期得到了主要的暗網市場AlphaBay的採用。"]
            btcAbout.infoDictionary = infoDictionary
            
        case listBlockChain[8]:
            
            let infoDictionary = ["title":"瑞波幣",
                                  "content" : "瑞波幣是由OpenCoin公司發行的虛擬貨幣，稱作Ripple Credits，又稱作XRP，中文名為瑞波幣。Ripple是世界上第一個開放的支付網路，通過這個支付網路可以轉賬任意一種貨幣，簡便易行快捷，交易確認在幾秒以內完成，交易費用幾乎是零，沒有所謂的跨行異地以及跨國支付費用。\n\nRipple開放式支付系統是一個虛擬貨幣網路（分散式的P2P清算網路）、未來的電子支付平臺。2004年，RyanFugger就推出了Ripple的第一個實現版本，它的目標是構建一個去中心化的、准許任何人創建自家貨幣的虛擬貨幣系統。目前Ripple由OpenCoin公司（目前改名為RippleLabs）開發、運行、維護。\n\n或許在外人眼裡，Ripple是個後來者，但實際上Ripple項目的起源遠遠早於比特幣。2004年，Ryan Fugger就推出了Ripple的第一個實現版本。它的目標是構建一個去中心化的、准許任何人創建自家貨幣的虛擬貨幣系統。Ripple網路中的金錢都用“債務”表示，所有交易均表現為帳務餘額的變化。它的運作方式類似於銀行的清算系統：在進行跨行匯款時，銀行間款項的實際結轉會被儘可能延後到夜晚，此時銀行計算它與其它銀行的應結款項。有可能來自某個銀行的待轉入款正好與它要轉給該銀行的待轉出款相抵，這樣它實際上不需要轉出、轉入任何款項；即使不能完全相抵，它實際結轉的金額一般也會遠小於客戶的電匯金額之和。\n\nRipple項目的初衷就是要建立一個分散式的P2P清算網路：每個人都是自己的銀行，可以簽發、接受借貸，同時又作為借貸通道（例如A想向B借錢，他們互不認識，卻正好都認識C，那麼C就可以作為A、B的通道，C先向B借錢，然後再把錢借給A，間接實現A向B借錢）。\n\n該項目幾乎依靠Ryan Fugger一個人的力量支撐下來，並獲得了一定的成功。但Ripple的用戶一直不多，僅流行於若幹個孤立的小圈子，原因很簡單：Ripple的設計思路基於熟人關係和信任鏈，一個人要使用Ripple網路進行匯款或借貸，前提是在網路中已經存在他的朋友，否則無法在該用戶與其它用戶之間建立信任鏈。"]
            btcAbout.infoDictionary = infoDictionary
            
        default:
            break
        }
        
        navigationController?.pushViewController(btcAbout, animated: true)
        
    }
    
    
    
}













