//
//  AlertsTableViewController.swift
//  arcentral
//
//  Created by John Stewrt on 4/21/16.
//  Copyright © 2016 FaitNetwork, Inc. All rights reserved.
//

import UIKit

class AlertsTableViewController:  UITableViewController {
    
    @IBOutlet var tableview: UITableView!
    
    var json_data_url = "/rss/json/alerts.aspx?appguid="
    var TableData:Array< datastruct > = Array < datastruct >()
    var routerTitle:String!
    
    var tableBackgroundColor:UIColor?
    var tablecellTitleColor:UIColor?
    
    var navbarColor:UIColor?
    var navbartitleColor:UIColor?
    var navbarbuttonsColor:UIColor?
    
    var fontBold:String?
    var fontRegular:String?
    
     var appGuid: String?
   
    
    var baseUrl: String?
    
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
            baseUrl = plistData["baseUrl"] as? String
            fontBold = plistData["fontBold"] as? String
            fontRegular = plistData["fontRegular"] as? String
            appGuid = plistData["appGuid"] as? String
            //set navbar title tint from plist
            var red = plistData["tableBackgroundRed"] as! CGFloat
            var green = plistData["tableBackgroundGreen"] as! CGFloat
            var blue = plistData["tableBackgroundBlue"] as! CGFloat
            
            red = red/255
            green = green/255
            blue = blue/255
            
            tableBackgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            
            
            red = plistData["tablecellTitleRed"] as! CGFloat
            green = plistData["tablecellTitleGreen"] as! CGFloat
            blue = plistData["tablecellTitleBlue"] as! CGFloat
            
            red = red/255
            green = green/255
            blue = blue/255
            
            tablecellTitleColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            
            //set navbar bg from plist
            red = plistData["navbarRed"] as! CGFloat
            green = plistData["navbarGreen"] as! CGFloat
            blue = plistData["navbarBlue"] as! CGFloat
            
            red = red/255
            green = green/255
            blue = blue/255
            
            navbarColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            
            
            //set navbar title tint from plist
            red = plistData["navbartitleRed"] as! CGFloat
            green = plistData["navbartitleGreen"] as! CGFloat
            blue = plistData["navbartitleBlue"] as! CGFloat
            
            red = red/255
            green = green/255
            blue = blue/255
            
            navbartitleColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            
            //set navbar button tints from plis
            red = plistData["navbarbuttonsRed"] as! CGFloat
            green = plistData["navbarbuttonsGreen"] as! CGFloat
            blue = plistData["navbarbuttonsBlue"] as! CGFloat
            
            red = red/255
            green = green/255
            blue = blue/255
            
            navbarbuttonsColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            
            
            
            
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
        var description:String?
        var moreinfo:String?
        var alertguid:String?
        var createddate:String?
  
        
        init(add: NSDictionary)
        {
            
            title = add["title"] as? String
            description = add["description"] as? String
            moreinfo = add["moreinfo"] as? String
            alertguid = add["alertguid"] as? String
            createddate = add["createddate"] as? String

        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = routerTitle
        readPropertyList()
        
        tableview.dataSource = self
        tableview.delegate = self
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Refreshing...")
        self.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl!)
        
        self.navigationController?.navigationBar.barTintColor = navbarColor
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.tintColor = navbarbuttonsColor
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: navbartitleColor!]
        self.navigationController!.navigationBar.titleTextAttributes = (titleDict as! [String : AnyObject])
        
        self.tableView.backgroundColor = tableBackgroundColor

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
        cell.backgroundColor = tableBackgroundColor
        cell.tintColor = tablecellTitleColor
        
        cell.textLabel?.text = data.title?.truncate(40)
         cell.textLabel?.font = UIFont(name: fontBold!, size: 18)
        cell.textLabel?.textColor = tablecellTitleColor
        
        
        cell.detailTextLabel?.text = data.createddate!
        cell.detailTextLabel?.font = UIFont(name: fontRegular!, size: 14)
        cell.detailTextLabel?.textColor = tablecellTitleColor
        
        
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
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "alertSegue" {
            if let destinationVC = segue.destinationViewController as? AlertViewController {
                if let rowIndex = tableview.indexPathForSelectedRow?.row {
                    let data = TableData[rowIndex]
                    destinationVC.alertGuid = data.alertguid!
                   
                }
            }
        }
    }
    
    
    override func shouldAutorotate() -> Bool {
        if (UIDevice.currentDevice().orientation == UIDeviceOrientation.Portrait ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.PortraitUpsideDown ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.Unknown) {
                return true
        }
        else {
            return false
        }
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        let orientation: UIInterfaceOrientationMask = [UIInterfaceOrientationMask.Portrait, UIInterfaceOrientationMask.PortraitUpsideDown]
        return orientation
    }
    
    
    
}