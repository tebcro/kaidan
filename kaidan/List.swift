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
        
        let searchBtn = UIButton.buttonWithType(.Custom) as? UIButton
        searchBtn?.setBackgroundImage(UIImage(named: "search"), forState: .Normal)
        searchBtn?.frame = CGRectMake(0, 0, 20, 20)
        searchBtn?.addTarget(self, action: "doSearch", forControlEvents: .TouchUpInside)
        let searchItem = UIBarButtonItem(customView: searchBtn!)
        
        let menuBtn = UIButton.buttonWithType(.Custom) as? UIButton
        menuBtn?.setBackgroundImage(UIImage(named: "menu"), forState: .Normal)
        menuBtn?.addTarget(self, action: "doMenu", forControlEvents: .TouchUpInside)
        menuBtn?.frame = CGRectMake(0, 0, 20, 20)
        let menuItem = UIBarButtonItem(customView: menuBtn!)
        
        self.navigationItem.leftBarButtonItem  = searchItem
        self.navigationItem.rightBarButtonItem = menuItem
    }
    
    func doMenu()
    {
        
    }
    
    func doSearch()
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
