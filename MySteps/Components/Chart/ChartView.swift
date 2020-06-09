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
    // Some hack to satisfy design requirements
    // It's hard to position labels for X axis in
    // current library. So I decided to make
    // hard-designed labels
    @IBOutlet weak var daysStackView: UIStackView!
    @IBOutlet var dayLabels: [UILabel]!

    private var stepsReader: IStepsProviderReader?
    private var viewModel: ChartViewModel? {
        didSet {
            updateUI()
        }
    }

    override func initialize(useAutoLayout: Bool = true,
                             bundle: Bundle? = .main) {
        super.initialize(useAutoLayout: useAutoLayout, bundle: bundle)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(synchronizationFinished(notification:)),
                                               name: StepsSynchronizer.SynchronizationFinishedNotification,
                                               object: nil)

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
        daysStackView.backgroundColor = Colors.Background.view
        dayLabels.forEach { label in
            label.backgroundColor = Colors.Background.label
            label.textColor = Colors.Foreground.grey
            label.font = Fonts.graphDates
        }

        stepsTitleLabel.text = "chart_view.steps_title".localized

        // Chart view
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = false
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false
        chartView.gridBackgroundColor = Colors.Background.view
        chartView.drawBordersEnabled = false
        chartView.legend.enabled = false
        chartView.autoScaleMinMaxEnabled = true
        chartView.minOffset = 0
        chartView.extraTopOffset = 20

        // Right axis
        chartView.rightAxis.enabled = true
        chartView.rightAxis.drawLabelsEnabled = true
        chartView.rightAxis.drawGridLinesEnabled = true
        chartView.rightAxis.gridColor = Colors.Foreground.lightGrey
        chartView.rightAxis.gridLineWidth = 1.0
        chartView.rightAxis.axisLineColor = .clear
        chartView.rightAxis.labelFont = Fonts.graphSteps
        chartView.rightAxis.labelTextColor = Colors.Foreground.grey
        chartView.rightAxis.labelPosition = .insideChart
        chartView.rightAxis.setLabelCount(4, force: true)
        chartView.rightAxis.axisMinimum = 0
        chartView.rightAxis.yOffset = -10

        // Left axis
        chartView.leftAxis.enabled = false

        // X axis
        chartView.xAxis.enabled = false
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
        let count = Int(viewModel?.totalSteps ?? 0)
        stepsCountLabel.text = count.localized
        if let startDate = viewModel?.startDate,
            let endDate = viewModel?.endDate {
            datePeriodLabel.text = "\(startDate.localized(withYear: false)) - \(endDate.localized(withYear: true))"
        }

        var dataEntries: [ChartDataEntry] = []
        let keys = viewModel?.stepsPerDay.keys.sorted() ?? [Date]()
        for i in (0..<keys.count) {
            let key = keys[i]
            let value = viewModel?.stepsPerDay[key] ?? 0
            let dataEntry = ChartDataEntry(x: Double(i + 1), y: Double(value))
            dataEntries.append(dataEntry)
        }

        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: nil)
        lineChartDataSet.lineCapType = .round
        lineChartDataSet.mode = .horizontalBezier
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.lineWidth = 3.0
        lineChartDataSet.colors = [Colors.Graph.blue]

        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartData.setDrawValues(false)

        chartView.data = lineChartData
    }

    @objc func synchronizationFinished(notification: NSNotification) {
        loadData()
    }
}
