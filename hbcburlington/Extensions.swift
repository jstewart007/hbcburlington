//
//  Extensions.swift
//  arcentral
//
//  Created by John Stewrt on 4/21/16.
//  Copyright © 2016 FaitNetwork, Inc. All rights reserved.
//

import Foundation
import UIKit

extension String {
    /// Truncates the string to length number of characters and
    /// appends optional trailing string if longer
    func truncate(length: Int, trailing: String = "…") -> String {
        if self.characters.count > length {
            return self.substringToIndex(self.startIndex.advancedBy(length)) + trailing
        } else {
            return self
        }
    }
    
}

extension UIAlertController {
    
    public override func shouldAutorotate() -> Bool {
        return true
    }
    
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }
}
