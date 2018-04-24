//
//  BusesViewController.swift
//  School Tracker
//
//  Created by Haurimton Andres Martin Franco on 4/23/18.
//  Copyright © 2018 Haurimton Andres Martin Franco. All rights reserved.
//

import UIKit

class BusesViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var busesTableView: UITableView!
    
    // MARK: - Properties
    var schoolBusViewModel: SchoolBusViewModel! {
        didSet {
            fillUI()
        }
    }
    var selectedBusID: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func fillUI() {
        busesTableView?.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let busStopsVC = segue.destination as? BusStopsViewController, let selectedBusID = selectedBusID else { return }
        
        busStopsVC.schoolBus = schoolBusViewModel.schoolBuses.first(where: { $0.id == selectedBusID })
    }

}

/**
 Conform UITableViewDataSource protocol
 */
extension BusesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schoolBusViewModel?.getItemsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SchoolBusCell", for: indexPath) as! SchoolBusTableViewCell
        schoolBusViewModel.setupDataInCell(_at: indexPath.row, cell: cell)
        
        return cell
    }
    
}

/**
 Conform UITableViewDelegate protocol
 */
extension BusesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        selectedBusID = schoolBusViewModel.schoolBuses[indexPath.row].id
        self.performSegue(withIdentifier: "SegueToBusStopsVC", sender: self)
        
    }
    
}
