//
//  DemoLineChartViewController.swift
//  iostp-charts-demo
//
//  Created by Ting Yen Kuo on 2021/5/22.
//

import UIKit
import SnapKit
import Charts

class DemoConfirmCaseMarkerView: MarkerView {
    private let dateLabel = UILabel()
    private let numberLabel = UILabel()
    private let correctNumberLabel = UILabel()

    private var confirmCases: [Covid19ConfirmCase]?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func populate(with confirmCase: Covid19ConfirmCase) {
        dateLabel.text = confirmCase.dateText
        numberLabel.text = "確診數：\(confirmCase.number)"
        correctNumberLabel.text = "校正回歸確診數：\(confirmCase.correctNumber)"
    }

    func populateInvalidData() {
        [dateLabel, numberLabel, correctNumberLabel].forEach {
            $0.text = "n/a"
        }
    }

    func populate(with confirmCases: [Covid19ConfirmCase]) {
        self.confirmCases = confirmCases
    }

    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        let xIndex = Int(entry.x)
        guard let confirmCases = self.confirmCases,
              xIndex < confirmCases.count
        else {
            populateInvalidData()
            return
        }

        populate(with: confirmCases[xIndex])
        refreshFrameSize()
    }

    func refreshFrameSize() {
        // Workaround for Charts marker SDK in autolayout
        self.frame = CGRect(origin: frame.origin,
                            size: systemLayoutSizeFitting(UIScreen.main.bounds.size))
        setNeedsLayout()
        layoutIfNeeded()
    }

    override func draw(context: CGContext, point: CGPoint) {
        super.draw(context: context, point: .init(x: point.x, y: 0))
    }

    private func commonInit() {
        backgroundColor = .darkGray

        let labels = [dateLabel, numberLabel, correctNumberLabel]
        labels.forEach {
            $0.textColor = .white
            $0.font = .systemFont(ofSize: 12)
        }

        let stackView = UIStackView(arrangedSubviews: labels)
        stackView.axis = .vertical
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.layoutMarginsGuide)
        }
    }
}

class DemoLineChartAndMarkerView: UIView {
    var xAxis: XAxis { chartView.xAxis }
    var isLongPressDraggingLegend: Bool = false

    private let chartView = LineChartView()
    weak var markerView: DemoConfirmCaseMarkerView?

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
        setupMarkerView()
    }

    private func setupMarkerView() {
        let markerView = DemoConfirmCaseMarkerView(frame: .zero)
        markerView.chartView = chartView
        chartView.marker = markerView
        self.markerView = markerView
    }

    func setupChartView() {
        // MARK: Longpress Hightlight

        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressRecognizer.minimumPressDuration = 0.2
        chartView.addGestureRecognizer(longPressRecognizer)
        chartView.gestureRecognizers?.compactMap({ $0 }).forEach { $0.delegate = self }

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

    func populate(with confirmCases: [Covid19ConfirmCase]) {
        let confirmCasesEntries = confirmCases.enumerated()
            .map { index, value in ChartDataEntry(x: Double(index), y: Double(value.number)) }
        let casesSet = makeDataSet(with: confirmCasesEntries, label: "確診數", color: .orange)

        let correctedConfirmCasesEntries = confirmCases.enumerated()
            .map { index, value in ChartDataEntry(x: Double(index), y: Double(value.correctNumber)) }
        let correctedCasesSet = makeDataSet(with: correctedConfirmCasesEntries, label: "校正回歸確診數", color: .blue)

        // populate chartView and markerView
        markerView?.populate(with: confirmCases)
        let chartData: LineChartData = .init(dataSets: [casesSet, correctedCasesSet])
        populate(with: chartData)
    }

    private func populate(with chartData: LineChartData?) {
        guard let chartData = chartData else {
            chartView.data = nil
            return
        }

        // re-poistion to make chart data point "inside" chart margins
        chartView.xAxis.axisMinimum = chartData.xMin - 0.5
        chartView.xAxis.axisMaximum = chartData.xMax + 0.5

        chartView.data = chartData
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

extension DemoLineChartAndMarkerView: UIGestureRecognizerDelegate {

    // MARK: Hightlight marker

    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began, .changed:
            isLongPressDraggingLegend = true
            let point = gesture.location(in: chartView)
            let highlight = chartView.getHighlightByTouchPoint(point)
            chartView.highlightValue(highlight)
        case .ended:
            isLongPressDraggingLegend = false
            chartView.highlightValue(nil)
        default: break
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return !isLongPressDraggingLegend
    }
}

class DemoLineChartAndMarkerViewController: UIViewController {
    
    private let confirmCaseModels = HPA.shared.confirmCaseModels
    private let chartView = DemoLineChartAndMarkerView()

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

        chartView.populate(with: confirmCaseModels)
    }
}

// MARK: - IAxisValueFormatter

extension DemoLineChartAndMarkerViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        switch axis {
        case chartView.xAxis:
            return confirmCaseModels[Int(value)].dateText
        default:
            return String(describing: value)
        }
    }
}
