//
//  PNEditPaymentPresenter.swift.swift
//  Payman
//
//  Created by tkuo on 2020/5/16.
//  Copyright (c) 2020 com.tykuo. All rights reserved.
//

import Foundation

protocol PNEditPaymentPresentationLogic {
    func presentPayment(response: PNEditPayment.FetchPayment.Response)
    func presentEditPayment(response: PNEditPayment.EditPayment.Response)
    func presentError(response: PNEditPayment.ShowError.Response)
}

class PNEditPaymentPresenter: PNEditPaymentPresentationLogic {
    weak var viewController: PNEditPaymentDisplayLogic?

    func presentPayment(response: PNEditPayment.FetchPayment.Response) {
        let name = response.payment.name ?? Constant.UnknownPaymentTitle
        let payerId = response.payment.payerId ?? Constant.UnknownPaymentTitle
        var nickPayerId: String = Constant.UnknownPaymentTitle
        response.members.forEach {
            if $0.id == payerId {
                nickPayerId = $0.nickUserId ?? Constant.UnknownPaymentTitle
            }
        }

        let cost = String(response.payment.cost)
        let dateTime = response.payment.timestamp.date.display(with: .yyyyMMdd)
        let viewModel = PNEditPayment.FetchPayment.ViewModel(name: name,
                                                             payerId: nickPayerId,
                                                             cost: cost,
                                                             dateTime: dateTime)
        viewController?.displayPayment(viewModel: viewModel)
    }

    func presentEditPayment(response: PNEditPayment.EditPayment.Response) {
        let successMessage = "Successfully edit payment \(response.paymentName)!"
        let viewModel = PNEditPayment.EditPayment.ViewModel(successMessage: successMessage)
        viewController?.displayEditPayment(viewModel: viewModel)
    }

    func presentError(response: PNEditPayment.ShowError.Response) {
        let viewModel = PNEditPayment.ShowError.ViewModel(errorMessage: response.errorMessage)
        viewController?.displayError(viewModel: viewModel)
    }
}

// MARK: - Constant

extension PNEditPaymentPresenter {
    private enum Constant {
        static let UnknownPaymentTitle = "Unknown"
    }
}
