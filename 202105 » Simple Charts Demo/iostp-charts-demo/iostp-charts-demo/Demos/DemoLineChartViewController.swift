//
//  DemoLineChartViewController.swift
//  iostp-charts-demo
//
//  Created by Ting Yen Kuo on 2021/5/24.
//

import UIKit
import SnapKit
import Charts

class DemoLineChartView: UIView {
    var xAxis: XAxis { chartView.xAxis }

    private let chartView = LineChartView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        addSubview(chartView)
        chartView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        setupChartView()
    }

    func setupChartView() {
        // setup no data UI
        chartView.noDataText = "沒資料"
        chartView.noDataFont = .systemFont(ofSize: 16)
        chartView.noDataTextColor = .gray
        chartView.noDataTextAlignment = .center

        // disable default chart gesture
        chartView.pinchZoomEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.scaleXEnabled = false
        chartView.scaleYEnabled = false
        chartView.dragYEnabled = false
        chartView.dragXEnabled = false

        // disable default legend
        chartView.legend.enabled = true
        chartView.legend.verticalAlignment = .top
        chartView.legend.drawInside = false

        // customize xAxis
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = false

        // Rotate xAxix if you want
//        xAxis.labelRotationAngle = -45

        // customize yAxis
        let leftAxis = chartView.leftAxis
        leftAxis.gridLineWidth = 1
        leftAxis.gridColor = .lightGray
        leftAxis.axisLineColor = .lightGray
        leftAxis.drawZeroLineEnabled = false
        leftAxis.drawAxisLineEnabled = false

        let rightAxis = chartView.rightAxis
        rightAxis.drawGridLinesEnabled = false
        rightAxis.drawAxisLineEnabled = false
        rightAxis.drawLabelsEnabled = false
    }

    func populate(with chartData: LineChartData?) {
        guard let chartData = chartData else {
            chartView.data = nil
            return
        }

        // re-poistion to make chart data point "inside" chart margins
        chartView.xAxis.axisMinimum = chartData.xMin - 0.5
        chartView.xAxis.axisMaximum = chartData.xMax + 0.5

        chartView.data = chartData
    }
}

class DemoLineChartViewController: UIViewController {

    private let confirmCaseModels: [Covid19ConfirmCase] = HPA.shared.confirmCaseModels
    private let chartView = DemoLineChartView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.directionalLayoutMargins = .init(top: 20, leading: .zero, bottom: .zero, trailing: .zero)

        // add chart view
        view.addSubview(chartView)
        chartView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.height.equalTo(200)
        }

        // setup xAxis string value formatter
        chartView.xAxis.valueFormatter = self

        let confirmCasesEntries = confirmCaseModels.enumerated()
            .map { index, value in ChartDataEntry(x: Double(index), y: Double(value.number)) }
        let casesSet = makeDataSet(with: confirmCasesEntries, label: "確診數", color: .orange)

        let correctedConfirmCasesEntries = confirmCaseModels.enumerated()
            .map { index, value in ChartDataEntry(x: Double(index), y: Double(value.correctNumber)) }
        let correctedCasesSet = makeDataSet(with: correctedConfirmCasesEntries, label: "校正回歸確診數", color: .blue)

        let chartData: LineChartData = .init(dataSets: [casesSet, correctedCasesSet])
        chartView.populate(with: chartData)
    }

    private func makeDataSet(with entries: [ChartDataEntry], label: String, color: UIColor) -> LineChartDataSet {
        let dataSet: LineChartDataSet = .init(entries: entries, label: label)
        dataSet.circleRadius = 2.5
        dataSet.lineWidth = 1.5
        dataSet.drawValuesEnabled = false
        dataSet.circleColors = [color]
        dataSet.colors = [color]
        return dataSet
    }
}

// MARK: - IAxisValueFormatter

extension DemoLineChartViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        switch axis {
        case chartView.xAxis:
            return confirmCaseModels[Int(value)].dateText
        default:
            return String(describing: value)
        }
    }
}
