//
//  ViewController.swift
//  AccessibilityDemo
//
//  Created by Ting Yen Kuo on 2021/9/8.
//

import UIKit
import SnapKit

struct TableItem {
    let title: String
    let subtitle: String
}

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let sectionHeader: UIView = {
        let label = UILabel()
        label.text = "Header"

        let view = UIView()
        view.backgroundColor = .gray
        view.directionalLayoutMargins = .init(top: 8, leading: 20, bottom: 8, trailing: 20)
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalTo(view.layoutMarginsGuide)
        }
        return view
    }()

    private let items = (0...10).map {
        TableItem(title: "Title \($0)", subtitle: "Subtitle \($0)")
    }

    var viewModels: [TableItemCell.ViewModel] {
        items.map { .init(title: $0.title, subtitle: $0.subtitle) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TableItemCell.self, forCellReuseIdentifier: TableItemCell.reusableIdentifier)
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableItemCell.reusableIdentifier, for: indexPath)

        if viewModels.indices.contains(indexPath.row), let cell = cell as? TableItemCell {
            cell.populate(with: viewModels[indexPath.row])
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { sectionHeader }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 80 }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard viewModels.indices.contains(indexPath.row), viewModels[indexPath.row] == viewModels.last else { return }
        UIAccessibility.post(notification: .screenChanged, argument: "已滑動到最底部")
    }
}

// MARK: - Cell

protocol IdentifiableCell {
    static var reusableIdentifier: String { get }
}

extension IdentifiableCell {
    static var reusableIdentifier: String { String(describing: type(of: self)) }
}

extension UITableViewCell: IdentifiableCell { }

class TableItemCell: UITableViewCell {
    struct ViewModel: Equatable {
        let id = UUID()
        let title: String
        let subtitle: String

        static func == (lhs: ViewModel, rhs: ViewModel) -> Bool {
            return lhs.id == rhs.id
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        contentView.directionalLayoutMargins = .init(top: 8, leading: 20, bottom: 8, trailing: 20)
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading

        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)

        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.layoutMarginsGuide)
        }
    }

    func populate(with viewModel: ViewModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }
}

