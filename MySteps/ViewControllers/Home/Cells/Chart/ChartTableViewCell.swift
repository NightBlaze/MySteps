//
//  ChartTableViewCell.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 06.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import UIKit

class ChartTableViewCell: UITableViewCell {
    static let height: CGFloat = 206

    @IBOutlet weak var chartView: ChartView!

    func resolveDependencies(stepsReader: IStepsProviderReader) {
        chartView.resolveDependencies(stepsReader: stepsReader)
    }
}
