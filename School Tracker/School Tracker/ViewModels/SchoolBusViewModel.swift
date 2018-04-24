//
//  SchoolBusViewModel.swift
//  School Tracker
//
//  Created by Haurimton Andres Martin Franco on 4/23/18.
//  Copyright © 2018 Haurimton Andres Martin Franco. All rights reserved.
//

import Foundation
import Kingfisher

struct SchoolBusViewModel {
    var schoolBuses: [SchoolBus]
    
    func getItemsCount() -> Int {
        return schoolBuses.count
    }
    
    func setupDataInCell(_at row: Int, cell: SchoolBusTableViewCell) {
        let bus = schoolBuses[row]
        cell.busNameLabel.text = bus.name ?? "No Name"
        cell.busDescriptionLabel.text = bus.description ?? "No Description"
        guard let busImgURL = bus.imgURL else { return }
        cell.busIconImageView.kf.setImage(with: busImgURL)
    }
}
