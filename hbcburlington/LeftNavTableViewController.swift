//
//  LeftNavTableViewController.swift
//  hbcburlington
//
//  Created by John Stewrt on 4/25/16.
//  Copyright © 2016 FaitNetwork, Inc. All rights reserved.
//

import UIKit

class LeftNavTableViewController: UITableViewController {
    
    @IBOutlet var tableview: UITableView!
    
    var json_data_url = "/rss/json/appnavigation.aspx?appguid="
    var TableData:Array< datastruct > = Array < datastruct >()
    var tableBackgroundColor:UIColor?
    var tablecellTitleColor:UIColor?
    var tableSeperatorColor:UIColor?
    
    var appGuid: String?
    var baseUrl: String?
    
      var fontRegular:String?
    
    func readPropertyList(){
        var format = NSPropertyListFormat.XMLFormat_v1_0 //format of the property list
        var plistData:[String:AnyObject] = [:]  //our data
        let plistPath:String? = NSBundle.mainBundle().pathForResource("appsettings", ofType: "plist")!
        let plistXML = NSFileManager.defaultManager().contentsAtPath(plistPath!)!
        do{
            plistData = try NSPropertyListSerialization.propertyListWithData(plistXML,
                options: .MutableContainersAndLeaves,
                format: &format)
                as! [String:AnyObject]
            
            
            //set vars from plist
            appGuid = plistData["appGuid"] as? String
            baseUrl = plistData["baseUrl"] as? String
            fontRegular = plistData["fontRegular"] as? String
            
            //set navbar title tint from plist
            var red = plistData["navtableBackgroundRed"] as! CGFloat
            var green = plistData["navtableBackgroundGreen"] as! CGFloat
            var blue = plistData["navtableBackgroundBlue"] as! CGFloat
            
            red = red/255
            green = green/255
            blue = blue/255
            
            tableBackgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            
            
            red = plistData["navtablecellTitleRed"] as! CGFloat
            green = plistData["navtablecellTitleGreen"] as! CGFloat
            blue = plistData["navtablecellTitleBlue"] as! CGFloat
            
            red = red/255
            green = green/255
            blue = blue/255
            
            tablecellTitleColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            
            
            red = plistData["navtableSeperatorRed"] as! CGFloat
            green = plistData["navtableSeperatorGreen"] as! CGFloat
            blue = plistData["navtableSeperatorBlue"] as! CGFloat
            
            red = red/255
            green = green/255
            blue = blue/255
            
            tableSeperatorColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            
        }
        catch{
            print("Error reading plist: \(error), format: \(format)")
        }
        
    }

    
    enum ErrorHandler:ErrorType
    {
        case ErrorFetchingResults
    }
    
    
    struct datastruct
    {
        
        var title:String?
        var type:String?
        var url:String?

        
        
        init(add: NSDictionary)
        {
            
            title = add["title"] as? String
            type = add["type"] as? String
            url = add["url"] as? String
    
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readPropertyList()
        tableview.contentInset = UIEdgeInsetsMake(0, -20, 0, 0);
        tableview.dataSource = self
        tableview.delegate = self
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Refreshing...")
        self.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl!)
        
        self.tableView.backgroundColor = tableBackgroundColor
        self.tableView.separatorColor = tableSeperatorColor
        
        debugPrint(baseUrl! + json_data_url + appGuid!)
        
        get_data_from_url(baseUrl! + json_data_url + appGuid!)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func refresh(sender:AnyObject)
    {
        // Updating your data here...
        
        self.tableview.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let data = TableData[indexPath.row]
        //cell.selectionStyle = .None
        
        cell.textLabel?.text = data.title?.truncate(40)
       // cell.textLabel?.font = UIFont(name: "Economica-Bold", size: 20)
        cell.textLabel?.textColor = tablecellTitleColor
        cell.textLabel?.font = UIFont(name: fontRegular!, size: 18)
        
        cell.backgroundColor = tableBackgroundColor
        cell.tintColor = tablecellTitleColor
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    
        //cell.detailTextLabel?.text = data.createddate!
        //cell.detailTextLabel?.font = UIFont(name: "Economica-Regular", size: 14)
       // cell.detailTextLabel?.textColor = UIColor.whiteColor()
        
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return TableData.count
    }
    
    
    
    
    
    
    
