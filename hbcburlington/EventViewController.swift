//
//  EventViewController.swift
//  arcentral
//
//  Created by John Stewrt on 4/21/16.
//  Copyright © 2016 FaitNetwork, Inc. All rights reserved.
//

import UIKit
import EventKit

class EventViewController:  UIViewController, UIWebViewDelegate{
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBOutlet weak var toolbar: UIToolbar!
    var eventGuid:String = String()
    var thetitle:String = String()
    var thedescription:String = String()
    var startdate:String = String()
    var enddate:String = String()
    var starttime:String = String()
    var endtime:String = String()
     var enddatetime:String = String()
     var startdatetime:String = String()
    
    var baseUrl: String?
    var eventShareText: String?
    var clientName: String?
    var navbarColor:UIColor?
    var webviewBackgroundOpaque = true
    var webviewBackgroundColor:UIColor?
 

    
    
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
            eventShareText = plistData["eventShareText"] as? String
            clientName = plistData["clientName"] as? String
            webviewBackgroundOpaque = plistData["webviewBackgroundOpaque"] as! Bool
            
            
            //set navbar bg from plist
            var red = plistData["navbarRed"] as! CGFloat
            var green = plistData["navbarGreen"] as! CGFloat
            var blue = plistData["navbarBlue"] as! CGFloat
            
            red = red/255
            green = green/255
            blue = blue/255
            
            navbarColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            
            
            red = plistData["webviewBackgroundColorRed"] as! CGFloat
            green = plistData["webviewBackgroundColorGreen"] as! CGFloat
            blue = plistData["webviewBackgroundColorBlue"] as! CGFloat
            
            red = red/255
            green = green/255
            blue = blue/255
            
            webviewBackgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            
        }
        catch{
            print("Error reading plist: \(error), format: \(format)")
        }
        
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        readPropertyList()
        let webViewUrl = baseUrl! + "/eventDetailsappnonav.aspx?vieweventguid=" + eventGuid
        debugPrint(webViewUrl)
        
        self.toolbar.barTintColor = navbarColor
        
        // Do any additional setup after loading the view, typically from a nib.
        activity.hidesWhenStopped = true
        webView.opaque = webviewBackgroundOpaque
        if (webviewBackgroundOpaque)
        {
        webView.backgroundColor = UIColor.clearColor()
        }
        else
        {
         webView.backgroundColor = webviewBackgroundColor
        }
        webView.loadRequest(NSURLRequest(URL: NSURL(string: webViewUrl)!))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    func webViewDidStartLoad(webView: UIWebView) {
        activity.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        activity.stopAnimating()
    }
    
    
    
    
    @IBAction func shareButtonClicked(sender: UIButton) {
        let textToShare = eventShareText!
        let shareImg = UIImage(named:"iTunesArtwork.png")
 
        let textToShare2 = thetitle;
        let textToShare3 = thedescription;
        let textToShare4 = starttime;
        let textToShareSpace = " ";

        
        
        if let myWebsite = NSURL(string: baseUrl!) {
            let objectsToShare = [shareImg!,textToShare,textToShareSpace,textToShare2,textToShare3,textToShare4,textToShareSpace,myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func addButtonClicked(sender: UIButton)
    {
        debugPrint("enddateteime:" + enddatetime)
        debugPrint("startdateteime:" + startdatetime)
        
        let str = startdatetime;
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        let date = dateFormatter.dateFromString(str)
        
        
        debugPrint(date!)
        
  
        
        let str2 = enddatetime;
        let dateFormatter2 = NSDateFormatter()
        dateFormatter2.dateFormat = "MM/dd/yyyy hh:mm a"
        let edate = dateFormatter2.dateFromString(str2)
        

        
        debugPrint(edate)
        
    let eventtitle = clientName! + " - " + thetitle
        
        addEventToCalendar(title: eventtitle, description: thedescription, startDate: date!, endDate: edate!)
    }
    
    
    
    
    func addEventToCalendar(title title: String, description: String?, startDate: NSDate, endDate: NSDate, completion: ((success: Bool, error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccessToEntityType(.Event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.saveEvent(event, span: .ThisEvent)
                } catch let e as NSError {
                    completion?(success: false, error: e)
                    return
                }
                completion?(success: true, error: nil)
            } else {
                completion?(success: false, error: error)
            }
        })
        
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Event Added", message: "This event has been added to your calendar!", preferredStyle: .Alert)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Close", style: .Cancel) { action -> Void in
            //Do some stuff
        }
         actionSheetController.addAction(cancelAction)
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    
    }
    

}