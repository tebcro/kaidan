//
//  List.swift
//  kaidan
//
//  Created by 溝田隆明 on 2015/02/14.
//  Copyright (c) 2015年 tebcro. All rights reserved.
//

import UIKit

class List: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "ゆっくり怪談"
        
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
    
    func doSearch()
    {
        
    }
    
    func doMenu()
    {
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
