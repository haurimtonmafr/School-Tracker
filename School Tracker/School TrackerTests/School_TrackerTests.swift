//
//  School_TrackerTests.swift
//  School TrackerTests
//
//  Created by Haurimton Andres Martin Franco on 4/23/18.
//  Copyright © 2018 Haurimton Andres Martin Franco. All rights reserved.
//

import XCTest
@testable import School_Tracker

class School_TrackerTests: XCTestCase {
    
    var apiServ: ApiServices!
    
    override func setUp() {
        super.setUp()
        
        apiServ = ApiServices()
    }
    
    override func tearDown() {
        apiServ = nil
        
        super.tearDown()
    }
    
    func testBusesGET() {
        let promise = expectation(description: "Status code: 200")
        apiServ.getSchoolBuses(onSuccess: { (schoolBus) in
            if schoolBus.isEmpty {
                XCTFail("\(schoolBus.count) School buses retrieved")
            } else {
                XCTAssert(schoolBus.count > 0, "Successfully retrieved \(schoolBus.count) buses")
                promise.fulfill()
            }
        }, onFailure: { (error) in
            XCTFail(error)
        })

        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testBusStopGET() {
        let promise = expectation(description: "Status code: 200")
        apiServ.getSchoolBusStops(stopsURL: URL(string: "https://api.myjson.com/bins/do6kx")!, onSuccess: { (busStopResponse) in
            if busStopResponse.response == nil {
                XCTFail("RESPONSE NIL")
            } else if busStopResponse.response! {
                promise.fulfill()
            }
        }, onFailure: { (error) in
            XCTFail(error)
        })
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
