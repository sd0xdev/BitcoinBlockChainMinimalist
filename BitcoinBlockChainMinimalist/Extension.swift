//
//  Extension.swift
//  BitcoinBlockChainMinimalist
//
//  Created by 陳囿豪 on 2017/07/11.
//  Copyright © 2017年 yasuoyuhao. All rights reserved.
//

import UIKit


extension NSAttributedString {
    
    static func enterN(ofSize: CGFloat) -> NSAttributedString {
        
        let enterNAttributedString = NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: ofSize)])
        
        return enterNAttributedString
    }
    
    static func addNSAttributedString(string: String, ofSize: CGFloat, color: UIColor?, bold: Bool =  false) -> NSAttributedString {
        
        if bold {
            
            if let color = color {
                
                let attributedString = NSAttributedString(string: string, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: ofSize), NSAttributedString.Key.foregroundColor: color])
                
                return attributedString
                
            } else {
                
                let attributedString = NSAttributedString(string: string, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: ofSize)])
                return attributedString
            }
            
        } else {
            
            if let color = color {
                
                let attributedString = NSAttributedString(string: string, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: ofSize), NSAttributedString.Key.foregroundColor: color])
                
                return attributedString
                
            } else {
                
                let attributedString = NSAttributedString(string: string, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: ofSize)])
                return attributedString
            }
        }
    }
}

extension NSMutableAttributedString {
    
    static func creativeNSMutableAttributedString() -> NSMutableAttributedString {
        
        let attributedString = NSMutableAttributedString.init()
        return attributedString
    }
    
    
    static func paragraphSpaceLine(attributedText: NSMutableAttributedString, paragraphStyle: NSMutableParagraphStyle) -> NSMutableAttributedString {
        
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: .init(location: 0, length: (attributedText.length)))
        return attributedText
    }
}



extension String {
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}

extension NSAttributedString {
    
    func heightWithConstrainedWidth(width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        return ceil(boundingBox.height)
    }
    
}

extension UIColor {
    
    open class var faceBookBlue : UIColor {
        return UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1)
    }
    
    open class var minimalGray : UIColor {
        return UIColor(red: 38/255, green: 45/255, blue: 52/255, alpha: 1)
    }
    
    open class var minimalLightGray : UIColor {
        return UIColor(red: 71/255, green: 79/255, blue: 87/255, alpha: 1)
    }
    
    open class var minimalBrown : UIColor {
        return UIColor(red: 45/255, green: 45/255, blue: 45/255, alpha: 1)
    }
    
    open class var hightLightWhite : UIColor {
        return UIColor(red: 247/255, green: 249/255, blue: 242/255, alpha: 1)
    }
    
    open class var lightPurpleRed : UIColor {
        return UIColor.rgb(red: 194, green: 42, blue: 130)
    }
    
    open class var aboutMeGreen : UIColor {
        return UIColor(red: 20/255, green: 155/255, blue: 124/255, alpha: 1)
    }
    
    open class var arizonaStateUniversityRed : UIColor {
        return UIColor(red: 133/255, green: 0/255, blue: 39/255, alpha: 1)
    }
    
    open class var aetnaRed : UIColor {
        return UIColor(red: 197/255, green: 0/255, blue: 72/255, alpha: 1)
    }
    
    open class var alphabetRed : UIColor {
        return UIColor(red: 229/255, green: 0/255, blue: 28/255, alpha: 1)
    }
    
    open class var tiffanyBlue : UIColor {
        return UIColor(red: 10/255, green: 186/255, blue: 181/255, alpha: 1)
    }
    
    static func rgb(red : CGFloat , green : CGFloat , blue :CGFloat ) -> UIColor {
        return UIColor(red: red/255 , green: green/255 , blue: blue/255 , alpha: 1)
    }
    
    static func randomColor() -> UIColor {
        let red = CGFloat(randomDoubleforColor())
        let green = CGFloat(randomDoubleforColor())
        let blue = CGFloat(randomDoubleforColor())
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    static func randomDoubleforColor() -> Double {
        
        let random = arc4random_uniform(10000)
        let double = Double(random)/Double(10000)
        return double
    }
    
}

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor? , left : NSLayoutXAxisAnchor? , bottom: NSLayoutYAxisAnchor?, right : NSLayoutXAxisAnchor? ,paddingTop: CGFloat , paddingLeft :CGFloat , paddingBottom :CGFloat , paddingRight: CGFloat , width : CGFloat , height : CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func downLoadDataFromURL(url: URL , completion: @escaping (Data) -> Void ) {
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            if let err = err {
                print("Failed to fetch posts photo image :" , err)
            }
            
            guard let data = data else { return }
            
            completion(data)
            
            }.resume()
    }
}

extension NSDate {
    
    static func secondsToHoursMinutesSeconds (seconds : Int) -> (Int , Int, Int, Int) {
        return (seconds / 3600 / 24 , (seconds / 3600) % 24, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}


extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        
        let quotient: Int
        let unit: String
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "秒"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "分"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "小時"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "天"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "星期"
        } else {
            quotient = secondsAgo / month
            unit = "月"
        }
        
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
        
    }
}

extension UITableView {
    
    private var FLAG_TABLE_VIEW_CELL_LINE: Int {
        get { return 977322 }
    }
    
    //自动添加线条
    func autoAddLineToCell(cell: UITableViewCell, indexPath: NSIndexPath, lineColor: UIColor) {
        
        let lineView = cell.viewWithTag(FLAG_TABLE_VIEW_CELL_LINE)
        if self.isNeedShow(indexPath: indexPath) {
            if lineView == nil {
                self.addLineToCell(cell: cell, lineColor: lineColor)
            }
        } else {
            lineView?.removeFromSuperview()
        }
        
    }
    
    private func addLineToCell(cell: UITableViewCell, lineColor: UIColor) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 0.5))
        view.tag = FLAG_TABLE_VIEW_CELL_LINE
        view.backgroundColor = lineColor
        cell.contentView.addSubview(view)
    }
    
    private func isNeedShow(indexPath: NSIndexPath) -> Bool {
        let countCell = self.countCell(atSection: indexPath.section)
        if countCell == 0 || countCell == 1 {
            return false
        }
        if indexPath.row == 0 {
            return false
        }
        return true
    }
    
    
    
    private func countCell(atSection: Int) -> Int {
        return self.numberOfRows(inSection: atSection)
    }
    
}
