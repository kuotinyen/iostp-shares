//
//  PNAddPaymentInteractor.swift
//  Payman
//
//  Created by tkuo on 2020/5/7.
//  Copyright © 2020 com.tykuo. All rights reserved.
//

import Foundation

protocol PNAddPaymentBusinessLogic {
    func addPayment(request: PNAddPayment.AddPayment.Request)
}

protocol PNAddPaymentDataStore {
    var payroom: PayRoom? { get set }
    var payment: Payment? { get }
    var members: [Member] { get set }
    var currentMemberId: String? { get set }
}

class PNAddPaymentInteractor: PNAddPaymentBusinessLogic, PNAddPaymentDataStore {
    var payment: Payment?
    var members: [Member] = []
    var payroom: PayRoom?
    var currentMemberId: String?

    var databaseService: FirebaseFireStoreService = .shared
    var payerIdWorker: PNPayerIdWorker = .init()
    var presenter: PNAddPaymentPresentationLogic?

    func addPayment(request: PNAddPayment.AddPayment.Request) {
        guard let payroom = payroom else { return }
        guard let payerId = payerIdWorker.getPayerId(members: members,
                                                     payerNickId: request.payerId) else
        {
            handlePayerIdNotExistInPayroom()
            return
        }

        let uuid = NSUUID().uuidString
        let newPayment = Payment(id: uuid,
                                 name: request.name,
                                 payerId: payerId,
                                 cost: request.cost,
                                 timestamp: Date().timestamp)
        
        databaseService.addPayment(newPayment,
                                   intoRoom: payroom)
        { [weak self] (result) in
            self?.handle(addPaymentResult: result)
        }
    }
}

// MARK: - Private helper

private extension PNAddPaymentInteractor {
    func handle(addPaymentResult result: Result<Payment, Error>) {
        switch result {
        case let .success(payment):
            self.payment = payment
            self.payroom?.paymentIds.insert(payment.id, at: 0)
            let response = PNAddPayment.AddPayment.Response(payment: payment)
            presenter?.presentAddPayment(response: response)
        case let .failure(error):
            let response = PNAddPayment.ShowError.Response(errorMessage: error.localizedDescription)
            presenter?.presentAddPaymentError(response: response)
        }
    }

    func handlePayerIdNotExistInPayroom() {
        let response = PNAddPayment.ShowError.Response(errorMessage: "Payer Id not exist.")
        presenter?.presentAddPaymentError(response: response)
    }
}
