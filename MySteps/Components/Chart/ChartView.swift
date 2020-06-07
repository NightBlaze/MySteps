//
//  ChartView.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 07.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import UIKit

protocol IChartView: UIView {
    func resolveDependencies(stepsReader: IStepsProviderReader)
}

final class ChartView: BaseNibView {
    @IBOutlet weak var stepsTitleLabel: UILabel!
    @IBOutlet weak var stepsCountLabel: UILabel!
    @IBOutlet weak var datePeriodLabel: UILabel!

    private var stepsReader: IStepsProviderReader?
    private var viewModel: ChartViewModel? {
        didSet {
            updateUI()
        }
    }

    var startDate = Date().startOfMonth
    var endDate = Date().endOfMonth

    override func initialize(useAutoLayout: Bool = true,
                             bundle: Bundle? = .main) {
        super.initialize(useAutoLayout: useAutoLayout, bundle: bundle)

        // TODO: localize
        stepsTitleLabel.text = "Steps"
        datePeriodLabel.text = "\(startDate) - \(endDate)"
    }
}

// MARK: - IChartView

extension ChartView: IChartView {
    func resolveDependencies(stepsReader: IStepsProviderReader) {
        self.stepsReader = stepsReader

        loadData()
    }
}

// MARK: - Private

private extension ChartView {
    func loadData() {
        stepsReader?.steps(startDate: startDate, endDate: endDate) { [weak self] result in
            guard let self = self,
                case .success(let steps) = result else { return }

            self.viewModel = ChartViewModel(daos: steps)
        }
    }

    func updateUI() {
        // TODO: localize
        stepsCountLabel.text = "\(viewModel?.totalSteps ?? 0)"
    }
}
