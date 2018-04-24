//
//  NoConnectionViewController.swift
//  School Tracker
//
//  Created by Haurimton Andres Martin Franco on 4/24/18.
//  Copyright © 2018 Haurimton Andres Martin Franco. All rights reserved.
//

import UIKit
import Lottie

class NoConnectionViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var animationView: LOTAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationView.play()
        animationView.loopAnimation = true
    }
    
}
