//
//  UBikeStationListPresenter.swift
//  clean-swift-vip-unit-test
//
//  Created by tkuo on 2020/4/15.
//  Copyright © 2020 com.tykuo. All rights reserved.
//

import Foundation

protocol UBikeStationListPresentationLogic {
    func presentStations(response: ShowUBikeStationList.ShowStations.Response)
    func presentError(response: ShowUBikeStationList.ShowError.Response)
}

class UBikeStationListPresenter: UBikeStationListPresentationLogic {
    typealias UBikeStationViewModel = ShowUBikeStationList.UBikeStationViewModel
    weak var viewController: UBikeStationListDisplayLogic?

    func presentStations(response: ShowUBikeStationList.ShowStations.Response) {
        let stationViewModels: [UBikeStationViewModel] = response.ubikeStations.map { UBikeStationViewModel(ubikeStation: $0) }
        let viewModel: ShowUBikeStationList.ShowStations.ViewModel = .init(stationViewModels: stationViewModels)
        viewController?.displayStations(viewModel:viewModel)
    }

    func presentError(response: ShowUBikeStationList.ShowError.Response) {
        guard let text = Constant.ErrorTextMap[response.error] else {
            return
        }
        let retryTitle = Constant.ErrorRetryTitleMap[response.error]
        
        let viewModel = ShowUBikeStationList.ShowError.ViewModel(text: text,
                                                             retryTitle: retryTitle,
                                                             cancelTitle: Constant.Cancel,
                                                             error: response.error)
        viewController?.displayError(viewModel: viewModel)
    }
}

// MARK: - Private helper

private extension ShowUBikeStationList.UBikeStationViewModel {
    init(ubikeStation: UBikeStation) {
        let title = ubikeStation.chineseName
        self.init(title: title)
    }
}

// MARK: - Constant

extension UBikeStationListPresenter {
    private enum Constant {
        static let ErrorTextMap: [ShowUBikeStationList.UBikeStationListErrorType: String] = [
            .emptyStations: "目前沒有任何 UBike 站點。"
        ]
        static let ErrorRetryTitleMap: [ShowUBikeStationList.UBikeStationListErrorType: String] = [
            .emptyStations: "點擊重試"
        ]

        static let Cancel = "取消"
    }
}

