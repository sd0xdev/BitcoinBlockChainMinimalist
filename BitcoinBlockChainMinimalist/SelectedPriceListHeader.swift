//
//  SelectedPriceListHeader.swift
//  BitcoinBlockChainMinimalist
//
//  Created by 陳囿豪 on 2017/07/15.
//  Copyright © 2017年 yasuoyuhao. All rights reserved.
//

import UIKit
import SwiftChart


class SelectedPriceListHeader: UICollectionViewCell, ChartDelegate {
    
    var blockChainChartDatas : [BlockChainChartData]? {
        didSet {
            DispatchQueue.main.async {
                self.priceChart.removeAllSeries()
                self.priceChart.removeFromSuperview()
                self.setPrictChart()
            }
            
        }
    }
    
    var selectPriceListFromAssetPriceListBlockChain : BlockChainTickerData? {
        
        didSet {
            setAssetPriceListBlockChainInfo()
        }
    }
    
    var date : String? {
        
        didSet {
            DispatchQueue.main.async {
                self.blockChainPriceDate.text = self.date
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.minimalGray
        
        addSubview(blockChainName)
        blockChainName.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 0, height: 0)
        addSubview(blockChainPrice)
        blockChainPrice.anchor(top: nil, left: blockChainName.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 8, paddingRight: 0, width: 0, height: 0)
        
        addSubview(blockChainPriceDate)
        blockChainPriceDate.anchor(top: nil, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 4, width: 0, height: 0)
        
        dateFormatter.dateFormat = "dd"
        
    }
    
    lazy var priceChart = Chart(frame: CGRect.zero)
    
    let dateFormatter = DateFormatter()
    
    
    fileprivate func setPrictChart() {
        
        priceChart = Chart(frame: CGRect.zero)
        
        guard let blockChainChartDatas = blockChainChartDatas else { return }
        
        var data = [(x: Double, y: Double)]()
        
        var xLabels = [(Float)]()
        
        blockChainChartDatas.forEach { (chartData) in
            
            xLabels.append(Float(chartData.date))
            data.append((x: chartData.date, y: chartData.close))
        }
        
        priceChart.xLabelsFormatter = { self.dateFormatter.string(from: NSDate(timeIntervalSince1970: TimeInterval($1)) as Date)}
        priceChart.labelFont = UIFont.systemFont(ofSize: 9)
        
        
        let series = ChartSeries(data: data)
        series.color = ChartColors.orangeColor()
        series.area = true
        priceChart.xLabels = xLabels
        priceChart.add(series)
        
        if blockChainChartDatas[blockChainChartDatas.endIndex - 1].close <= 1 {
            priceChart.yLabelsFormatter = { String(format: "%.3f", $1) }
        }
        priceChart.labelColor = .white
        priceChart.gridColor = .minimalLightGray
        priceChart.delegate = self
        
        addSubview(priceChart)
        priceChart.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 200)
        
    }
    
    fileprivate func setAssetPriceListBlockChainInfo() {
        
        guard let selectPriceListFromAssetPriceListBlockChain = selectPriceListFromAssetPriceListBlockChain else { return }
        
        let blockChainName = nameConverter(name: selectPriceListFromAssetPriceListBlockChain.blockChainName)
        
        let priceString = String(format: "%.3f", selectPriceListFromAssetPriceListBlockChain.last)
        
        DispatchQueue.main.async {
            self.blockChainName.text = blockChainName
            self.blockChainPrice.text = priceString
        }
    }
    
    fileprivate func nameConverter(name : String) -> String {
        
        let listBlockChain = ["USDT_BTC","USDT_ETH","USDT_ZEC","USDT_LTC","USDT_ETC","USDT_NXT","USDT_STR","USDT_XMR","USDT_XRP"]
        
        switch name {
        case listBlockChain[0]:
            return "Bitcoin"
        case listBlockChain[1]:
            return "Ethereum"
        case listBlockChain[2]:
            return "Zcash"
        case listBlockChain[3]:
            return "Litecoin"
        case listBlockChain[4]:
            return "Ethereum Classic"
        case listBlockChain[5]:
            return "NXT"
        case listBlockChain[6]:
            return "Stellar"
        case listBlockChain[7]:
            return "Monero"
        case listBlockChain[8]:
            return "Ripple"
        default:
            return ""
        }
    }
    
    let priceLable : UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.white
        return lable
    }()
    
    let blockChainName: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.white
        lable.font = UIFont.systemFont(ofSize: 12)
        return lable
    }()
    
    let blockChainPrice: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.white
        lable.font = UIFont.boldSystemFont(ofSize: 15)
        return lable
    }()
    
    let blockChainPriceDate: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.gray
        lable.font = UIFont.systemFont(ofSize: 9)
        return lable
    }()
    
    func didTouchChart(_ chart: Chart, indexes: Array<Int?>, x: Float, left: CGFloat) {
        
        for (serieIndex, dataIndex) in indexes.enumerated() {
            if dataIndex != nil {
                // The series at serieIndex has been touched
                guard let value = chart.valueForSeries(serieIndex, atIndex: dataIndex) else { return }
                
                DispatchQueue.main.async {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMdd"
                    let dateString = dateFormatter.string(from: NSDate(timeIntervalSince1970: TimeInterval(x)) as Date)
                    let valueString = String(describing: value)
                    let labelString = valueString + " ," + dateString
                    
                    self.priceLable.adjustsFontSizeToFitWidth = true
                    
                    if left >= self.frame.midX {
                        self.priceLable.frame = CGRect(x: left - 80 , y: 0, width: 80, height: 20)
                    } else {
                        self.priceLable.frame = CGRect(x: left, y: 0, width: 100, height: 20)
                    }
                    self.priceLable.text = labelString
                    self.addSubview(self.priceLable)
                }
            }
        }
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        // Do something when finished
        DispatchQueue.main.async {
            self.priceLable.removeFromSuperview()
        }
        
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        // Do something when ending touching chart
        DispatchQueue.main.async {
            self.priceLable.removeFromSuperview()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
}
