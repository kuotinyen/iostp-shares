//
//  UBikeApiWorker.swift
//  clean-swift-vip-unit-test
//
//  Created by tkuo on 2020/4/15.
//  Copyright © 2020 com.tykuo. All rights reserved.
//

import Foundation
import Alamofire

class UBikeApiWorker {
    typealias ApiResult = Swift.Result<[UBikeStation], ApiResponseError>
    typealias ApiCompletion = (ApiResult) -> Void

    enum ApiResponseError: Error {
        case encodingUrlError
        case decodingModelError
        case emptyDataError
        case invalidDataError
    }

    func fetchNewTaipeiUBikeStations(completion: @escaping ApiCompletion) {
        guard let url = Constant.Endpoints.NewTaipeiUBike.url else {
            completion(.failure(.encodingUrlError))
            return
        }

        Alamofire
            .request(url, method: .get)
            .responseJSON { (response) in
                guard let jsonValue = response.result.value,
                    let data = try? JSONSerialization.data(withJSONObject: jsonValue),
                    let model = try? JSONDecoder().decode(NewTaipeiUBikeResponseModel.self, from: data) else {
                        completion(.failure(.decodingModelError))
                        return
                }
                let records = model.result.records
                guard !records.isEmpty else {
                    completion(.failure(.emptyDataError))
                    return
                }
                completion(.success(records))
        }
    }

    func fetchTaipeiUBikeStations(completion: @escaping ApiCompletion) {
        guard let url = Constant.Endpoints.TaipeiUBike.url else {
            completion(.failure(.encodingUrlError))
            return
        }

        Alamofire
            .request(url, method: .get)
            .responseJSON { (response) in
                guard let jsonValue = response.result.value,
                    let data = try? JSONSerialization.data(withJSONObject: jsonValue),
                    let model = try? JSONDecoder().decode(TaipeiUBikeResponseModel.self, from: data) else {
                        completion(.failure(.decodingModelError))
                        return
                }
                let records = model.result.records
                guard !records.isEmpty else {
                    completion(.failure(.emptyDataError))
                    return
                }
                completion(.success(records))
        }
    }
}

// MARK: - Endpoints

private extension UBikeApiWorker {
    enum Constant {
        struct Endpoint {
            let host: String
            let path: String

            var url: URL? {
                var components = URLComponents()
                components.scheme = "http"
                components.host = host
                components.path = path
                return components.url
            }
        }

        enum Endpoints {
            static let NewTaipeiUBike = Endpoint(host: "data.ntpc.gov.tw",
                                                 path: "/api/v1/rest/datastore/382000000A-000352-001")
            static let TaipeiUBike = Endpoint(host: "tcgbusfs.blob.core.windows.net",
                                              path: "/blobyoubike/YouBikeTP.json")
        }
    }
}

