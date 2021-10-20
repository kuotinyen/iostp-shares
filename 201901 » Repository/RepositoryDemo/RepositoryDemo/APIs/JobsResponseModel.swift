//
//  JobsResponseModel.swift
//  SingleSourceRepositoryDemo
//
//  Created by TING YEN KUO on 2019/1/24.
//  Copyright © 2019 TING YEN KUO. All rights reserved.
//

import Foundation

struct JobsResponseModel: Decodable {
    
    let jobs: [Job]
    let totalCount: Int
    
    enum CodingKeys: String, CodingKey {
        case jobs = "data"
        case total = "total"
    }
    
    init(from decoder: Decoder) throws {
        let vals = try decoder.container(keyedBy: CodingKeys.self)
        
        jobs = try vals.decode([Job].self, forKey: .jobs)
        totalCount = try vals.decode(Int.self, forKey: .total)
    }
}
