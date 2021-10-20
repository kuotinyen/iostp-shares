//
//  FavoriteListModels.swift
//  MultipleSelectionSample
//
//  Created by TK on 2021/10/19.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

struct Equity {
    let name: String   // 台積電
    let symbol: String // 2330
    // ...
}

struct QuoteViewModel {
    let name: String
    let symbol: String
    let actionImage: UIImage?
}

// MARK: - Use Cases

enum FavoriteList {
    enum FetchData {
        struct Request { }
        
        struct Response {
            let equities: [Equity]
            let isFavorites: [Bool]
        }
        
        struct ViewModel {
            let quoteViewModels: [QuoteViewModel]
            let canFavoriteAll: Bool
            let canConfirm: Bool
        }
    }
    
    enum ToggleFavorite {
        struct Request {
            let index: Int
        }
    }
    
    enum FavoriteAll {
        struct Request { }
    }
    
    enum UnfavoriteAll {
        struct Request { }
    }
}
