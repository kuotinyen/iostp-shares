//
//  CommonModels.swift
//  iostp-charts-demo
//
//  Created by Ting Yen Kuo on 2021/5/23.
//

import Foundation

struct Covid19ConfirmCase {
    let dateText: String
    let number: Int
    let correctNumber: Int
}

struct NewTaipeiCityConfirmCaseDistrict {
    let name: String
    let number: Int
}

// MARK: Health Promotion Administration

class HPA {
    static let shared = HPA()
    private init() { }

    let confirmCaseModels: [Covid19ConfirmCase] = [
        .init(dateText: "5/16", number: 206, correctNumber: 245),
        .init(dateText: "5/17", number: 333, correctNumber: 406),
        .init(dateText: "5/18", number: 240, correctNumber: 325),
        .init(dateText: "5/19", number: 267, correctNumber: 359),
        .init(dateText: "5/20", number: 286, correctNumber: 360),
        .init(dateText: "5/21", number: 312, correctNumber: 349),
    ]

    // 5/22, https://health.udn.com/health/story/120950/5477902
    let confirmCasesDistricts: [NewTaipeiCityConfirmCaseDistrict] = [
        .init(name: "板橋", number: 103),
        .init(name: "新莊", number: 56),
        .init(name: "三重", number: 48),
        .init(name: "中和", number: 46),
        .init(name: "永和", number: 27),
        // ...
    ]
}
