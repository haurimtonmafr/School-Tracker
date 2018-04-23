//
//  SchoolBus.swift
//  School Tracker
//
//  Created by Haurimton Andres Martin Franco on 4/23/18.
//  Copyright © 2018 Haurimton Andres Martin Franco. All rights reserved.
//

import Foundation

/**
 Conform Codable protocol in order to use Codabel JSON Parser
 */
struct SchoolBus: Codable {
    let id: Int?
    let name: String?
    let description: String?
    let stopsURL: URL?
    let imgURL: URL?
    
    /**
     Solve camelcase constants conflict in Swift
     */
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case stopsURL = "stops_url"
        case imgURL = "img_url"
    }
}
