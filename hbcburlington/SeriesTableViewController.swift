//
//  SeriesTableViewController.swift
//  rethink
//
//  Created by John Stewrt on 4/19/16.
//  Copyright © 2016 FaitNetwork, Inc. All rights reserved.
//

import UIKit
import CoreData

class SeriesTableViewController: UITableViewController {
    
    var json_data_url = "/rss/json/messages.aspx"
    
    var TableData:Array< datastruct > = Array < datastruct >()
    var routerTitle:String!
    
    var tableBackgroundColor:UIColor?
    var tablecellTitleColor:UIColor?
    
    var navbarColor:UIColor?
    var navbartitleColor:UIColor?
    var navbarbuttonsColor:UIColor?
    
    var fontBold:String?
    var fontRegular:String?

    
    @IBOutlet var tableview: UITableView!
    
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
        var imageurl:String?
        var description:String?
        var image:UIImage? = nil
        var author:String?
        var messageGuid:String?
        
        init(add: NSDictionary)
        {
            imageurl = add["image"] as? String
            description = add["title"] as? String
            author = add["author"] as? String
            messageGuid = add["messageguid"] as? String
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.title = routerTitle
        readPropertyList()
       tableview.contentInset = UIEdgeInsetsMake(0, -20, 0, 0);
        
        tableview.dataSource = self
        tableview.delegate = self
        debugPrint(baseUrl! + json_data_url)
        
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
        
        cell.textLabel?.text = data.description
         cell.textLabel?.textColor = tablecellTitleColor
         cell.textLabel?.font = UIFont(name: fontBold!, size: 16)
        
        if data.author != nil {
            cell.detailTextLabel?.text = data.author
        } else
        {
            cell.detailTextLabel?.text = "";
        }
         cell.detailTextLabel?.textColor = tablecellTitleColor
        cell.detailTextLabel?.font = UIFont(name: fontRegular!, size: 14)
        
        if (data.image == nil)
        {
            cell.imageView?.image = UIImage(named:"image.jpg")
            load_image(data.imageurl!, imageview: cell.imageView!, index: indexPath.row)
        }
        else
        {
            cell.imageView?.image = TableData[indexPath.row].image
        }
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return TableData.count
    }
    
    
    
    
    
    
    
    func get_data_from_url(url:String)
    {
        
        
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
            
            do
            {
                try read()
            }
            catch
            {
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
    
    
    func load_image(urlString:String, imageview:UIImageView, index:NSInteger)
    {
        
        let url:NSURL = NSURL(string: urlString)!
        let session = NSURLSession.sharedSession()
        
        let task = session.downloadTaskWithURL(url) {
            (
            let location, let response, let error) in
            
            guard let _:NSURL = location, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            
            let imageData = NSData(contentsOfURL: location!)
            
            dispatch_async(dispatch_get_main_queue(), {
                
                
                self.TableData[index].image = UIImage(data: imageData!)
                self.save(index,image: self.TableData[index].image!)
                
                imageview.image = self.TableData[index].image
                return
            })
            
            
        }
        
        task.resume()
        
        
    }
    
    
    
    
    func read() throws
    {
        
        do
        {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            let fetchRequest = NSFetchRequest(entityName: "Images")
            
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest)
            
            for (var i=0; i < fetchedResults.count; i++)
            {
                let single_result = fetchedResults[i]
                let index = single_result.valueForKey("index") as! NSInteger
                let img: NSData? = single_result.valueForKey("image") as? NSData
                
                TableData[index].image = UIImage(data: img!)
                
            }
            
        }
        catch
        {
            print("error")
            throw ErrorHandler.ErrorFetchingResults
        }
        
    }
    
    func save(id:Int,image:UIImage)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Images",
            inManagedObjectContext: managedContext)
        let options = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext:managedContext)
        
        let newImageData = UIImageJPEGRepresentation(image,1)
        
        options.setValue(id, forKey: "index")
        options.setValue(newImageData, forKey: "image")
        
        do {
            try managedContext.save()
        } catch
        {
            print("error")
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "episodesSegue" {
            if let destinationVC = segue.destinationViewController as? EpisodesTableViewController {
                if let rowIndex = tableview.indexPathForSelectedRow?.row {
                    let data = TableData[rowIndex]
                    destinationVC.title = data.description
                    destinationVC.messageGuid = data.messageGuid!;
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