    func get_data_from_url(url:String)
    {
        debugPrint("theurl=" + url)
        
        let url:NSURL = NSURL(string: url)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.extract_json(data!)
                return
            })
            
        }
        
        task.resume()
        
    }
    
    
    func extract_json(jsonData:NSData)
    {
        debugPrint(jsonData)
        let json: AnyObject?
        do {
            json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
        } catch {
            json = nil
            return
        }
        
        if let list = json as? NSArray
        {
            for (var i = 0; i < list.count ; i++ )
            {
                if let data_block = list[i] as? NSDictionary
                {
                    
                    TableData.append(datastruct(add: data_block))
                }
            }
            
            
            do_table_refresh()
            
        }
        
        
    }
    
    
    
    
    func do_table_refresh()
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableview.reloadData()
            return
        })
    }
    
    
    

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
            let data = TableData[indexPath.row]
        debugPrint(data.type)
        
        
            
            if (data.type == "webviewcontentpage" || data.type == "webviewlinkurl" || data.type == "webviewevite" || data.type == "webviewprayrequest")
            {
                self.revealViewController().revealToggleAnimated(true)
                if let vc = self.storyboard!.instantiateViewControllerWithIdentifier("webviewViewController") as? WebviewViewController
                {
 
                vc.routerTitle = data.title
                vc.routerUrl = data.url
                
                 let nc = self.storyboard!.instantiateViewControllerWithIdentifier("pageNavController") as? UINavigationController
                
   
             
                //nc?.setViewControllers([vc], animated: true)
                nc?.pushViewController(vc, animated: true)
                
                self.revealViewController().setFrontViewController(nc, animated: true)
                self.revealViewController().setFrontViewPosition(FrontViewPosition.Left, animated: true)
                }
        }
        else if (data.type == "webviewcontentpageexternal" )
        {
            self.revealViewController().revealToggleAnimated(true)
            if let vc = self.storyboard!.instantiateViewControllerWithIdentifier("webviewExternalViewController") as? WebviewExternalViewController
            {
                
                vc.routerTitle = data.title
                vc.routerUrl = data.url
                
                let nc = self.storyboard!.instantiateViewControllerWithIdentifier("pageNavController") as? UINavigationController
                
                
                
                //nc?.setViewControllers([vc], animated: true)
                nc?.pushViewController(vc, animated: true)
                
                self.revealViewController().setFrontViewController(nc, animated: true)
                self.revealViewController().setFrontViewPosition(FrontViewPosition.Left, animated: true)
            }
        }
            else if (data.type == "home" )
            {
                self.revealViewController().revealToggleAnimated(true)
        }
            else if (data.type == "messagearchive" )
            {
                
                self.revealViewController().revealToggleAnimated(true)
                if let vc = self.storyboard!.instantiateViewControllerWithIdentifier("seriesTableViewController") as? SeriesTableViewController
                {
                    
                    vc.routerTitle = data.title
                   
                    
                    let nc = self.storyboard!.instantiateViewControllerWithIdentifier("pageNavController") as? UINavigationController
                    
                    
                    
                    //nc?.setViewControllers([vc], animated: true)
                    nc?.pushViewController(vc, animated: true)
                    
                    self.revealViewController().setFrontViewController(nc, animated: true)
                    self.revealViewController().setFrontViewPosition(FrontViewPosition.Left, animated: true)
                }

                
        }
            else if (data.type == "calendar" )
            {
                self.revealViewController().revealToggleAnimated(true)
                if let vc = self.storyboard!.instantiateViewControllerWithIdentifier("eventsTableViewController") as? EventsTableViewController
                {
                    
                    vc.routerTitle = data.title
                    
                    
                    let nc = self.storyboard!.instantiateViewControllerWithIdentifier("pageNavController") as? UINavigationController
                    
                    
                    
                    //nc?.setViewControllers([vc], animated: true)
                    nc?.pushViewController(vc, animated: true)
                    
                    self.revealViewController().setFrontViewController(nc, animated: true)
                    self.revealViewController().setFrontViewPosition(FrontViewPosition.Left, animated: true)
                }
        }
            else if (data.type == "alerts" )
            {
                self.revealViewController().revealToggleAnimated(true)
                if let vc = self.storyboard!.instantiateViewControllerWithIdentifier("alertsTableViewController") as? AlertsTableViewController
                {
                    
                    vc.routerTitle = data.title
                    
                    
                    let nc = self.storyboard!.instantiateViewControllerWithIdentifier("pageNavController") as? UINavigationController
                    
                    
                    
                    //nc?.setViewControllers([vc], animated: true)
                    nc?.pushViewController(vc, animated: true)
                    
                    self.revealViewController().setFrontViewController(nc, animated: true)
                    self.revealViewController().setFrontViewPosition(FrontViewPosition.Left, animated: true)
                }
        }

        
    }
    

}
