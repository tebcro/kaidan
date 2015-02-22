//
//  Collection.swift
//  kaidan
//
//  Created by mizota on 2015/02/15.
//  Copyright (c) 2015年 tebcro. All rights reserved.
//

import UIKit
import Alamofire
import Alamofire_SwiftyJSON
import SVProgressHUD
import HCYoutubeParser

let reuseIdentifier = "ListCell"

class List: UICollectionViewController ,UICollectionViewDelegateFlowLayout {

    var data = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeNavigationItems()
        self.makeToolBarItems()

        self.collectionView!.registerClass(ListCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.collectionView?.backgroundColor = UIColor.hexStr("E9E9F5", alpha: 1)
        self.loadList()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func makeNavigationItems()
    {
        self.title = "怪談耳"
        
        let searchBtn    = UIButton.buttonWithType(.Custom) as? UIButton
        searchBtn?.frame = CGRectMake(0, 0, 20, 20)
        searchBtn?.setBackgroundImage(UIImage(named: "search"), forState: .Normal)
        searchBtn?.addTarget(self, action: "doSearch", forControlEvents: .TouchUpInside)
        let searchItem = UIBarButtonItem(customView: searchBtn!)
        
        let menuBtn    = UIButton.buttonWithType(.Custom) as? UIButton
        menuBtn?.frame = CGRectMake(0, 0, 20, 20)
        menuBtn?.setBackgroundImage(UIImage(named: "menu"), forState: .Normal)
        menuBtn?.addTarget(self, action: "doMenu", forControlEvents: .TouchUpInside)
        let menuItem = UIBarButtonItem(customView: menuBtn!)
        
        self.navigationItem.leftBarButtonItem  = searchItem
        self.navigationItem.rightBarButtonItem = menuItem
    }
    
    func makeToolBarItems()
    {
        let prevBtn    = UIButton.buttonWithType(.Custom) as? UIButton
        prevBtn?.frame = CGRectMake(0, 0, 26, 26)
        prevBtn?.setImage(UIImage(named: "prev"), forState: .Normal)
        prevBtn?.addTarget(self, action: "doPrev", forControlEvents: .TouchUpInside)
        let prevItem = UIBarButtonItem(customView: prevBtn!)
        
        let nextBtn    = UIButton.buttonWithType(.Custom) as? UIButton
        nextBtn?.frame = CGRectMake(0, 0, 26, 26)
        nextBtn?.setImage(UIImage(named: "next"), forState: .Normal)
        nextBtn?.addTarget(self, action: "doNext", forControlEvents: .TouchUpInside)
        let nextItem = UIBarButtonItem(customView: nextBtn!)
        
        let playBtn     = UIButton.buttonWithType(.Custom) as? UIButton
        playBtn?.frame  = CGRectMake(0, 0, 110, 110)
        playBtn?.center = CGPointMake(self.view.center.x, self.view.frame.size.height)
        playBtn?.setImage(UIImage(named: "obaq"), forState: .Normal)
        playBtn?.layer.cornerRadius = 55
        playBtn?.backgroundColor    = UIColor.hexStr("3E1762", alpha: 1)
        playBtn?.imageEdgeInsets    = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        playBtn?.addTarget(self, action: "doPlay", forControlEvents: .TouchUpInside)
        playBtn?.addTarget(self, action: "changeBgClick:", forControlEvents: .TouchUpInside)
        playBtn?.addTarget(self, action: "changeBgRelease:", forControlEvents: .TouchDown)
        
        let space  = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let spacer = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        spacer.width = 130
        
        var toolbarItems = [space, prevItem, space, spacer, space, nextItem, space]
        
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.height-30, self.view.frame.size.width, 50))
        toolBar.items = toolbarItems
        
        self.view.addSubview(toolBar)
        self.view.addSubview(playBtn!)
    }
    
    func makeHideFooter()
    {
        var footerView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 100))
        var obaq = UIImageView(image: UIImage(named: "scroll_after"))
        footerView.addSubview(obaq)
        
        var height = CGFloat(data.count ?? 0) * 78
        footerView.frame = CGRectMake((self.view.frame.width - obaq.frame.size.width)/2, height, footerView.frame.size.width, footerView.frame.size.height)
        
        self.collectionView?.addSubview(footerView)
    }
    
    func doMenu()
    {
        
    }
    
    func doSearch()
    {
        
    }
    
    func doPrev()
    {
        
    }
    
    func doNext()
    {
        
    }
    
    func doPlay()
    {
        
    }
    
    func changeBgClick(sender : UIButton)
    {
        sender.backgroundColor = UIColor.hexStr("3E1762", alpha: 1)
    }
    
    func changeBgRelease(sender : UIButton)
    {
        sender.backgroundColor = UIColor.hexStr("290E41", alpha: 1)
    }
    
    func loadList()
    {
        SVProgressHUD.showWithStatus("一覧取得中..", maskType: .Black)
        let parameters = []
        Alamofire.request(.GET, LIST_API_URL, parameters: nil)
            .responseSwiftyJSON { (request, response, json, error) in
                if response!.statusCode == 200
                {
                    let listData = json.object as NSDictionary
                    var date     = NSDate.dateFromString(listData["update"] as String)
                    if self.checkUpdateData(date) {
                        NSDate.save(LATEST_UPDATE, saveDate: date)
                        self.loadShowListData(listData["lists"]! as Array)
                    } else {
                        self.data = NSMutableArray.load(LATEST_LIST)!
                        self.complateListData()
                    }
                    
                } else
                {
                    println(error)
                    SVProgressHUD.showErrorWithStatus("取得失敗！")
                }
        }
    }
    
    func checkUpdateData(date: NSDate) -> Bool
    {
        var latest:NSDate? = NSDate.load(LATEST_UPDATE)
        if latest == nil {
            return true
        }
        
        switch(date.compare(latest!))
        {
            case .OrderedSame: return false
            case .OrderedAscending: return true
            default: return false
        }
    }
    
    func loadShowListData(listData: [String])
    {
        for movieId in listData {
            let url  = NSURL(string: "https://www.youtube.com/embed/\(movieId)")
            var info = HCYoutubeParser.h264videosWithYoutubeURL(url)
            var list = [movieId, info]
            
            data.addObject(list)
        }
        NSMutableArray.save(LATEST_LIST, saveArray: data)
        complateListData()
    }
    
    func complateListData()
    {
        self.collectionView?.reloadData()
        self.makeHideFooter()
        SVProgressHUD.showSuccessWithStatus("取得完了！")
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count ?? 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> ListCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as? ListCell
        
        var list      = data.objectAtIndex(indexPath.row) as NSArray
        cell!.movieId = list[0] as String
        cell!.insertData(list[1] as [NSObject : AnyObject])
        
        NSLog("index=%d", indexPath.row)
        
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            cell!.alpha = 1.0
        }) { (Bool finish) -> Void in
            
        }
        return cell!
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as ListCell
        cell.effect()
//        moviePlayer = MPMoviePlayerController(contentURL: cell.movieUrl)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(5, 0, 10, 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSize(width: self.view.frame.size.width, height: 60)
    }
    
    override func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath)
    {
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as ListCell
        cell.contentView.backgroundColor = UIColor.hexStr("670000", alpha: 1)
    }
    
    override func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath)
    {
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as ListCell
        cell.contentView.backgroundColor = UIColor.hexStr("FFFFFF", alpha: 1)
        cell.resetFontColor()
    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
