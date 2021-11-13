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

    let chartView = LineChartView()

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

        chartView.renderer = FillAreaLineChartRenderer(dataProvider: chartView,
                                                       animator: chartView.chartAnimator,
                                                       viewPortHandler: chartView.viewPortHandler)

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
        leftAxis.drawZeroLineEnabled = true
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

        let correctedConfirmCasesEntries = confirmCaseModels.enumerated()
            .map { index, value in ChartDataEntry(x: Double(index), y: Double(value.correctNumber)) }

        let confirmCasesEntries = confirmCaseModels.enumerated()
            .map { index, value in ChartDataEntry(x: Double(index), y: Double(value.number)) }



        let casesSet = makeDataSet(with: confirmCasesEntries, label: "確診數", color: .orange, shouldFillColor: true, boundaryDataSet: nil)

        let correctedCasesSet = makeDataSet(with: correctedConfirmCasesEntries, label: "校正回歸確診數", color: .blue, shouldFillColor: true, boundaryDataSet: casesSet)

        let chartData: LineChartData = .init(dataSets: [casesSet, correctedCasesSet])
        chartView.populate(with: chartData)
    }

    private func makeDataSet(with entries: [ChartDataEntry], label: String, color: UIColor, shouldFillColor: Bool, boundaryDataSet: LineChartDataSet? = nil) -> LineChartDataSet {
        let dataSet: LineChartDataSet = .init(entries: entries, label: label)
        dataSet.circleRadius = 2.5
        dataSet.lineWidth = 1.5
        dataSet.drawValuesEnabled = false
        dataSet.circleColors = [color]
        dataSet.colors = [color]
        dataSet.drawFilledEnabled = shouldFillColor
        dataSet.fillColor = color
        dataSet.fillAlpha = 0.3
        dataSet.fillFormatter = shouldFillColor ? FillAreaLineFormatter(boundaryDataSet: boundaryDataSet) : nil
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

class FillAreaLineFormatter: IFillFormatter {
    var boundaryDataSet: LineChartDataSet?

    init(boundaryDataSet: LineChartDataSet?) {
        self.boundaryDataSet = boundaryDataSet
    }

    public func getFillLinePosition(dataSet: ILineChartDataSet, dataProvider: LineChartDataProvider) -> CGFloat {
        let minimumAxisDisplayValue = Double(dataProvider.getAxis(.left).getFormattedLabel(.zero)) ?? .zero
        return CGFloat(minimumAxisDisplayValue)
    }

    public func getBoundaryDataSet() -> LineChartDataSet {
        return boundaryDataSet ?? LineChartDataSet()
    }
}

class FillAreaLineChartRenderer: LineChartRenderer {
    override func drawLinearFill(context: CGContext,
                                 dataSet: ILineChartDataSet,
                                 trans: Transformer,
                                 bounds: BarLineScatterCandleBubbleRenderer.XBounds) {
        guard let dataProvider = dataProvider,
              let fillAreaFormatter = dataSet.fillFormatter as? FillAreaLineFormatter  else { return }

        let filledPath = makeFilledPath(dataSet: dataSet,
                                        fillMin: fillAreaFormatter.getFillLinePosition(dataSet: dataSet,
                                                                                       dataProvider: dataProvider),
                                        boundaryDataSet: fillAreaFormatter.getBoundaryDataSet(),
                                        bounds: bounds,
                                        matrix: trans.valueToPixelMatrix)
        if let fill = dataSet.fill {
            drawFilledPath(context: context, path: filledPath, fill: fill, fillAlpha: dataSet.fillAlpha)
        } else {
            drawFilledPath(context: context, path: filledPath, fillColor: dataSet.fillColor, fillAlpha: dataSet.fillAlpha)
        }
    }

    private func makeFilledPath(dataSet: ILineChartDataSet,
                                fillMin: CGFloat,
                                boundaryDataSet: ILineChartDataSet?,
                                bounds: XBounds,
                                matrix: CGAffineTransform) -> CGPath {
        let phaseY = animator.phaseY
        let isDrawSteppedEnabled = dataSet.mode == .stepped
        var entry: ChartDataEntry! = dataSet.entryForIndex(bounds.min)
        var boundaryEntry: ChartDataEntry? = boundaryDataSet?.entryForIndex(bounds.min)
        let path = CGMutablePath()

        if entry != nil {
            if let boundaryEntry = boundaryEntry {
                path.move(to: CGPoint(x: CGFloat(entry.x), y: CGFloat(boundaryEntry.y * phaseY)), transform: matrix)
            } else {
                path.move(to: CGPoint(x: CGFloat(entry.x), y: fillMin), transform: matrix)
            }

            path.addLine(to: CGPoint(x: CGFloat(entry.x), y: CGFloat(entry.y * phaseY)), transform: matrix)
        }

        // Draw current entries line
        for x in stride(from: (bounds.min + 1), through: bounds.range + bounds.min, by: 1) {
            guard let entry = dataSet.entryForIndex(x) else { continue }

            if isDrawSteppedEnabled {
                guard let previousEntry = dataSet.entryForIndex(x-1) else { continue }
                path.addLine(to: CGPoint(x: CGFloat(entry.x), y: CGFloat(previousEntry.y * phaseY)), transform: matrix)
            }

            path.addLine(to: CGPoint(x: CGFloat(entry.x), y: CGFloat(entry.y * phaseY)), transform: matrix)
        }

        // Draw a path to the start of the fill line
        entry = dataSet.entryForIndex(bounds.range + bounds.min)
        boundaryEntry = boundaryDataSet?.entryForIndex(bounds.range + bounds.min)
        if entry != nil {
            if let boundaryEntry = boundaryEntry {
                path.addLine(to: CGPoint(x: CGFloat(entry.x), y: CGFloat(boundaryEntry.y * phaseY)), transform: matrix)
            } else {
                path.addLine(to: CGPoint(x: CGFloat(entry.x), y: fillMin), transform: matrix)
            }
        }

        // Draw bondary entries line
        if let boundaryDataSet = boundaryDataSet {
            for x in stride(from: (bounds.min + 1), through: bounds.range + bounds.min, by: 1).reversed() {
                guard let e = boundaryDataSet.entryForIndex(x) else { continue }

                if isDrawSteppedEnabled {
                    guard let previousEntry = boundaryDataSet.entryForIndex(x-1) else { continue }
                    path.addLine(to: CGPoint(x: CGFloat(e.x), y: CGFloat(previousEntry.y * phaseY)), transform: matrix)
                }

                path.addLine(to: CGPoint(x: CGFloat(e.x), y: CGFloat(e.y * phaseY)), transform: matrix)
            }
        }

        path.closeSubpath()

        return path
    }
}
