//
//  WebviewExternalViewController.swift
//  hbcburlington
//
//  Created by John Stewrt on 4/26/16.
//  Copyright © 2016 FaitNetwork, Inc. All rights reserved.
//

import UIKit

class WebviewExternalViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    
    
    var routerTitle:String!
    var routerUrl:String!
    var theUrl:String!
    
    
    var baseUrl:String?
    
    var navbarColor:UIColor?
    var navbartitleColor:UIColor?
    var navbarbuttonsColor:UIColor?
    
    
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
            
            //set navbar bg from plist
            var red = plistData["navbarRed"] as! CGFloat
            var green = plistData["navbarGreen"] as! CGFloat
            var blue = plistData["navbarBlue"] as! CGFloat
            
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readPropertyList()
        self.title = routerTitle
        
        // Do any additional setup after loading the view, typically from a nib.
        activity.hidesWhenStopped = true
        
        if (routerUrl!.containsString("https://") || routerUrl!.containsString("http://"))
        {
            theUrl = routerUrl
        }
        else
        {
            theUrl = baseUrl! + routerUrl
        }
        
        webView.loadRequest(NSURLRequest(URL: NSURL(string:theUrl)!))
        
        self.navigationController?.navigationBar.barTintColor = navbarColor
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.tintColor = navbarbuttonsColor
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: navbartitleColor!]
        self.navigationController!.navigationBar.titleTextAttributes = (titleDict as! [String : AnyObject])
        
        let menu_button = UIBarButtonItem(image: UIImage(named: "icon-refresh"),
            style: UIBarButtonItemStyle.Plain ,
            target: self, action: "OnMenuClicked:")
        self.navigationItem.rightBarButtonItem = menu_button
        
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        switch navigationType {
        case .LinkClicked:
            // Open links in Safari
            UIApplication.sharedApplication().openURL(request.URL!)
            return false
        default:
            // Handle other navigation types...
            return true
        }
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
    
    @IBAction func OnMenuClicked(sender: UIButton)
    {
        debugPrint("clicked")
        webView.loadRequest(NSURLRequest(URL: NSURL(string:theUrl)!))
    }
    
    
    
}