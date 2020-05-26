//
//  PNShowRoomRouter.swift
//  Payman
//
//  Created by tkuo on 2020/5/4.
//  Copyright © 2020 com.tykuo. All rights reserved.
//

import UIKit

protocol PNShowRoomRoutingLogic {
    func routeToAddPayment()
    func routeToEditPayment()
}

protocol PNShowRoomDataPassing {
    var dataStore: PNShowRoomDataStore? { get }
}

class PNShowRoomRouter: PNShowRoomRoutingLogic, PNShowRoomDataPassing {
    weak var viewController: UIViewController?
    var dataStore: PNShowRoomDataStore?

    func routeToAddPayment() {
        guard let sourceDS = dataStore,
            let source = viewController else { return }
        let destination = PNAddPaymentViewController()

        guard var destinationDS = destination.router?.dataStore else { return }
        passDataToAddPayment(source: sourceDS, destination: &destinationDS)
        navigateToAddPayment(source: source, destination: destination)
    }

    func routeToEditPayment() {
        guard var sourceDS = dataStore,
            let source = viewController else { return }
        let destination = PNEditPaymentViewController()

        guard var destinationDS = destination.router?.dataStore else { return }
        passDataToEditPayment(source: &sourceDS, destination: &destinationDS)
        navigateToEditPayment(source: source, destination: destination)
    }
}

// MARK: - Private helper

private extension PNShowRoomRouter {

    // MARK: Edit Payment

    func passDataToEditPayment(source: inout PNShowRoomDataStore, destination: inout PNEditPaymentDataStore) {
        destination.payment = source.selectedPayment
        destination.members = source.members
        source.selectedPayment = nil
    }

    func navigateToEditPayment(source: UIViewController, destination: UIViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }

    // MARK: Add Payment

    func passDataToAddPayment(source: PNShowRoomDataStore, destination: inout PNAddPaymentDataStore) {
        destination.payroom = source.payroom
        destination.members = source.members
    }

    func navigateToAddPayment(source: UIViewController, destination: UIViewController) {
        if let showRoomViewController = source as? PNShowRoomViewController, let addPaymentViewController = destination as? PNAddPaymentViewController {
            addPaymentViewController.roomViewController = showRoomViewController
        }
        let navigationController = UINavigationController(rootViewController: destination)
        navigationController.modalPresentationStyle = .fullScreen
        source.present(navigationController, animated: true, completion: nil)
    }
}
