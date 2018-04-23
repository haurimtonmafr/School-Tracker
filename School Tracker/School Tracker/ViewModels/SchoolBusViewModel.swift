//
//  SchoolBusViewModel.swift
//  School Tracker
//
//  Created by Haurimton Andres Martin Franco on 4/23/18.
//  Copyright © 2018 Haurimton Andres Martin Franco. All rights reserved.
//

import Foundation

struct SchoolBusViewModel {
    var schoolBuses: [SchoolBus]
    
    func getItemsCount() -> Int {
        return schoolBuses.count
    }
}
