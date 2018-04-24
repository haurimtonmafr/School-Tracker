//
//  ViewController.swift
//  School Tracker
//
//  Created by Haurimton Andres Martin Franco on 4/23/18.
//  Copyright © 2018 Haurimton Andres Martin Franco. All rights reserved.
//

import UIKit
import Lottie

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
    
    /**
     Play loading animation while data is being retrieved
     */
    func playAnimation() {
        /**
         Set a timer so the user knows there was a loading proccess
         */
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(animationView.animationDuration), target: self, selector: #selector(LoadingViewController.loadingTimeDone), userInfo: nil, repeats: false)
        
        animationView.play()
    }
    
    /**
     When timer is fired chek if school bus view model isn't nil and perform segue to buses view controller
     */
    @objc func loadingTimeDone() {
        timerDone = true
        if schoolBusViewModel != nil {
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
                self.performSegue(withIdentifier: "SegueToBusesVC", sender: self)
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
        
        timer.invalidate()
        timer = nil
        schoolBusViewModel = nil
    }

}

