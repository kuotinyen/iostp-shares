//
//  UBikeResponseModels.swift
//  clean-swift-vip-unit-test
//
//  Created by tkuo on 2020/4/15.
//  Copyright © 2020 com.tykuo. All rights reserved.
//

import Foundation

struct NewTaipeiUBikeResponseModel: Decodable {
    var success: Bool
    let result: NewTaipeiUBikeResult
}

struct NewTaipeiUBikeResult: Decodable {
    var records: [UBikeStation]
}

struct TaipeiUBikeResponseModel: Decodable {
    enum CodingKeys: String, CodingKey {
        case success = "retCode"
        case result =  "retVal"
    }

    var success: Bool
    let result: TaipeiUBikeResult

    init(from decoder: Decoder) throws {

        do {
            let vals = try decoder.container(keyedBy: CodingKeys.self)

            let successIntVal = try vals.decode(Int.self, forKey: .success)
            self.success = successIntVal == 1

            let resultDict = try vals.decode(Dictionary<String, UBikeStation>.self, forKey: .result)
            let bikes = Array(resultDict.values)
            let result = TaipeiUBikeResult.init(records: bikes)
            self.result = result
        } catch {
            print("Error -> \(error)")
            throw(error)
        }
    }
}

struct TaipeiUBikeResult: Codable {
    var records: [UBikeStation]
}
