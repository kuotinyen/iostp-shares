//
//  UBikeStationListInteractor.swift
//  clean-swift-vip-unit-test
//
//  Created by tkuo on 2020/4/15.
//  Copyright © 2020 com.tykuo. All rights reserved.
//

import Foundation

protocol UBikeStationListBusinessLogic {
    func fetchUBikeStation(request: ShowUBikeStationList.FetchStations.Request)
}

class UBikeStationListInteractor: UBikeStationListBusinessLogic {
    var apiWorker = UBikeApiWorker()
    var presenter = UBikeStationListPresenter()

    func fetchUBikeStation(request: ShowUBikeStationList.FetchStations.Request) {
        switch request.area {
        case .taipei:
            apiWorker.fetchTaipeiUBikeStations { [weak self] (result) in
                self?.handle(fetchUBikeStationsResult: result)
            }
        case .newTaipei:
            apiWorker.fetchNewTaipeiUBikeStations { [weak self] (result) in
                self?.handle(fetchUBikeStationsResult: result)
            }
        }
    }

    func handle(fetchUBikeStationsResult result: UBikeApiWorker.ApiResult) {
        DispatchQueue.main.async {
            switch result {
            case let .success(ubikeStations):
                self.presenter.presentStations(response: .init(ubikeStations: ubikeStations))
            case let .failure(error):
                switch error {
                case .emptyDataError:
                    self.presenter.presentError(response: ShowUBikeStationList.ShowError.Response(error: .emptyStations))
                case .decodingModelError:
                    self.presenter.presentError(response: .init(error: .apiError))
                default: break
                }
                break // FIXME: todo
            }
        }
    }
}
