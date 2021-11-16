//
//  ContentViewController.swift
//  PanelMap
//
//  Created by TK on 2021/11/16.
//

import UIKit

class ContentViewController: UIViewController, PanelContentProvider {
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.dataSource = self
        tv.delegate = self
        tv.showsVerticalScrollIndicator = false
        tv.separatorStyle = .none
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tv
    }()
    
    weak var scrollDelegate: PanelContentScrollDelegate?
    
    private let items: [String] = [
        "January – 31 days",
        "February – 28 days",
        "March – 31 days",
        "April – 30 days",
        "May – 31 days",
        "June – 30 days",
        "July – 31 days",
        "August – 31 days",
        "September – 30 days",
        "October – 31 days",
        "November – 30 days",
        "December – 31 days",
        "January – 31 days",
        "February – 28 days",
        "March – 31 days",
        "April – 30 days",
        "May – 31 days",
        "June – 30 days",
        "July – 31 days",
        "August – 31 days",
        "September – 30 days",
        "October – 31 days",
        "November – 30 days",
        "December – 31 days",
        "January – 31 days",
        "February – 28 days",
        "March – 31 days",
        "April – 30 days",
        "May – 31 days",
        "June – 30 days",
        "July – 31 days",
        "August – 31 days",
        "September – 30 days",
        "October – 31 days",
        "November – 30 days",
        "December – 31 days",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDataSource

extension ContentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard items.indices.contains(indexPath.row) else { return .init() }
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ContentViewController: UITableViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollDelegate?.handleScrollViewWillBeginDragging(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollDelegate?.handleScrollViewDidEndDragging(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollDelegate?.handleScrollViewDidEndDragging(scrollView)
    }
}
