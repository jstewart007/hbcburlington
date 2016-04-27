//
//  ViewController.swift
//  hbcburlington
//
//  Created by John Stewrt on 4/22/16.
//  Copyright © 2016 FaitNetwork, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

 
    @IBOutlet weak var Open: UIBarButtonItem!
    
    @IBOutlet weak var btnWatch: UIButton!
    
    @IBOutlet weak var btnServiceTimes: UIButton!
    
    @IBOutlet weak var btnGive: UIButton!
    
    @IBOutlet weak var btnBible: UIButton!
    
    @IBOutlet weak var btnPhone: UIButton!
    @IBOutlet weak var btnInstagram: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    
    @IBOutlet weak var headerImage: UIImageView!
    
    var routerType: String?
    var routerTitle: String?
    var routerUrl: String?
    
    var navbarColor:UIColor?
    var navbartitleColor:UIColor?
    var navbarbuttonsColor:UIColor?
    var navbarTitleFont:String?
    
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
            navbarTitleFont = plistData["navbarTitleFont"] as! String
            
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
        debugPrint(navbarColor)
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenHeight = screenSize.height
        let screenWidth = screenSize.width
        debugPrint(screenHeight)
        debugPrint(screenWidth)
        
        
        if (screenHeight >= 568 && screenHeight < 1024 )
        {
            headerImage.image = UIImage(named: "header_bg568.png")
            
            btnWatch.setImage(UIImage(named: "nav_watchlive568.png"), forState: UIControlState.Normal)
            btnServiceTimes.setImage(UIImage(named: "nav_servicetimesandlocation568.png"), forState: UIControlState.Normal)
            btnBible.setImage(UIImage(named: "nav_bible568.png"), forState: UIControlState.Normal)
            btnGive.setImage(UIImage(named: "nav_give568.png"), forState: UIControlState.Normal)
            
            btnInstagram.setImage(UIImage(named: "nav_instagram68.png"), forState: UIControlState.Normal)
            btnPhone.setImage(UIImage(named: "nav_phone568.png"), forState: UIControlState.Normal)
            btnFacebook.setImage(UIImage(named: "nav_facebook568.png"), forState: UIControlState.Normal)
            
                   }

        
        Open.target = self.revealViewController()
        Open.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tappedWatch(sender: AnyObject) {
        routerTitle = "Watch Live"
        routerUrl = "http://hbcburlington.faithnetwork.com/livebroadcastappnonav.aspx?parentnavigationid=42731"
        performSegueWithIdentifier("webviewSegue", sender: sender)
    }
    
    @IBAction func tappedServicTime(sender: AnyObject) {
        routerTitle = "Times & Location"
        routerUrl = "http://hbcburlington.faithnetwork.com/contentpagesappnonavnopadding.aspx?viewcontentpageguid=fe2a1d4a-d4b6-4f2c-94d3-402d7ec4f755"
        performSegueWithIdentifier("webviewSegue", sender: sender)
    }
    
    @IBAction func tappedGive(sender: AnyObject) {
        routerTitle = "Give"
        routerUrl = "http://hbcburlington.faithnetwork.com/contentpagesappnonavnopadding.aspx?viewcontentpageguid=f6340c58-4982-421b-bd98-fa783e3257d4"
        performSegueWithIdentifier("webviewexternalSegue", sender: sender)
    }
    
    @IBAction func tappedBible(sender: AnyObject) {
        routerTitle = "Bible"
        routerUrl = "http://hbcburlington.faithnetwork.com/contentpagesappnonavnopadding.aspx?viewcontentpageguid=76c6e869-49d6-4491-a783-51036167941c"
        performSegueWithIdentifier("webviewSegue", sender: sender)
    }
    
    @IBAction func tappedFacebook(sender: AnyObject) {
        routerTitle = "Facebook"
        routerUrl = "https://www.facebook.com/pages/Harvest-Baptist-Church/22276239742"
        performSegueWithIdentifier("webviewSegue", sender: sender)
    }
    
    @IBAction func tappedInstagram(sender: AnyObject) {
        routerTitle = "Instagram"
        routerUrl = "https://www.instagram.com/hbcburlington/"
        performSegueWithIdentifier("webviewSegue", sender: sender)
    }
    
    @IBAction func tappedPhone(sender: AnyObject) {
        routerTitle = "Contact Us"
        routerUrl = "http://hbcburlington.faithnetwork.com/contentpagesappnonavnopadding.aspx?viewcontentpageguid=c73b6197-f172-4017-907a-e537d07adc5c"
        performSegueWithIdentifier("webviewSegue", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "webviewSegue" {
            
            if let routerViewController = segue.destinationViewController as? WebviewViewController {
                routerViewController.routerTitle = routerTitle!
                routerViewController.routerUrl = routerUrl!
                debugPrint(routerUrl)
            }
        } else if segue.identifier == "webviewexternalSegue" {
            
            if let router2ViewController = segue.destinationViewController as? WebviewExternalViewController {
                router2ViewController.routerTitle = routerTitle!
                router2ViewController.routerUrl = routerUrl!
                debugPrint(routerUrl)
            }
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        //self.navigationController?.navigationBarHidden = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true

    }
    
    
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.barTintColor = navbarColor
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.tintColor = navbarbuttonsColor
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: navbartitleColor!]
        self.navigationController!.navigationBar.titleTextAttributes = (titleDict as! [String : AnyObject])
        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: navbarTitleFont!, size: 20)!]
    }

}

