//
//  kaidanLibs.swift
//  kaidan
//
//  Created by 溝田隆明 on 2015/02/14.
//  Copyright (c) 2015年 tebcro. All rights reserved.
//

import UIKit

import Foundation

class KaidanLib {
    
}

enum saveTypes : String
{
    case TMP      = "tmp"
    case DOCUMENT = "Documents"
    case CACHE    = "Library/Caches"
}

//MARK: - HEX色指定
extension UIColor
{
    class func hexStr (var hexStr : NSString, var alpha : CGFloat) -> UIColor
    {
        hexStr = hexStr.stringByReplacingOccurrencesOfString("#", withString: "")
        let scanner = NSScanner(string: hexStr)
        var color: UInt32 = 0
        if scanner.scanHexInt(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
            return UIColor.whiteColor();
        }
    }
}

extension UIImage
{
    class func createColor (var color: NSString, var alpha: CGFloat) -> UIImage
    {
        var rect = CGRectMake(0, 0, 1, 1);
        UIGraphicsBeginImageContext(rect.size);
        var contextRef = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(contextRef, UIColor.hexStr(color, alpha: alpha).CGColor);
        CGContextFillRect(contextRef, rect);
        var img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return img
    }
    
    class func resizeImage (var image:UIImage, var quality:CGInterpolationQuality, var size:CGSize) -> UIImage
    {
        var width:CGFloat  = size.width;
        var height:CGFloat = size.height;
        
        var widthRatio:CGFloat  = width / image.size.width;
        var heightRatio:CGFloat = height / image.size.height;
        var ratio:CGFloat       = (widthRatio > heightRatio) ? widthRatio : heightRatio;
        
        var rect:CGRect = CGRectMake(0, 0, image.size.width*ratio, image.size.height*ratio);
        
        UIGraphicsBeginImageContext(rect.size);
        var context:CGContextRef = UIGraphicsGetCurrentContext();
        CGContextSetInterpolationQuality(context, quality);
        image.drawInRect(rect)
        var resized:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return resized;
    }
    
    class func saveImage (var imageData:NSData, var filename:String) -> Bool
    {
        var dir      = saveTypes.CACHE.rawValue
        var path     = NSHomeDirectory().stringByAppendingPathComponent(dir)
        var filepath = "\(path)/\(filename).png"
        
        if imageData.writeToFile(filepath, atomically: true) {
            return true
        } else {
            return false
        }
    }
    
    class func loadImage (var filename:String) -> UIImage?
    {
        var dir      = saveTypes.CACHE.rawValue
        var path     = NSHomeDirectory().stringByAppendingPathComponent(dir)
        var filepath = "\(path)/\(filename).png"
        
        return UIImage(contentsOfFile: filepath)?
    }
}

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}