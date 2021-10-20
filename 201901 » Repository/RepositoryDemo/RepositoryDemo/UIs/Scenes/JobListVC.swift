//
//  JobListVC.swift
//  RepositoryDemo
//
//  Created by TING YEN KUO on 2019/1/27.
//  Copyright © 2019 TING YEN KUO. All rights reserved.
//

import UIKit

class JobListVC: UIViewController {
    
    lazy var tableView: UITableView = {
        let contentInset = UIEdgeInsets(top: 0,left: 0,bottom: 30,right: 0)
        
        let tv = UITableView()
            .backgroundColor(Theme.grayColor)
            .contentInset(contentInset)
            .separatorStyle(.none)
            .estimatedRowHeight(44)
            .dataSource(self)
            .delegate(self)
        
        tv.registerReusableCell(JobListCell.self)
        
        return tv
    }()
    
    lazy var hotJobsVM: HotJobsViewModel = {
        var vm = HotJobsViewModel()
        vm.reloadTableViewClosure = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hotJobsVM.loadData()
    }
    
    func setupViews() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
}

// ----------------------------------------------------------------------------------
/// TableView Delegate funcs
// MARK: - TableView Delegate funcs
// ----------------------------------------------------------------------------------

extension JobListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotJobsVM.displayViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueCell(forIndexPath: indexPath) as JobListCell
        cell.viewModel = hotJobsVM.displayViewModels[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedVM = hotJobsVM.displayViewModels[indexPath.row]
        guard let job = selectedVM.job else { return }
        
        let vc = ShowJobVC(jobId: job.jobId)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


