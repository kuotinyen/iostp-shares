//
//  DemoPieChartViewController.swift
//  iostp-charts-demo
//
//  Created by Ting Yen Kuo on 2021/5/23.
//

import UIKit
import SnapKit
import Charts

class DemoPieChartView: UIView {
    var xAxis: XAxis { chartView.xAxis }

    private let chartView = PieChartView()

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

        // setup pie chart slice no (focus / highlight)
        chartView.highlightPerTapEnabled = false

        // setup hole UI style
        chartView.holeColor = .clear
        chartView.holeRadiusPercent = 0.6
        chartView.transparentCircleColor = .clear

        // setup legend
        chartView.legend.direction = .rightToLeft
        chartView.legend.horizontalAlignment = .right
        chartView.legend.verticalAlignment = .top
    }

    func populate(with chartData: PieChartData?) {
        guard let chartData = chartData else {
            chartView.data = nil
            return
        }
        chartView.data = chartData
    }
}

class DemoPieChartViewChartViewController: UIViewController {

    private let districts = HPA.shared.confirmCasesDistricts
    private let chartView = DemoPieChartView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.directionalLayoutMargins = .init(top: 20, leading: .zero, bottom: .zero, trailing: .zero)

        // add chart view
        view.addSubview(chartView)
        chartView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.height.equalTo(300)
        }

        let dataEntries = districts.map { PieChartDataEntry(value: Double($0.number), label: $0.name) }
        let dataSet = PieChartDataSet(entries: dataEntries, label: "2021/05/22 新北市確診人數")

        // setup slice title position
        dataSet.xValuePosition = PieChartDataSet.ValuePosition.outsideSlice

        dataSet.sliceSpace = 3
        dataSet.valueLineColor = .lightGray
        dataSet.colors = makeDataSetColors(entriesCount: dataEntries.count)
        dataSet.entryLabelColor = .orange
        dataSet.drawValuesEnabled = true
        dataSet.valueColors = [.white]
        chartView.populate(with: PieChartData(dataSet: dataSet))
    }

    private func makeDataSetColors(entriesCount: Int) -> [UIColor] {
        let hexColors: [Int] = [0x123b5e, 0x1f68a5, 0x2c95ec, 0x6cb4f1, 0xabd4f7, 0xeaf4fd]
        let colors: [UIColor] = hexColors.compactMap { UIColor(hex: $0) }
        return Array(colors.prefix(entriesCount))
    }
}

// MARK: - IAxisValueFormatter

extension DemoPieChartViewChartViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        switch axis {
        case chartView.xAxis:
            return districts[Int(value)].name
        default:
            return String(describing: value)
        }
    }
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(hex: Int) {
       self.init(
           red: (hex >> 16) & 0xFF,
           green: (hex >> 8) & 0xFF,
           blue: hex & 0xFF
       )
   }
}
