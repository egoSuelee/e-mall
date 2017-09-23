//
//  RegStr.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 21/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit

extension String {

    
    func isMatch(patternString:String) -> Bool {
        do {
            let regex: NSRegularExpression = try NSRegularExpression(pattern: patternString, options: NSRegularExpression.Options.caseInsensitive)
            let matches = regex.matches(in: self, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, self.characters.count))
            if matches.count > 0 {
               return true
            } else {
               return false
            }
        }
        catch {
            return false
        }
        
    }
  
}
