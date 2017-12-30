//
//  UIViewExtension.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 9/16/17.
//  Copyright © 2017 zaizencorp. All rights reserved.
//

import Foundation

import UIKit
import Charts


public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "AudioAccessory1,1":                       return "HomePod"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}

extension UINavigationController {
    func clearShadow() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
    }
}

extension String {
    
    
    static func stringFromHtml(string: String, font: UIFont) -> NSAttributedString? {
        do {
            let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
            if let d = data {
                let str = try NSAttributedString(data: d,
                                                 options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSFontAttributeName: font],
                                                 documentAttributes: nil)
                
                return str
            }
        } catch {
        }
        return nil
    }
}

extension UITextField {
    internal func resizeText() {
        if self.text != nil && self.text! != "" {
            let text = self.text!
            self.font = UIFont(name: self.font!.fontName, size: 90.0)
            let textString = text as NSString
            var widthOfText = textString.size(attributes: [NSFontAttributeName : self.font!]).width
            var height = self.frame.size.height
            var widthOfFrame = self.frame.size.width
            // decrease font size until it fits
            while widthOfFrame - 5 < widthOfText {
                let fontSize = self.font!.pointSize
                self.font = self.font?.withSize(fontSize - 0.5)
                widthOfText = textString.size(attributes: [NSFontAttributeName : self.font!]).width
                widthOfFrame = self.frame.size.width
            }
            
        } else if let text = self.placeholder {
//            self.font =
            self.font = UIFont(name: self.font!.fontName, size: 90.0)
            let textString = text as NSString
            var widthOfText = textString.size(attributes: [NSFontAttributeName : self.font!]).width
            var height = self.frame.size.height
            var widthOfFrame = self.frame.size.width
            // decrease font size until it fits
            while widthOfFrame - 5 < widthOfText {
                let fontSize = self.font!.pointSize
                self.font = self.font?.withSize(fontSize - 0.5)
                widthOfText = textString.size(attributes: [NSFontAttributeName : self.font!]).width
                widthOfFrame = self.frame.size.width
            }
        }
    }
}
extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y ago"   }
        if months(from: date)  > 0 { return "\(months(from: date))M ago"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w ago"   }
        if days(from: date)    > 0 { return "\(days(from: date))d ago"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h ago"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m ago" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s ago" }
        return "Just now"
    }
}

extension UIView
{
    static let allColors: [NSUIColor] =  ChartColorTemplates.pastel() + ChartColorTemplates.vordiplom() + ChartColorTemplates.material() + ChartColorTemplates.colorful() + ChartColorTemplates.joyful() + ChartColorTemplates.liberty()
    
    static var theBlue: UIColor {
        return UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
    }
    
    static var theRed: UIColor {
//        return UIColor(red: 214/255.0, green: 69/255.0, blue: 65/255.0, alpha: 1.0)
        return UIColor(red: 236/255.0, green: 100/255.0, blue: 75/255.0, alpha: 1.0)
    }
    static var theGreen: UIColor {
        return UIColor(red: 108/255.0, green: 203/255.0, blue: 158/255.0, alpha: 1.0)
    }
    
    // different inner shadow styles
    public enum innerShadowSide
    {
        case all, left, right, top, bottom, topAndLeft, topAndRight, bottomAndLeft, bottomAndRight, exceptLeft, exceptRight, exceptTop, exceptBottom
    }
//    var shadowLayer: CAShapeLayer?
    // define function to add inner shadow
    public func addInnerShadow(onSide: innerShadowSide, shadowColor: UIColor, shadowSize: CGFloat, cornerRadius: CGFloat = 0.0, shadowOpacity: Float)
    {
        // define and set a shaow layer
        let shadowLayer = CAShapeLayer()
        shadowLayer.cornerRadius = 22.0
        shadowLayer.frame = bounds
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        shadowLayer.shadowOpacity = shadowOpacity
        shadowLayer.shadowRadius = shadowSize
        shadowLayer.fillRule = kCAFillRuleEvenOdd
        
        // define shadow path
        let shadowPath = CGMutablePath()
        
        // define outer rectangle to restrict drawing area
        let insetRect = bounds.insetBy(dx: -shadowSize * 2.0, dy: -shadowSize * 2.0)
        
        // define inner rectangle for mask
        let innerFrame: CGRect = { () -> CGRect in
            switch onSide
            {
            case .all:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height)
            case .left:
                return CGRect(x: 0.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 4.0)
            case .right:
                return CGRect(x: -shadowSize * 2.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 4.0)
            case .top:
                return CGRect(x: -shadowSize * 2.0, y: 0.0, width: frame.size.width + shadowSize * 4.0, height: frame.size.height + shadowSize * 2.0)
            case.bottom:
                return CGRect(x: -shadowSize * 2.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 4.0, height: frame.size.height + shadowSize * 2.0)
            case .topAndLeft:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .topAndRight:
                return CGRect(x: -shadowSize * 2.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .bottomAndLeft:
                return CGRect(x: 0.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .bottomAndRight:
                return CGRect(x: -shadowSize * 2.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .exceptLeft:
                return CGRect(x: -shadowSize * 2.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height)
            case .exceptRight:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height)
            case .exceptTop:
                return CGRect(x: 0.0, y: -shadowSize * 2.0, width: frame.size.width, height: frame.size.height + shadowSize * 2.0)
            case .exceptBottom:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height + shadowSize * 2.0)
            }
        }()
        
        // add outer and inner rectangle to shadow path
        shadowPath.addRect(insetRect)
        shadowPath.addRect(innerFrame)
        
        // set shadow path as show layer's
        shadowLayer.path = shadowPath
        
        // add shadow layer as a sublayer
        layer.addSublayer(shadowLayer)
//        self.shadowLayer = shadowLayer
        // hide outside drawing area
        clipsToBounds = true
    }
}
