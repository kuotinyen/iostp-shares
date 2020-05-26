//
//  PNEditPaymentRouter.swift.swift
//  Payman
//
//  Created by tkuo on 2020/5/16.
//  Copyright (c) 2020 com.tykuo. All rights reserved.
//

import UIKit

protocol PNEditPaymentRoutingLogic {
    func routeBackToRoom()
}

protocol PNEditPaymentDataPassing {
    var dataStore: PNEditPaymentDataStore? { get }
}

class PNEditPaymentRouter: PNEditPaymentRoutingLogic, PNEditPaymentDataPassing {
    weak var viewController: UIViewController?
    var dataStore: PNEditPaymentDataStore?

    // Notes: Here we only pass data bacause we are not override backButtonItem in navigationBar, so the navigation will just be done by system.
    func routeBackToRoom() {
        guard let destination = viewController?.navigationController?.previousViewController() as? PNShowRoomViewController else { return }

        guard let sourceDS = dataStore,
            var destinationDS = destination.router?.dataStore else {
            return
        }
        passDataBackToRoom(source: sourceDS, destination: &destinationDS)
    }
}

// MARK: - Private helper

private extension PNEditPaymentRouter {
    func passDataBackToRoom(source: PNEditPaymentDataStore, destination: inout PNShowRoomDataStore) {
        guard let newPayment = source.payment,
            let updatedPaymentIndex = destination.payments.firstIndex (where: {
                $0.id == newPayment.id
            }) else { return }

        destination.payments[updatedPaymentIndex] = newPayment
    }
}
