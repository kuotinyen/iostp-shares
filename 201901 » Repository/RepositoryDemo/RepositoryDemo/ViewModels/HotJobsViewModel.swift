//
//  HotJobsViewModel.swift
//  SingleSourceRepositoryDemo
//
//  Created by TING YEN KUO on 2019/1/24.
//  Copyright © 2019 TING YEN KUO. All rights reserved.
//

import Foundation

class HotJobsViewModel {
    
    var displayViewModels = [JobListCellViewModel]()
    
    var offset: Int {
        return displayViewModels.count
    }
    
    var reloadTableViewClosure: (() -> Void)?
    
    func loadData() {
        displayViewModels.removeAll()
        getData()
    }
    
    func loadMoreData() {
        getData()
    }
    
    func getData() {
        
        let params: [String: Any] = [
            "limit": 15,
            "offset": offset
        ]
        
        JobsAPI.shared.fetchHotJobs(with: params) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let jobs, _):
                let fetchedVMs = jobs.map { JobListCellViewModel(job: $0) }
                self.displayViewModels.append(contentsOf: fetchedVMs)
                
                self.reloadTableViewClosure?()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
