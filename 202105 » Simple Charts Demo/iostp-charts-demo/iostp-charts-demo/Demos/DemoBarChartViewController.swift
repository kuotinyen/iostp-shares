//
//  DemoBarChartViewController.swift
//  iostp-charts-demo
//
//  Created by Ting Yen Kuo on 2021/5/23.
//

import UIKit
import SnapKit
import Charts

class DemoBarChartView: UIView {
    var xAxis: XAxis { chartView.xAxis }

    private let chartView = BarChartView()

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
        chartView.legend.drawInside = false
        chartView.legend.verticalAlignment = .top

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

    func populate(with chartData: BarChartData?, isDisplayTwoGroups: Bool = false) {
        guard let chartData = chartData else {
            chartView.data = nil
            return
        }

        // re-poistion to make chart data point "inside" chart margins
        chartView.xAxis.axisMinimum = chartData.xMin - 0.5
        chartView.xAxis.axisMaximum = chartData.xMax + 0.5

        if isDisplayTwoGroups {
            // render two bar style, remove #groupBars if you just need one bar
            chartData.barWidth = 0.3
            chartData.groupBars(fromX: -0.5, groupSpace: 0.3, barSpace: 0.05)
        } else {
            chartData.barWidth = 0.5
        }

        chartView.data = chartData
    }
}

class DemoBarChartViewController: UIViewController {

    private let confirmCaseModels = HPA.shared.confirmCaseModels
    private let chartView = DemoBarChartView()

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

        let toggleBarDisplayButton = UIButton(frame: .zero)
        toggleBarDisplayButton.backgroundColor = .systemBlue
        toggleBarDisplayButton.titleEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        toggleBarDisplayButton.setTitle("Toggle Bar / Two Bar", for: .normal)
        toggleBarDisplayButton.layer.cornerRadius = 10
        toggleBarDisplayButton.layer.masksToBounds = true
        toggleBarDisplayButton.addTarget(self, action: #selector(handleTapToggleBarButton), for: .touchUpInside)

        view.addSubview(toggleBarDisplayButton)
        toggleBarDisplayButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(toggleBarDisplayButton.intrinsicContentSize.width + 20)
        }

        // setup xAxis string value formatter
        chartView.xAxis.valueFormatter = self

        let confirmCasesEntries = confirmCaseModels.enumerated()
            .map { index, value in BarChartDataEntry(x: Double(index), y: Double(value.number)) }
        let casesSet = makeDataSet(with: confirmCasesEntries, label: "確診數", color: .orange)

        let chartData: BarChartData = .init(dataSets: [casesSet])
        chartView.populate(with: chartData)
    }

    private func makeDataSet(with entries: [BarChartDataEntry], label: String, color: UIColor) -> BarChartDataSet {
        let dataSet: BarChartDataSet = .init(entries: entries, label: label)
        dataSet.drawValuesEnabled = false
        dataSet.colors = [color]
        return dataSet
    }

    // MARK: - Demo toggle bar usage

    var isDisplayTwoGroup: Bool = false

    private var casesSet: BarChartDataSet {
        let entries = confirmCaseModels.enumerated()
            .map { index, value in BarChartDataEntry(x: Double(index), y: Double(value.number)) }
        return makeDataSet(with: entries, label: "確診數", color: .orange)
    }

    private var correctedCasesSet: BarChartDataSet {
        let entries = confirmCaseModels.enumerated()
            .map { index, value in BarChartDataEntry(x: Double(index), y: Double(value.correctNumber)) }
        return makeDataSet(with: entries, label: "校正回歸確診數", color: .blue)
    }

    @objc func handleTapToggleBarButton() {
        isDisplayTwoGroup = !isDisplayTwoGroup

        if isDisplayTwoGroup {
            let chartData: BarChartData = .init(dataSets: [casesSet, correctedCasesSet])
            chartView.populate(with: chartData, isDisplayTwoGroups: isDisplayTwoGroup)
        } else {
            let chartData: BarChartData = .init(dataSets: [casesSet])
            chartView.populate(with: chartData, isDisplayTwoGroups: isDisplayTwoGroup)
        }
    }
}

// MARK: - IAxisValueFormatter

extension DemoBarChartViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        switch axis {
        case chartView.xAxis:
            return confirmCaseModels[Int(value)].dateText
        default:
            return String(describing: value)
        }
    }
}
