//
//  Navigation.swift
//  kaidan
//
//  Created by 溝田隆明 on 2015/02/14.
//  Copyright (c) 2015年 tebcro. All rights reserved.
//

import UIKit

class Navigation: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }
    
    override func shouldAutorotate() -> Bool
    {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int
    {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }

}
