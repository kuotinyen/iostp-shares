//
//  UBikeStationListInteractorTests.swift
//  clean-swift-vip-unit-testTests
//
//  Created by tkuo on 2020/4/17.
//  Copyright © 2020 com.tykuo. All rights reserved.
//

import XCTest
@testable import clean_swift_vip_unit_test

class UBikeStationListInteractorTests: XCTestCase {
    var sut: UBikeStationListInteractor!
    var presenter: UBikeStationListPresenterFake!

    override func setUp() {
        super.setUp()
        sut = UBikeStationListInteractor()
        presenter = UBikeStationListPresenterFake()
        sut.presenter = presenter
    }

    func testFetchOneTaipeiUBikeStations() {
        // Arrange
        let fakeApiWorker = UBikeApiWorkerFake()
        fakeApiWorker.stationsCount = 1
        sut.apiWorker = fakeApiWorker
        let expectation = XCTestExpectation(description: "testFetchOneTaipeiUBikeStations")

        presenter.verifyPresentStationsClosure = { isPresentStationsCalled, stations in
            // Assert
            XCTAssertEqual(isPresentStationsCalled, true)
            XCTAssertEqual(stations.count, 1)
            expectation.fulfill()
        }

        // Act
        sut.fetchUBikeStation(request: .init(area: .taipei))
        wait(for: [expectation], timeout: 3)
    }

    func testFetchEmptyTaipeiUBikeStations() {
        // Arrange
        let fakeApiWorker = UBikeApiWorkerFake()
        fakeApiWorker.stationsCount = 0
        sut.apiWorker = fakeApiWorker
        let expectation = XCTestExpectation(description: "testFetchEmptyTaipeiUBikeStations")

        presenter.verifyPresentErrorClosure = { isPresentErrorCalled, stations, error in
            // Assert
            XCTAssertEqual(isPresentErrorCalled, true)
            XCTAssertEqual(stations.count, 0)
            XCTAssertEqual(error, .emptyStations)
            expectation.fulfill()
        }

        // Act
        sut.fetchUBikeStation(request: .init(area: .taipei))
        wait(for: [expectation], timeout: 3)
    }

    func testFetchDecodingErrorTaipeiUBikeStations() {
        // Arrange
        let fakeApiWorker = UBikeApiWorkerFake()
        fakeApiWorker.stationsCount = -1
        sut.apiWorker = fakeApiWorker
        let expectation = XCTestExpectation(description: "testFetchDecodingErrorTaipeiUBikeStations")

        presenter.verifyPresentErrorClosure = { isPresentErrorCalled, stations, error in
            // Assert
            XCTAssertEqual(isPresentErrorCalled, true)
            XCTAssertEqual(stations.count, 0)
            XCTAssertEqual(error, .apiError)
            expectation.fulfill()
        }

        // Act
        sut.fetchUBikeStation(request: .init(area: .taipei))
        wait(for: [expectation], timeout: 3)
    }
}


class UBikeStationListPresenterFake: UBikeStationListPresenter {
    var isPresentStationsCalled: Bool = false
    var isPresentErrorCalled: Bool = false
    var ubikestations: [UBikeStation] = []
    var error: ShowUBikeStationList.UBikeStationListErrorType!

    var verifyPresentStationsClosure: ((Bool, [UBikeStation]) -> Void)?
    var verifyPresentErrorClosure: ((Bool, [UBikeStation], ShowUBikeStationList.UBikeStationListErrorType) -> Void)?

    override func presentStations(response: ShowUBikeStationList.ShowStations.Response) {
        isPresentStationsCalled = true
        ubikestations = response.ubikeStations
        verifyPresentStationsClosure?(isPresentStationsCalled, ubikestations)
    }

    override func presentError(response: ShowUBikeStationList.ShowError.Response) {
        isPresentErrorCalled = true
        ubikestations = []
        error = response.error
        verifyPresentErrorClosure?(isPresentErrorCalled, ubikestations, error)
    }
}

class UBikeApiWorkerFake: UBikeApiWorker {
    var stationsCount: Int = 0

    override func fetchTaipeiUBikeStations(completion: @escaping UBikeApiWorker.ApiCompletion) {
        switch stationsCount {
        case 1...:
            let stations: [UBikeStation] = [UBikeStation](repeating: UBikeStation.generateEmptyStation(), count: stationsCount)
            completion(.success(stations))
        case -1:
            completion(.failure(.decodingModelError))
        case 0:
            completion(.failure(.emptyDataError))
        default:
            completion(.failure(.invalidDataError))
        }
    }
}

// MARK: - Constant

extension UBikeApiWorkerFake {
    private enum Constant {
        enum TestData {
            enum Stations {
                static let OneUBikeStations: [UBikeStation] = [
                    UBikeStation.generateEmptyStation()
                ]
                static let NoUBikeStations: [UBikeStation] = []
            }
        }
    }
}
