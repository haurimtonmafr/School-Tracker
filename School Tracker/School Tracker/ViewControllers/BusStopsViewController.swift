//
//  BusStopsViewController.swift
//  School Tracker
//
//  Created by Haurimton Andres Martin Franco on 4/23/18.
//  Copyright © 2018 Haurimton Andres Martin Franco. All rights reserved.
//

import UIKit

class BusStopsViewController: UIViewController {
    
    // MARK: - Properties
    var schoolBus: SchoolBus!
    
    deinit {
        print("BusStopsVC deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = schoolBus.name
    }

}
