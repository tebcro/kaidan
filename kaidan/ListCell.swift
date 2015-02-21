//
//  CollectionCell.swift
//  kaidan
//
//  Created by mizota on 2015/02/15.
//  Copyright (c) 2015年 tebcro. All rights reserved.
//

import UIKit
import Alamofire
import HCYoutubeParser

class ListCell: UICollectionViewCell {
    
    var movieId:String = ""
    var movieUrl:NSURL?
    
    var imageView:UIImageView!
    var textLabel:UILabel!
    var detailTextLabel:UILabel!
    
    override init(frame: CGRect)
    {
        super.init(frame: CGRectZero)
        
        self.alpha           = 0
        self.backgroundColor = UIColor.hexStr("FFFFFF", alpha: 0.9)
        
        imageView                       = UIImageView(frame: CGRectMake(10, 10, 40, 40))
        imageView.backgroundColor       = UIColor.hexStr("EEEEEE", alpha: 1)
        imageView.clipsToBounds         = true;
        imageView.layer.cornerRadius    = 20;
        
        textLabel                       = UILabel(frame: CGRectMake(60, 10, 250, 20))
        textLabel.backgroundColor       = UIColor.clearColor()
        textLabel.font                  = UIFont.systemFontOfSize(14)
        textLabel.textColor             = UIColor.hexStr("222222", alpha: 1)
        
        detailTextLabel                 = UILabel(frame: CGRectMake(60, 30, 250, 20))
        detailTextLabel.backgroundColor = UIColor.clearColor()
        detailTextLabel.font            = UIFont.systemFontOfSize(12)
        detailTextLabel.textColor       = UIColor.hexStr("555555", alpha: 1)
        
        self.addSubview(imageView)
        self.addSubview(textLabel)
        self.addSubview(detailTextLabel)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadMovieInfo()
    {
        if imageView.image != nil {
            return
        }
        let url = NSURL(string: "https://www.youtube.com/embed/\(movieId)")
        let dic = HCYoutubeParser.h264videosWithYoutubeURL(url)
        
        movieUrl = NSURL(string: dic["medium"] as NSString)
        insertData(dic["moreInfo"]! as NSDictionary)
    }
    
    func insertData(info:NSDictionary)
    {
        var image = UIImage.loadImage(movieId)
        if (image != nil) {
            self.imageView?.image = image
        } else {
            getImage(info["iurl"] as String)
        }
        var seconds          = info["length_seconds"] as String
        var time             = ajustTime(seconds.toInt()!)
        
        textLabel.text       = info["title"] as? String
        detailTextLabel.text = "再生時間：\(time)"
    }
    
    func ajustTime(second:Int) -> String
    {
        if 3600 <= second {
            var hour = second/3600
            var min  = second/60 - hour*60
            var sec  = second - (hour*3600 + min*60)
            return "\(hour)時間\(min)分\(sec)秒"
            
        } else if 60 <= second {
            var min = second/60
            var sec = second - min*60
            return "\(min)分\(sec)秒"
        } else {
            return "\(second)秒"
        }
    }
    
    func getImage(url:String!)
    {
        Alamofire.request(.GET, url, parameters: nil)
            .progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) -> Void in
                println("\(totalBytesRead) / \(totalBytesExpectedToRead)")
            }
            .response { (request, response, imageData, error) in
                if error == nil && imageData != nil {
                    var image = imageData as NSData
                    if UIImage.saveImage(image, filename: self.movieId) {
                        self.imageView.image = UIImage(data: image)
                    }
                }
        }
    }
}
