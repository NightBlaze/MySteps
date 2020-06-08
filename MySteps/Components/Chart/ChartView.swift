//
//  ChartView.swift
//  MySteps
//
//  Created by Alexander Timonenkov on 07.06.2020.
//  Copyright © 2020 ATi Soft. All rights reserved.
//

import UIKit
import Charts

protocol IChartView: UIView {
    func resolveDependencies(stepsReader: IStepsProviderReader)
}

final class ChartView: BaseNibView {
    @IBOutlet weak var stepsTitleLabel: UILabel!
    @IBOutlet weak var stepsCountLabel: UILabel!
    @IBOutlet weak var datePeriodLabel: UILabel!
    @IBOutlet weak var chartView: LineChartView!
    
    private var stepsReader: IStepsProviderReader?
    private var viewModel: ChartViewModel? {
        didSet {
            updateUI()
        }
    }

    override func initialize(useAutoLayout: Bool = true,
                             bundle: Bundle? = .main) {
        super.initialize(useAutoLayout: useAutoLayout, bundle: bundle)

        backgroundColor = Colors.Background.view
        stepsTitleLabel.textColor = Colors.Foreground.white
        stepsTitleLabel.backgroundColor = Colors.Background.label
        stepsCountLabel.textColor = Colors.Foreground.green
        stepsCountLabel.backgroundColor = Colors.Background.label
        datePeriodLabel.textColor = Colors.Foreground.grey
        datePeriodLabel.backgroundColor = Colors.Background.label
        chartView.backgroundColor = Colors.Background.view
        stepsTitleLabel.font = Fonts.stepsTitle
        stepsCountLabel.font = Fonts.stepsCount
        datePeriodLabel.font = Fonts.period

        // TODO: localize
        stepsTitleLabel.text = "Steps"

        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = false
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false

        let formatter = ChartFormatter()
        let xAxis = XAxis()
        xAxis.valueFormatter = formatter

        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.valueFormatter = xAxis.valueFormatter
        chartView.chartDescription?.enabled = false
        chartView.legend.enabled = false
        chartView.rightAxis.enabled = true
        chartView.rightAxis.drawLabelsEnabled = true
        chartView.rightAxis.drawGridLinesEnabled = true
        chartView.leftAxis.enabled = false
        chartView.leftAxis.drawLabelsEnabled = false
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
        stepsReader?.stepsForLastMonth() { [weak self] result in
            guard let self = self,
                case .success(let stepsResult) = result else { return }

            self.viewModel = ChartViewModel(startDate: stepsResult.startDate,
                                            endDate: stepsResult.endDate,
                                            daos: stepsResult.steps)
        }
    }

    func updateUI() {
        // TODO: localize
        stepsCountLabel.text = "\(viewModel?.totalSteps ?? 0)"
//        datePeriodLabel.text = "\(viewModel?.startDate) - \(viewModel?.endDate)"

        var dataEntries: [ChartDataEntry] = []
        let keys = viewModel?.stepsPerDay.keys.sorted() ?? [Date]()
        for i in (0..<keys.count) {
            let key = keys[i]
            let value = viewModel?.stepsPerDay[key] ?? 0
            let dataEntry = ChartDataEntry(x: Double(i + 1), y: Double(value))
            dataEntries.append(dataEntry)
        }

        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: nil)
        lineChartDataSet.circleRadius = 0
        lineChartDataSet.lineCapType = .round
        lineChartDataSet.mode = .horizontalBezier
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartData.setDrawValues(false)

        chartView.data = lineChartData
    }
}
