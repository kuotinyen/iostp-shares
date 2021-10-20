//
//  FavoriteListInteractor.swift
//  MultipleSelectionSample
//
//  Created by TK on 2021/10/19.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol FavoriteListBusinessLogic {
    func fetchData(request: FavoriteList.FetchData.Request)
    func toggleFavorite(request: FavoriteList.ToggleFavorite.Request)
    func favoriteAll(request: FavoriteList.FavoriteAll.Request)
    func unfavoriteAll(request: FavoriteList.UnfavoriteAll.Request)
}

class FavoriteListInteractor: FavoriteListBusinessLogic {
    var presenter: FavoriteListPresentationLogic?
    
    private let equities: [Equity]
    private var isFavorites: [Bool] = []
    
    init(with equities: [Equity]) {
        self.equities = equities
        self.isFavorites = Array(repeating: false, count: equities.count)
    }
    
    func fetchData(request: FavoriteList.FetchData.Request) {
        presentData()
    }
    
    func toggleFavorite(request: FavoriteList.ToggleFavorite.Request) {
        isFavorites[request.index].toggle()
        presentData()
    }
    
    func favoriteAll(request: FavoriteList.FavoriteAll.Request) {
        isFavorites = Array(repeating: true, count: equities.count)
        presentData()
    }
    
    func unfavoriteAll(request: FavoriteList.UnfavoriteAll.Request) {
        isFavorites = Array(repeating: false, count: equities.count)
        presentData()
    }
    
    private func presentData() {
        let response = FavoriteList.FetchData.Response(equities: equities, isFavorites: isFavorites)
        presenter?.presentData(response: response)
    }
}
