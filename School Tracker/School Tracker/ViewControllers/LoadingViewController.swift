//
//  ViewController.swift
//  School Tracker
//
//  Created by Haurimton Andres Martin Franco on 4/23/18.
//  Copyright © 2018 Haurimton Andres Martin Franco. All rights reserved.
//

import UIKit
import Lottie
import ReachabilitySwift

class LoadingViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var animationView: LOTAnimationView!
    
    // MARK: - Properties
    var schoolBusViewModel: SchoolBusViewModel!
    var timer: Timer!
    var timerDone: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playAnimation()
        loadBuses()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkReachability.shared.addListener(listener: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NetworkReachability.shared.removeListener(listener: self)
    }
    
    /**
     Play loading animation while data is being retrieved
     */
    func playAnimation() {
        /**
         Set a timer so the user knows there was a loading proccess
         */
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(3.0), target: self, selector: #selector(LoadingViewController.loadingTimeDone), userInfo: nil, repeats: false)
        
        animationView.play()
    }
    
    /**
     When timer is fired chek if school bus view model isn't nil and perform segue to buses view controller
     */
    @objc func loadingTimeDone() {
        timerDone = true
        if schoolBusViewModel != nil {
            animationView.stop()
            self.performSegue(withIdentifier: "SegueToBusesVC", sender: self)
        }
    }
    
    /**
     Load buses data from API and perform segue if response comes after timer has been fired
     */
    func loadBuses() {
        let apiServ = ApiServices()
        apiServ.getSchoolBuses(onSuccess: { (buses) in
            self.schoolBusViewModel = SchoolBusViewModel(schoolBuses: buses)
            if self.timerDone {
                DispatchQueue.main.async {
                    self.animationView.stop()
                }
                if self.presentedViewController == nil {
                    self.performSegue(withIdentifier: "SegueToBusesVC", sender: self)
                } else {
                    self.presentedViewController?.dismiss(animated: true, completion: {
                        self.performSegue(withIdentifier: "SegueToBusesVC", sender: self)
                    })
                }
            }
        }, onFailure: { (error) in
                print(error)
            }
        )
    }
    
    /**
     Send school bus view model to buses view controller
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let busesNavVC = segue.destination as? UINavigationController else { return }
        guard let busesVC = busesNavVC.viewControllers.first as? BusesViewController else { return }
        
        busesVC.schoolBusViewModel = schoolBusViewModel
        
        timer?.invalidate()
        timer = nil
        schoolBusViewModel = nil
    }

    func connectionError() {
        let noConnectionVC = NoConnectionViewController()
        noConnectionVC.modalPresentationStyle = .overFullScreen
        
        DispatchQueue.main.async {
            self.present(noConnectionVC, animated: true, completion: nil)
        }
    }
    
}

extension LoadingViewController: NetworkStatusListener {
    func networkStatusDidChange(status: Reachability.NetworkStatus) {
        switch status {
        case .reachableViaWiFi, .reachableViaWWAN:
            loadBuses()
        case .notReachable:
            self.connectionError()
        }
    }
}

