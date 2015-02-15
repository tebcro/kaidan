//
//  ListCell.swift
//  kaidan
//
//  Created by mizota on 2015/02/15.
//  Copyright (c) 2015年 tebcro. All rights reserved.
//

import UIKit
import Alamofire

class ListCell: UITableViewCell {

    var movieId:String = ""
    
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
                        self.imageView!.image = UIImage(data: image)
                    }
                }
        }
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.imageView!.frame              = CGRectMake(10, 10, 40, 40)
        self.imageView!.backgroundColor    = UIColor.hexStr("EEEEEE", alpha: 1)
        self.imageView!.clipsToBounds      = true;
        self.imageView!.layer.cornerRadius = 20;
        self.backgroundColor               = UIColor.hexStr("FFFF33", alpha: 0.9)
        self.textLabel?.frame              = CGRectMake(60, 10, 250, 20)
        self.detailTextLabel?.frame        = CGRectMake(60, 30, 250, 20)
    }
}
