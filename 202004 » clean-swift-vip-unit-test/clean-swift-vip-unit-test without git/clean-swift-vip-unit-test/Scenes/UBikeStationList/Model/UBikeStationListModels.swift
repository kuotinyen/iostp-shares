//
//  UBikeStationListModels.swift
//  clean-swift-vip-unit-test
//
//  Created by tkuo on 2020/4/15.
//  Copyright © 2020 com.tykuo. All rights reserved.
//

import Foundation

enum ShowUBikeStationList {

    // MARK: - Models
    enum UBikeStationArea {
        case taipei
        case newTaipei
    }

    struct UBikeStationViewModel {
        var title: String
    }

    enum UBikeStationListErrorType: Equatable {
        case apiError
        case emptyStations
    }

    // MARK: - Use Case
    enum FetchStations {
        struct Request {
            var area: UBikeStationArea
        }
    }

    enum ShowStations {
        struct Response {
            var ubikeStations: [UBikeStation]
        }

        struct ViewModel {
            var stationViewModels: [UBikeStationViewModel]
        }
    }

    enum ShowError {
        struct Response {
            var error: UBikeStationListErrorType
        }

        struct ViewModel {
            let text: String
            let retryTitle: String?
            let cancelTitle: String
            let error: UBikeStationListErrorType
        }
    }
}
