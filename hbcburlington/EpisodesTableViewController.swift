//
//  EpisodesTableViewController.swift
//  rethink
//
//  Created by John Stewrt on 4/19/16.
//  Copyright © 2016 FaitNetwork, Inc. All rights reserved.
//

import UIKit
import SDWebImage

class EpisodesTableViewController: UITableViewController {

    @IBOutlet var tableview: UITableView!
    
    var messageGuid:String = String()
    var json_data_url = "/rss/json/messageepisodes.aspx?messageguid="
    var TableData:Array< datastruct > = Array < datastruct >()
    
    var tableBackgroundColor:UIColor?
    var tablecellTitleColor:UIColor?
    var baseUrl: String?
    
    var fontBold:String?
    var fontRegular:String?
     var appGuid: String?
    
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
        var image:String?
        var title:String?
        var description:String?
        var author:String?
        var episodeGuid:String?
        var videoUrl:String?
        var audioUrl:String?
        var thedate:String?
        var messagetitle:String?
        
        init(add: NSDictionary)
        {
            image = add["image"] as? String
            title = add["title"] as? String
            description = add["description"] as? String
            author = add["author"] as? String
            episodeGuid = add["episodeguid"] as? String
            videoUrl = add["videourl"] as? String
            audioUrl = add["audiourl"] as? String
            thedate = add["date"] as? String
            messagetitle = add["messagetitle"] as? String
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        readPropertyList()
        self.title = title;
        tableview.dataSource = self
        tableview.delegate = self
        debugPrint(baseUrl! + json_data_url + messageGuid)
        self.tableView.backgroundColor = tableBackgroundColor
        get_data_from_url(baseUrl! + json_data_url + messageGuid)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let data = TableData[indexPath.row]
        
        cell.backgroundColor = tableBackgroundColor
        cell.tintColor = tablecellTitleColor

        
        
        cell.textLabel?.text = data.title
        cell.textLabel?.font = UIFont(name: fontBold!, size: 18)
        cell.textLabel?.textColor = tablecellTitleColor
        
        if data.author != nil && data.author != ""  {
            cell.detailTextLabel?.text = data.author! + ", " + data.thedate!
        } else
        {
            cell.detailTextLabel?.text = data.thedate;
        }
         cell.detailTextLabel?.font = UIFont(name: fontRegular!, size: 14)
        cell.detailTextLabel?.textColor = tablecellTitleColor
        
   // let ImageUrl:NSURL? = NSURL(string:data.image!)
        
   // cell.imageView?.sd_setImageWithURL(ImageUrl)
  

        
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
        if segue.identifier == "episodeSegue" {
            if let destinationVC = segue.destinationViewController as? EpisodeViewController {
                if let rowIndex = tableview.indexPathForSelectedRow?.row {
                    let data = TableData[rowIndex]
                    destinationVC.thetitle = data.title!
                    destinationVC.thedescription = data.description!;
                    destinationVC.image = data.image!;
                    destinationVC.audioUrl = data.audioUrl!;
                    destinationVC.videoUrl = data.videoUrl!;
                    destinationVC.thedate = data.thedate!;
                    destinationVC.author = data.author!;
                    destinationVC.messageTitle = data.messagetitle!;
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
