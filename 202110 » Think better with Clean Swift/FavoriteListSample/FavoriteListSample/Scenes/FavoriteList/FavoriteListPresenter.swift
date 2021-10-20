//
//  FavoriteListPresenter.swift
//  MultipleSelectionSample
//
//  Created by TK on 2021/10/19.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

protocol FavoriteListPresentationLogic {
    func presentData(response: FavoriteList.FetchData.Response)
}

class FavoriteListPresenter: FavoriteListPresentationLogic {
    var viewController: FavoriteListDisplayLogic?
    
    func presentData(response: FavoriteList.FetchData.Response) {
        // Chart...
        let quoteViewModels: [QuoteViewModel] = zip(response.equities, response.isFavorites).map { equity, isFavorite in
            QuoteViewModel(name: equity.name, symbol: equity.symbol, actionImage: UIImage(named: isFavorite ? "iconSelected" : "iconNormal"))
        }
        let canFavoriteAll = !response.isFavorites.allSatisfy { $0 == true }
        let canConfirm = response.isFavorites.contains(true)
        let viewModel = FavoriteList.FetchData.ViewModel(quoteViewModels: quoteViewModels,
                                                          canFavoriteAll: canFavoriteAll,
                                                          canConfirm: canConfirm)
        viewController?.displayData(viewModel: viewModel)
    }
}
