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

let reuseIdentifier = "Cell"

class List: UICollectionViewController ,UICollectionViewDelegateFlowLayout {

    var data:NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeNavigationItems()
        self.makeToolBarItems()

        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
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
        
        let space  = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let spacer = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        spacer.width = 130
        
        var toolbarItems = [space, prevItem, space, spacer, space, nextItem, space]
        
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.height-30, self.view.frame.size.width, 50))
        toolBar.items = toolbarItems
        
        self.view.addSubview(toolBar)
        self.view.addSubview(playBtn!)
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
    
    func loadList()
    {
        SVProgressHUD.showWithStatus("一覧取得中..", maskType: .Black)
        let parameters = []
        Alamofire.request(.GET, LIST_API_URL, parameters: nil)
            .responseSwiftyJSON { (request, response, json, error) in
                if response!.statusCode == 200
                {
                    let listData: NSDictionary = json.object as NSDictionary
                    self.data = listData["lists"]! as? NSMutableArray
                    self.collectionView?.reloadData()
                    SVProgressHUD.showSuccessWithStatus("取得完了！")
                    
                } else
                {
                    println(error)
                    SVProgressHUD.showErrorWithStatus("取得失敗！")
                }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> ListCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ListCell", forIndexPath: indexPath) as ListCell
    
        cell.movieId  = data?.objectAtIndex(indexPath.row) as NSString
        
        var info      = loadMovieInfo(cell.movieId)
        cell.movieUrl = NSURL(string: info!["medium"] as NSString)
        cell.makeFields(info?["moreInfo"]! as NSDictionary)
    
        return cell
    }
    
    func loadMovieInfo(movieId: String)->NSDictionary?
    {
        let url  = NSURL(string: "https://www.youtube.com/embed/\(movieId)")
        let dict = HCYoutubeParser.h264videosWithYoutubeURL(url)
        NSLog("dict=%@", dict)
        return dict
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(5, 0, 10, 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSize(width: self.view.frame.size.width, height: 60)
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
