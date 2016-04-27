//
//  AlertViewController.swift
//  arcentral
//
//  Created by John Stewrt on 4/21/16.
//  Copyright © 2016 FaitNetwork, Inc. All rights reserved.
//

import UIKit

class AlertViewController:  UIViewController, UIWebViewDelegate{
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var alertGuid:String = String()
    var navbarColor:UIColor?
    var webviewBackgroundOpaque = true
    var webviewBackgroundColor:UIColor?
    var baseUrl: String?
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
            appGuid = plistData["appGuid"] as? String
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
        let webViewUrl = baseUrl! + "/alertDetailsappnonav.aspx?appguid=" + appGuid! +  "&viewalertguid=" + alertGuid
        debugPrint(webViewUrl)
        
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
    
    
    
    
    
}