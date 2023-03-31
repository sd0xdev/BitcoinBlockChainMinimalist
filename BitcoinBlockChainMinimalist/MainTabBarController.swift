//
//  MainTabBarController.swift
//  BitcoinBlockChainMinimalist
//
//  Created by 陳囿豪 on 2017/07/11.
//  Copyright © 2017年 yasuoyuhao. All rights reserved.
//

import UIKit


class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupViewController()
    }
    
    
    func setupViewController() {
        
        // AssetPriceListBlockChain
        
        let assetPriceListBlockChain = AssetPriceListBlockChain()
        assetPriceListBlockChain.title = "區塊鏈價格"
        let assetPriceListBlockChainImage = ["unselected" : #imageLiteral(resourceName: "bitcoin_unselected"), "selected" : #imageLiteral(resourceName: "bitcoin_selected").withRenderingMode(.alwaysOriginal)]
        let navAssetPriceListBlockChain = templateNavController(image: assetPriceListBlockChainImage, rootViewController: assetPriceListBlockChain)
        
        // wallet
        
        let wallet = WalletQueryController(style: .plain)
        wallet.title = "錢包查詢"
        let walletImage = ["unselected" : #imageLiteral(resourceName: "dashed_cloud"), "selected" : #imageLiteral(resourceName: "dashed_cloud").withRenderingMode(.alwaysOriginal)]
        let navWallet = templateNavController(image: walletImage, rootViewController: wallet)
        
        // about
        
        let aboutView = AboutView()
        aboutView.title = "關於"
        let aboutViewImage = ["unselected" : #imageLiteral(resourceName: "settings_unselected"), "selected" : #imageLiteral(resourceName: "settings_selected").withRenderingMode(.alwaysOriginal)]
        let navAboutView = templateNavController(image: aboutViewImage, rootViewController: aboutView)
        

        
        // tabBar
        
        tabBar.tintColor = UIColor.minimalGray
        tabBar.unselectedItemTintColor = .gray
        viewControllers = [navAssetPriceListBlockChain,
                           navWallet,
                           navAboutView]
        
//         modify tab bar item insets
        
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 1, left: 0, bottom: -1, right: 0)
        }
        
    }
    
    fileprivate func templateNavController(image : [String : UIImage]? , rootViewController:UIViewController = UIViewController()) -> UINavigationController {
        
        let viewNavController = UINavigationController(rootViewController: rootViewController)
        
        if let image = image {
            viewNavController.tabBarItem.image = image["unselected"]
            viewNavController.tabBarItem.selectedImage = image["selected"]
        }
        
        
        return viewNavController
    }
    
    
    
    
}
