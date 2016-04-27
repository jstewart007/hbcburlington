//
//  EpisodeViewController.swift
//  rethink
//
//  Created by John Stewrt on 4/19/16.
//  Copyright © 2016 FaitNetwork, Inc. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class EpisodeViewController: UIViewController {

     var image:String = String()
     var author:String = String()
     var thetitle:String = String()
     var thedescription:String = String()
     var videoUrl:String = String()
     var audioUrl:String = String()
    var thedate:String = String()
    var messageTitle:String = String()
    
    
    @IBOutlet weak var lblMessageTitle: UILabel!
    
    
    @IBOutlet weak var lblEpisodeTitle: UILabel!
    
    
    @IBOutlet weak var lblAuthor: UILabel!
    
    @IBOutlet weak var btnWatch: UIButton!
    
    
    @IBOutlet weak var btnListen: UIButton!
    
    @IBOutlet weak var imageMessage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = thetitle;
        
        
        let ImageUrl = NSURL(string: image)
        if let episodeurl = ImageUrl {
            imageMessage.sd_setImageWithURL(episodeurl)
        }
        
        lblMessageTitle.text = messageTitle
        lblEpisodeTitle.text = thetitle

        if author != ""  {
            lblAuthor.text = author + ", " + thedate
        } else
        {
            lblAuthor.text = thedate
        }
        
        if (videoUrl.isEmpty)
        {
        btnWatch.hidden = true
        }
        
        if (audioUrl.isEmpty)
        {
            btnListen.hidden = true
        }

        
        
        // Do any additional setup after loading the view.
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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue,
        sender: AnyObject?) {
            
            if segue.identifier == "watchSegue" {
    
                let url = NSURL(string:videoUrl)
                let destination = segue.destinationViewController as! AVPlayerViewController
                destination.player = AVPlayer(URL: url!)
            } else
            {
               let url = NSURL(string:audioUrl)
                let destination = segue.destinationViewController as! AVPlayerViewController
                destination.player = AVPlayer(URL: url!)
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
