//
//  DemoListViewController.swift
//  iostp-charts-demo
//
//  Created by Ting Yen Kuo on 2021/5/22.
//

import UIKit
import SnapKit

enum Demo: CustomStringConvertible {
    case lineChart
    case barChart
    case lineBarCombined
    case pieChart
    case lineChartAndMarker

    var description: String {
        switch self {
        case .lineChart: return "Line Chart"
        case .barChart: return "Bar Chart"
        case .lineBarCombined: return "Combined(Line, Bar) Chart"
        case .pieChart: return "Pie Chart"
        case .lineChartAndMarker: return "Line Chart + Marker"
        }
    }
}

class DemoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let demos: [Demo] = [.lineChart, .barChart, .lineBarCombined, .pieChart, .lineChartAndMarker]

    private let tableView = UITableView(frame: .zero, style: .grouped)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reusableIdentifier)
        title = "Demo cases"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        demos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reusableIdentifier, for: indexPath)
        cell.textLabel?.text = demos[indexPath.row].description
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch demos[indexPath.row] {
        case .lineChart:
            let viewController = DemoLineChartViewController()
            navigationController?.pushViewController(viewController, animated: true)
        case .barChart:
            let viewController = DemoBarChartViewController()
            navigationController?.pushViewController(viewController, animated: true)
        case .lineBarCombined:
            let viewController = DemoLineBarCombinedChartViewController()
            navigationController?.pushViewController(viewController, animated: true)
        case .pieChart:
            let viewController = DemoPieChartViewChartViewController()
            navigationController?.pushViewController(viewController, animated: true)
        case .lineChartAndMarker:
            let viewController = DemoLineChartAndMarkerViewController()
            navigationController?.pushViewController(viewController, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - Helpers

extension UITableViewCell {
    static var reusableIdentifier: String { String(describing: type(of: self)) }
}
