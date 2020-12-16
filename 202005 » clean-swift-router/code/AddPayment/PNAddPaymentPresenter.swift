//
//  PNAddPaymentPresenter.swift
//  Payman
//
//  Created by tkuo on 2020/5/7.
//  Copyright © 2020 com.tykuo. All rights reserved.
//

import Foundation

protocol PNAddPaymentPresentationLogic {
    func presentAddPayment(response: PNAddPayment.AddPayment.Response)
    func presentAddPaymentError(response: PNAddPayment.ShowError.Response)
}

class PNAddPaymentPresenter: PNAddPaymentPresentationLogic {
    weak var viewController: PNAddPaymentDisplayLogic?

    func presentAddPayment(response: PNAddPayment.AddPayment.Response) {
        guard let paymentName = response.payment.name else { return }
        let successMessage = "Successfully Add payment \(paymentName)!"
        let viewModel = PNAddPayment.AddPayment.ViewModel(successMessage: successMessage)
        viewController?.displayAddPayment(viewModel: viewModel)
    }

    func presentAddPaymentError(response: PNAddPayment.ShowError.Response) {
        let viewModel = PNAddPayment.ShowError.ViewModel(errorMessage: response.errorMessage)
        viewController?.displayError(viewModel: viewModel)
    }
}
