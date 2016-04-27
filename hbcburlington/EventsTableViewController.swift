//
//  EventsTableViewController.swift
//  arcentral
//
//  Created by John Stewrt on 4/21/16.
//  Copyright © 2016 FaitNetwork, Inc. All rights reserved.
//

import UIKit

class EventsTableViewController:  UITableViewController {
    
    @IBOutlet var tableview: UITableView!
    

    var json_data_url = "/rss/json/eventsnohtmlwithguidwithdates.aspx"
    var TableData:Array< datastruct > = Array < datastruct >()
    var routerTitle:String!
    
    var tableBackgroundColor:UIColor?
    var tablecellTitleColor:UIColor?
    
    var navbarColor:UIColor?
    var navbartitleColor:UIColor?
    var navbarbuttonsColor:UIColor?
    
     var fontBold:String?
     var fontRegular:String?

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
        var moreInfo:String?
        var eventGuid:String?
        var startdatemonth:String?
        var startdateday:String?
        var startdate:String?
        var enddate:String?
        var starttime:String?
        var endtime:String?
        var startdatetime:String?
        var enddatetime:String?

        
        init(add: NSDictionary)
        {
       
            title = add["title"] as? String
            description = add["description"] as? String
            moreInfo = add["moreinfo"] as? String
            eventGuid = add["id"] as? String
            startdatemonth = add["startdatemonth"] as? String
            startdateday = add["startdateday"] as? String
            startdate = add["startdate"] as? String
            enddate = add["enddate"] as? String
            starttime = add["starttime"] as? String
            endtime = add["endtime"] as? String
            startdatetime = add["startdatetime"] as? String
            enddatetime = add["enddatetime"] as? String
      
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
       
        get_data_from_url(baseUrl! + json_data_url)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            "cell", forIndexPath: indexPath)
            as! EventsTableViewCell
        
        let data = TableData[indexPath.row]
        
        
        //cell.textLabel?.text = data.title
        //cell.textLabel?.textColor = UIColor.whiteColor()
        cell.backgroundColor = tableBackgroundColor
        cell.tintColor = tablecellTitleColor
        
        cell.lblDay?.text = data.startdateday
        cell.lblDay?.textColor = navbarColor
        cell.lblDay?.font = UIFont(name: fontBold!, size: 30)
        
        cell.lblMonth?.text = data.startdatemonth
        cell.lblMonth?.textColor = navbarColor
        cell.lblMonth?.font = UIFont(name: fontRegular!, size: 13)
        
        cell.lblTitle?.text = data.title?.truncate(23)
        cell.lblTitle?.textColor = tablecellTitleColor
        cell.lblTitle.font = UIFont(name: fontBold!, size: 18)
        
        cell.lblDate?.text = data.startdate
        cell.lblDate?.textColor = navbarColor
        cell.lblDate?.font = UIFont(name: fontRegular!, size: 14)
        
        /*var contentLabel: UILabel!
        contentLabel = UILabel()
        contentLabel.frame = CGRectMake(60, 2, 290, 20)
        contentLabel.textColor = tablecellTitleColor
        contentLabel.numberOfLines = 1;
        contentLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        contentLabel.text = data.title?.truncate(30);
        cell.contentView.addSubview(contentLabel)
        
    
        var dateLabel: UILabel!
        dateLabel = UILabel()
        dateLabel.frame = CGRectMake(60, 25, 290, 15)
        dateLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        dateLabel.textColor = tablecellTitleColor
        dateLabel.text = data.startdate
        cell.contentView.addSubview(dateLabel)
        
        var dayLabel: UILabel!
        dayLabel = UILabel()
        dayLabel.frame = CGRectMake(10, 2, 50, 25);
        dayLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        dayLabel.textColor =  navbarColor
        dayLabel.text = data.startdateday
        cell.contentView.addSubview(dayLabel)
        
        
        var monthLabel: UILabel!
        monthLabel = UILabel()
        monthLabel.frame = CGRectMake(15, 27, 50, 15)
        monthLabel.font = UIFont(name: "HelveticaNeue-Light", size: 13)
        monthLabel.textColor = navbarColor
        monthLabel.text = data.startdatemonth
        cell.contentView.addSubview(monthLabel);
        
        */
        
  
        
        // let ImageUrl:NSURL? = NSURL(string:data.image!)
        
        // cell.imageView?.sd_setImageWithURL(ImageUrl)
        
        
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return TableData.count
    }
    
    
    
    
    func refresh(sender:AnyObject)
    {
        // Updating your data here...
        
         self.tableview.reloadData()
        self.refreshControl?.endRefreshing()
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
        if segue.identifier == "eventSegue" {
            if let destinationVC = segue.destinationViewController as? EventViewController {
                if let rowIndex = tableview.indexPathForSelectedRow?.row {
                    let data = TableData[rowIndex]

                    destinationVC.eventGuid = data.eventGuid!;
                    destinationVC.thetitle = data.title!;
                    destinationVC.thedescription = data.description!;
                    destinationVC.startdate = data.startdate!;
                    destinationVC.enddate = data.enddate!;
                    destinationVC.starttime = data.starttime!;
                    destinationVC.endtime = data.endtime!;
                    destinationVC.startdatetime = data.startdatetime!;
                    destinationVC.enddatetime = data.enddatetime!;

        
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
