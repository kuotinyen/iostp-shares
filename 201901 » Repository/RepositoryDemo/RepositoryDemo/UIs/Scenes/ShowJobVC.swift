//
//  ShowJobVC.swift
//  RepositoryDemo
//
//  Created by TING YEN KUO on 2019/1/28.
//  Copyright © 2019 TING YEN KUO. All rights reserved.
//

import UIKit
import ChainsKit
import ImageProvider

class ShowJobVC: UIViewController {
    
    lazy var tableView: UITableView = {
        
        let tv = UITableView()
            .backgroundColor(Theme.grayColor)
            .contentInset(UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0))
            .separatorStyle(.none)
            .estimatedRowHeight(44)
            .dataSource(self)
            .delegate(self)
        
        tv.registerReusableCell(JobTitleInfoCell.self)
        tv.registerReusableCell(JobMapInfoCell.self)
        tv.registerReusableCell(JobDetailCell.self)
        
        return tv
    }()
    
    var cells: [CellItem] = [.jobTitleInfo, .jobMapInfo, .jobDetail]
    let viewModel: ShowJobViewModel!
    
    init(jobId: String) {
        self.viewModel = ShowJobViewModel(jobId: jobId)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.reloadDataClosure = { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        
        setupViews()
    }
    
    func setupViews() {
        
        navigationItem
            .title("職缺內文")
        
        view.backgroundColor(.white)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                make.bottom.equalTo(self.bottomLayoutGuide.snp.bottom).offset(0)
            }
        }
        
    }
    
}

// ----------------------------------------------------------------------------------
/// TableView Delegate funcs
// MARK: - TableView Delegate funcs
// ----------------------------------------------------------------------------------

extension ShowJobVC: UITableViewDataSource, UITableViewDelegate {
    
    enum CellItem {
        case jobTitleInfo
        case jobMapInfo
        case jobDetail
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getCellsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellVM = JobListCellViewModel(job: viewModel.job)
        
        switch cells[indexPath.row] {
        case .jobTitleInfo:
            let cell = tableView.dequeueCell(forIndexPath: indexPath) as JobTitleInfoCell
            cell.viewModel = cellVM
            return cell
        case .jobMapInfo:
            let cell = tableView.dequeueCell(forIndexPath: indexPath) as JobMapInfoCell
            cell.viewModel = cellVM
            return cell
        case .jobDetail:
            let cell = tableView.dequeueCell(forIndexPath: indexPath) as JobDetailCell
            cell.viewModel = cellVM
            return cell
        }
    }
    
}

// ----------------------------------------------------------------------------------
/// Private funcs
// MARK: - Private funcs
// ----------------------------------------------------------------------------------

extension ShowJobVC {
    
    private func getCellsCount() -> Int {
        let hasRequirement = viewModel.job?.requirement != nil
            && viewModel.job?.requirement?.count != 0
        return hasRequirement ? 3 : 2
    }
    
}


