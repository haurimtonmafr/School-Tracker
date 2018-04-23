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

/**
 Create model for BusStopResponse and conform Codable protocol in order to use Codabel JSON Parser
 */
struct BusStopResponse: Codable {
    let response: Bool?
    let busStops: [BusStop]?
    let estimatedTime: Double?
    let retryTime: Double?
    
    /**
     Solve camelcase constants conflict in Swift
     */
    private enum CodingKeys: String, CodingKey {
        case response
        case busStops = "stops"
        case estimatedTime = "estimated_time_milliseconds"
        case retryTime = "retry_time_milliseconds"
    }
}
