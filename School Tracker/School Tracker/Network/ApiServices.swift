//
//  ApiServices.swift
//  School Tracker
//
//  Created by Haurimton Andres Martin Franco on 4/23/18.
//  Copyright © 2018 Haurimton Andres Martin Franco. All rights reserved.
//

import Foundation

/**
 This class will handle all the API services
 */
class ApiServices {
    
    /**
     GET school buses function that returns an array of SchoolBuses
     */
    public func getSchoolBuses(onSuccess success: @escaping (_ buses: [SchoolBus]) -> Void, onFailure failure: @escaping (_ error: String) -> Void) {
        guard let schoolBusesURL = URL(string: "https://api.myjson.com/bins/10yg1t") else {
            failure("Cannot convert urlString to URL")
            return
        }
        
        URLSession.shared.dataTask(with: schoolBusesURL) { (data, response, error) in
            guard let data = data else {
                failure("Data is nil")
                return
            }
            do {
                /**
                 Create decoder
                 */
                let decoder = JSONDecoder()
                /**
                 Decode data to objects of type SchoolBusResponse
                 */
                let schoolBusData = try decoder.decode(SchoolBusResponse.self, from: data)
                guard let responseSchoolBus = schoolBusData.response, let buses = schoolBusData.schoolBuses else {
                    failure("SchoolBus data properties are nil (\"\(String(describing: schoolBusData.response))\", \"\(String(describing: schoolBusData.schoolBuses))\")")
                    return
                }
                if responseSchoolBus {
                    success(buses)
                } else {
                    failure("SchoolBuses service response was \(responseSchoolBus)")
                }
            } catch let err {
                failure(err.localizedDescription)
            }
            
        }.resume()
    }
    
    /**
     GET bus stops function that returns an array of BusStops for received busStops URL
     */
    public func getSchoolBusStops(stopsURL: URL, onSuccess success: @escaping (_ stops: [BusStop]) -> Void, onFailure failure: @escaping (_ error: String) -> Void) {
        
        URLSession.shared.dataTask(with: stopsURL) { (data, response, error) in
            guard let data = data else {
                failure("Data is nil")
                return
            }
            do {
                /**
                 Create decoder
                 */
                let decoder = JSONDecoder()
                /**
                 Decode data to objects of type BusStopResponse
                 */
                let stopsData = try decoder.decode(BusStopResponse.self, from: data)
                guard let responseStops = stopsData.response, let stops = stopsData.busStops else {
                    failure("SchoolBus data properties are nil (\"\(String(describing: stopsData.response))\", \"\(String(describing: stopsData.busStops))\")")
                    return
                }
                if responseStops {
                    success(stops)
                } else {
                    failure("BusStops service response was \(responseStops)")
                }
            } catch let err {
                failure(err.localizedDescription)
            }
        }.resume()
    }
    
}
