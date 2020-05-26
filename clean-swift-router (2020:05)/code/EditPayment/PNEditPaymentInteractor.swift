//
//  PNEditPaymentInteractor.swift.swift
//  Payman
//
//  Created by tkuo on 2020/5/16.
//  Copyright (c) 2020 com.tykuo. All rights reserved.
//

import Foundation

protocol PNEditPaymentBusinessLogic {
    func fetchPayment(request: PNEditPayment.FetchPayment.Request)
    func editPayment(request: PNEditPayment.EditPayment.Request)
}

protocol PNEditPaymentDataStore {
    var payment: Payment? { get set }
    var members: [Member] { get set }
}

class PNEditPaymentInteractor: PNEditPaymentBusinessLogic, PNEditPaymentDataStore {
    var editPaymentIndex: Int?
    var members: [Member] = []
    var payment: Payment?

    var databaseService: FirebaseFireStoreService = .shared
    var payerIdWorker: PNPayerIdWorker = .init()
    var presenter: PNEditPaymentPresentationLogic?

    func fetchPayment(request: PNEditPayment.FetchPayment.Request) {
        guard let payment = payment else { return }
        let response = PNEditPayment.FetchPayment.Response(members: members,
                                                           payment: payment)
        presenter?.presentPayment(response: response)
    }

    func editPayment(request: PNEditPayment.EditPayment.Request) {
        payment?.name = request.name
        if let cost = Int(request.cost) {
            payment?.cost = cost
        } else {
            // FIXME: present not a number error, or make textfield only input number.
        }

        guard let payerId = payerIdWorker.getPayerId(members: members,
                                                     payerNickId: request.payerId) else
        {
            let response = PNEditPayment.ShowError.Response(errorMessage: "Payer Id not exist.")
            presenter?.presentError(response: response)
            return
        }
        payment?.payerId = payerId

        guard let payment = payment else { return }
        databaseService.update(payment) { [weak self] (result) in
            self?.handle(editPaymentResult: result, updatedPayment: payment)
        }
    }
}

// MARK: - Private helper

private extension PNEditPaymentInteractor {
    func handle(editPaymentResult result: FirebaseFireStoreService.UpdateObjectAPIResult, updatedPayment: Payment) {
        switch result {
        case .success:
            guard let name = updatedPayment.name else { return }
            let response = PNEditPayment.EditPayment.Response(paymentName: name)
            presenter?.presentEditPayment(response: response)
        case let .failure(error):
            let error = PNEditPayment.ShowError.Response(errorMessage: error.localizedDescription)
            presenter?.presentError(response: error)
        }
    }
}

// MARK: - Constant

extension PNEditPaymentInteractor {
    private enum Constant {
        static let UnknownText = "Unknown"
    }
}
