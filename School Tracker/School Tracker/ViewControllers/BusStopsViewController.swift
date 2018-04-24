//
//  BusStopsViewController.swift
//  School Tracker
//
//  Created by Haurimton Andres Martin Franco on 4/23/18.
//  Copyright © 2018 Haurimton Andres Martin Franco. All rights reserved.
//

import UIKit
import GoogleMaps
import Lottie
import ReachabilitySwift

class BusStopsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingAnimationView: LOTAnimationView!
    
    // MARK: - Properties
    var reachableTime: Date!
    var notReachableTime: Date!
    var schoolBus: SchoolBus!
    var apiServices: ApiServices!
    var busStopResponse: BusStopResponse!
    var retryTimer: Timer!
    var loadingTimer: Timer!
    var animationTimerDone: Bool = false
    var mapCamera: GMSCameraPosition!
    var stopsMarkers: [GMSMarker] = Array<GMSMarker>()
    var stopsPath: GMSMutablePath = GMSMutablePath()
    
    deinit {
        mapCamera = nil
        stopsMarkers.removeAll()
        stopsPath.removeAllCoordinates()
        retryTimer?.invalidate()
        retryTimer = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupMap()
        getStops()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkReachability.shared.addListener(listener: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NetworkReachability.shared.removeListener(listener: self)
    }
    
    func cleanupUI() {
        busStopResponse = nil
        stopsMarkers.removeAll()
        stopsPath.removeAllCoordinates()
        mapView.clear()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = schoolBus.name
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshStops))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        loadingAnimationView.play()
        loadingAnimationView.loopAnimation = loadingAnimationView.animationDuration < 3
        loadingTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.loadingTimerDone), userInfo: nil, repeats: false)
    }
    
    @objc func refreshStops() {
        showLoadingView()
        cleanupUI()
        getStops()
    }
    
    func showLoadingView() {
        loadingTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.loadingTimerDone), userInfo: nil, repeats: false)
        loadingAnimationView.play()
        self.loadingView.isHidden = false
    }
    
    func hideLoadingView() {
        self.loadingView.isHidden = true
        loadingAnimationView.stop()
        loadingTimer?.invalidate()
    }
    
    func getStops() {
        guard let stopsURL = schoolBus.stopsURL else { return }
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        apiServices = ApiServices()
        apiServices.getSchoolBusStops(stopsURL: stopsURL, onSuccess: { (response) in
            self.busStopResponse = response
            guard let retryTime = self.busStopResponse.retryTime else { return }
            DispatchQueue.main.async {
                self.retryTimer = Timer.scheduledTimer(timeInterval: (retryTime/1000), target: self, selector: #selector(self.retryTimerDone), userInfo: nil, repeats: false)
                if self.animationTimerDone {
                    self.hideLoadingView()
                    self.addStops()
                }
            }
        }, onFailure: { (error) in
            print(error)
            self.connectionError()
        })
    }
    
    @objc func retryTimerDone() {
        DispatchQueue.main.async {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        retryTimer?.invalidate()
        retryTimer = nil
    }
    
    @objc func loadingTimerDone() {
        if busStopResponse == nil {
            animationTimerDone = true
        } else {
            DispatchQueue.main.async {
                self.hideLoadingView()
                self.addStops()
            }
        }
    }
    
    /**
     Setup map camera and view
     */
    func setupMap() {
        mapCamera = GMSCameraPosition.camera(withLatitude: 4.624335, longitude: -74.063644, zoom: 15.0)
        mapView.camera = mapCamera
    }
    
    func addMarker(point: CLLocationCoordinate2D) {
        let marker = GMSMarker()
        marker.position = point
        marker.map = mapView
        stopsMarkers.append(marker)
        stopsPath.add(point)
    }
    
    func addStops() {
        guard let stops = busStopResponse.busStops else { return }
        stops.forEach({
            guard let lat = $0.lat, let long = $0.long else { return }
            let point = CLLocationCoordinate2D(latitude: lat, longitude: long)
            /**
             Check if point is on the path with a tolerance of 20km to discard corrupted data
             */
            if stopsPath.count() == 0 {
                addMarker(point: point)
            } else if GMSGeometryIsLocationOnPathTolerance(point, stopsPath, false, 20000.0) {
                addMarker(point: point)
            }
        })
        
        /**
         Set a diferent marker icon color for start, stops, finish line and include estimated time as marker title
         */
        stopsMarkers.forEach({
            if $0 == stopsMarkers.first {
                $0.icon = GMSMarker.markerImage(with: UIColor(red: (115/255), green: (250/255), blue: (121/255), alpha: 1.0))
            } else if $0 == stopsMarkers.last {
                guard let estimatedTimeMiliseconds = busStopResponse.estimatedTime else { return }
                $0.title = "\((TimeInterval(estimatedTimeMiliseconds/1000) * TimeInterval(stopsMarkers.count-1)).timeString())"
            } else {
                $0.icon = GMSMarker.markerImage(with: UIColor(red: (118/255), green: (214/255), blue: 1.0, alpha: 1.0))
                guard let estimatedTimeMiliseconds = busStopResponse.estimatedTime else { return }
                $0.title = "\((TimeInterval(estimatedTimeMiliseconds/1000) * TimeInterval(stopsMarkers[1...stopsMarkers.index(of: $0)!].count)).timeString())"
            }
        })
        
        mapView.selectedMarker = stopsMarkers.last
        
        /**
         Connect the path with a red line
         */
        let polyline = GMSPolyline(path: stopsPath)
        polyline.map = mapView
        polyline.strokeColor = UIColor.red
        polyline.strokeWidth = 3.0
        let update = GMSCameraUpdate.fit(GMSCoordinateBounds(path: stopsPath))
        mapView.animate(with: update)
    }
    
    func connectionError() {
        let noConnectionVC = NoConnectionViewController()
        noConnectionVC.modalPresentationStyle = .overFullScreen
        
        var presentNoConnectionVC: Bool = false
        if let notReachableTimep = notReachableTime {
            let timeSinceLastUpdate = Calendar.current.dateComponents([.second, .minute], from: notReachableTimep, to: Date())
            if (timeSinceLastUpdate.minute! > 0) || (timeSinceLastUpdate.second! > 0) {
                presentNoConnectionVC = true
            }
        } else {
            presentNoConnectionVC = true
        }
        
        if presentNoConnectionVC {
            notReachableTime = Date()
            DispatchQueue.main.async {
                self.present(noConnectionVC, animated: true, completion: nil)
            }
        }
    }

}

extension BusStopsViewController: NetworkStatusListener {
    func networkStatusDidChange(status: Reachability.NetworkStatus) {
        switch status {
        case .reachableViaWiFi, .reachableViaWWAN:
            self.presentedViewController?.dismiss(animated: true, completion: {
                self.refreshStops()
            })
        case .notReachable:
            self.connectionError()
        }
    }
}
