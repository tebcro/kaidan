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

    var data         = NSMutableArray()
    var kaidanPlayer = KaidanPlayer()
    
    override func viewDidLoad()
    {
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

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //ナビゲーション生成
    func makeNavigationItems()
    {
        self.title = "怪談耳"
        
        let searchBtn    = UIButton.buttonWithType(.Custom) as? UIButton
        searchBtn?.frame = CGRectMake(0, 0, 20, 20)
        searchBtn?.setBackgroundImage(UIImage(named: "search"), forState: .Normal)
        searchBtn?.addTarget(self, action: "doSearch", forControlEvents: .TouchUpInside)
        
        let menuBtn    = UIButton.buttonWithType(.Custom) as? UIButton
        menuBtn?.frame = CGRectMake(0, 0, 20, 20)
        menuBtn?.setBackgroundImage(UIImage(named: "menu"), forState: .Normal)
        menuBtn?.addTarget(self, action: "doMenu", forControlEvents: .TouchUpInside)
        
        let searchItem = UIBarButtonItem(customView: searchBtn!)
        let menuItem = UIBarButtonItem(customView: menuBtn!)
        
        self.navigationItem.leftBarButtonItem  = searchItem
        self.navigationItem.rightBarButtonItem = menuItem
    }
    
    //ツールバー生成
    func makeToolBarItems()
    {
        let prevBtn    = UIButton.buttonWithType(.Custom) as? UIButton
        prevBtn?.frame = CGRectMake(0, 0, 26, 26)
        prevBtn?.setImage(UIImage(named: "prev"), forState: .Normal)
        prevBtn?.addTarget(self, action: "doPrev", forControlEvents: .TouchUpInside)
        
        let nextBtn    = UIButton.buttonWithType(.Custom) as? UIButton
        nextBtn?.frame = CGRectMake(0, 0, 26, 26)
        nextBtn?.setImage(UIImage(named: "next"), forState: .Normal)
        nextBtn?.addTarget(self, action: "doNext", forControlEvents: .TouchUpInside)
        
        let playBtn     = UIButton.buttonWithType(.Custom) as? UIButton
        playBtn?.frame  = CGRectMake(0, 0, 110, 110)
        playBtn?.center = CGPointMake(self.view.center.x, self.view.frame.size.height)
        playBtn?.setImage(UIImage(named: "obaq"), forState: .Normal)
        playBtn?.layer.cornerRadius = 55
        playBtn?.backgroundColor    = UIColor.hexStr("3E1762", alpha: 1)
        playBtn?.imageEdgeInsets    = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        playBtn?.addTarget(self, action: "doPlay", forControlEvents: .TouchUpInside)
        
        let prevItem = UIBarButtonItem(customView: prevBtn!)
        let nextItem = UIBarButtonItem(customView: nextBtn!)
        let space    = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let spacer   = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        spacer.width = 130
        
        var toolbarItems = [space, prevItem, space, spacer, space, nextItem, space]
        
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.height-30, self.view.frame.size.width, 50))
        toolBar.items = toolbarItems
        
        self.view.addSubview(toolBar)
        self.view.addSubview(playBtn!)
    }
    
    // フッターに隠しオバケ表示
    func makeHideFooter()
    {
        var footerView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 100))
        var obaq       = UIImageView(image: UIImage(named: "scroll_after"))
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
        switch(kaidanPlayer.playbackState)
        {
            case .Playing: kaidanPlayer.pause()
            case .Paused: kaidanPlayer.play()
            case .Stopped:
                var index = NSIndexPath(forRow: 0, inSection: 0)
                var cell  = self.collectionView!.cellForItemAtIndexPath(index) as ListCell
                player(cell.movieUrl!)
            case .SeekingBackward: NSLog("SeekingBackward")
            case .SeekingForward: NSLog("SeekingForward")
            default: NSLog("default")
        }
    }
    
    //基本データの通信・取得
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
    
    //日付データが新しくなっているかどうかをチェック
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
    
    //youtubeのAPI使って詳細情報を取得（これは結構時間がかかる）
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
    
    //取得完了時に呼び出し
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
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as ListCell
        let detail = makeDetail(cell)
//        let detail = self.storyboard?.instantiateViewControllerWithIdentifier("Detail") as Detail
//        detail.useLayoutToLayoutNavigationTransitions = true
//        detail.title                                  = cell.textLabel.text
        self.navigationController?.pushViewController(detail, animated: true)
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
        cell.contentView.backgroundColor = UIColor.hexStr("DDDDDD", alpha: 1)
    }
    
    override func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath)
    {
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as ListCell
        cell.contentView.backgroundColor = UIColor.hexStr("FFFFFF", alpha: 1)
        cell.resetFontColor()
    }
    
    override func collectionView(collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout!
    {
        var transitionLayout = UICollectionViewTransitionLayout(currentLayout: fromLayout, nextLayout: toLayout)
        return transitionLayout
    }
    
    private func makeDetail(cell: ListCell) -> UICollectionViewController
    {
        var detailGrid:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        detailGrid.scrollDirection                = .Horizontal
        detailGrid.itemSize                       = CGSizeMake(300, 420)
        
        var detail                                    = UICollectionViewController(collectionViewLayout: detailGrid)
        detail.useLayoutToLayoutNavigationTransitions = true
        detail.title                                  = cell.textLabel.text
        
        return detail
    }
    
    // MARK: プレイヤー呼び出し
    private func player(url:NSURL)
    {
        kaidanPlayer = KaidanPlayer(contentURL: url)
        kaidanPlayer.play()
    }
}
