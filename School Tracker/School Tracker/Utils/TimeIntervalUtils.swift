//
//  TimeIntervalUtils.swift
//  School Tracker
//
//  Created by Haurimton Andres Martin Franco on 4/24/18.
//  Copyright © 2018 Haurimton Andres Martin Franco. All rights reserved.
//

import Foundation

extension TimeInterval {
    func timeString() -> String {
        var str: String = ""
        let hours = Int(self / 3600)
        
        let minutes = Int(self.truncatingRemainder(dividingBy: 3600) / 60)
        
        if (hours > 0) {
            str.append("\(hours) hr ")
        }
        
        if (minutes > 0) {
            str.append("\(minutes) min")
        }
        
        return str
    }
}
