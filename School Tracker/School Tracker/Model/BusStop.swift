//
//  BusStop.swift
//  School Tracker
//
//  Created by Haurimton Andres Martin Franco on 4/23/18.
//  Copyright © 2018 Haurimton Andres Martin Franco. All rights reserved.
//

import Foundation

/**
 Conform Codable protocol in order to use Codabel JSON Parser
 */
struct BusStop: Codable {
    let lat: Double?
    let long: Double?
    
    /**
     Solve camelcase constants conflict in Swift
     */
    private enum CodingKeys: String, CodingKey {
        case lat
        case long = "lng"
    }
}
