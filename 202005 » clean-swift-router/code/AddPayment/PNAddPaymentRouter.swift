//
//  PNAddPaymentRouter.swift
//  Payman
//
//  Created by tkuo on 2020/5/7.
//  Copyright © 2020 com.tykuo. All rights reserved.
//

import UIKit

protocol PNAddPaymentRoutingLogic {
    func routeBackToRoom()
}

protocol PNAddPaymentDataPassing {
    var dataStore: PNAddPaymentDataStore? { get }
}

class PNAddPaymentRouter: PNAddPaymentRoutingLogic, PNAddPaymentDataPassing {
    weak var viewController: UIViewController?
    var dataStore: PNAddPaymentDataStore?

    func routeBackToRoom() {
        guard let sourceDS = dataStore,
            let source = viewController as? PNAddPaymentViewController,
            let destination = source.roomViewController as? PNShowRoomViewController,
            var destinationDS = destination.router?.dataStore else { return }
        passDataBackToRoom(source: sourceDS, destination: &destinationDS)
        navigationBackToRoom(source: source, destination: destination)
    }
}

// MARK: - Private helper

private extension PNAddPaymentRouter {
    func passDataBackToRoom(source: PNAddPaymentDataStore, destination: inout PNShowRoomDataStore) {
        guard let newPayment = source.payment else { return }
        destination.payments.insert(newPayment, at: 0)
        destination.payroom?.paymentIds.insert(newPayment.id, at: 0)
    }

    func navigationBackToRoom(source: UIViewController, destination: UIViewController) {
        source.dismiss(animated: true, completion: nil)
    }
}
