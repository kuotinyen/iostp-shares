//
//  PNShowRoomPresenter.swift
//  Payman
//
//  Created by tkuo on 2020/5/4.
//  Copyright © 2020 com.tykuo. All rights reserved.
//

import Foundation

protocol PNShowRoomPresentationLogic {
    func presentPayments(response: PNShowRoom.ShowPayments.Response)
    func presentError(response: PNShowRoom.ShowError.Response)
    func presentAddPayment(response: PNShowRoom.AddPayment.Response)
    func presentRemovePayment(response: PNShowRoom.RemovePayment.Response)
    func presentDutchPayments(response: PNShowRoom.DutchPayments.Response)
}

class PNShowRoomPresenter: PNShowRoomPresentationLogic {
    weak var viewController: PNShowRoomDisplayLogic?

    func presentPayments(response: PNShowRoom.ShowPayments.Response) {
        let paymentViewModels = response.payments.compactMap {
            PaymentViewModel(with: $0,
                             members: response.members,
                             currentMemberId: response.currentMemberId)
        }

        guard let currentMemberIndex = response.members.firstIndex(where: { (member) -> Bool in
            member.id == response.currentMemberId
        }), let currentMemberName = response.members[currentMemberIndex].nickName else { return }

        guard let friendIndex = response.members.firstIndex(where: { (member) -> Bool in
            member.id != response.currentMemberId
        }), let friendName = response.members[friendIndex].nickName else { return }

        var borrowerName: String
        var lenderName: String
        if response.paymentDutchTotal > 0 {
            lenderName = currentMemberName
            borrowerName = friendName
        } else {
            lenderName = friendName
            borrowerName = currentMemberName
        }

        let dutchValue = abs(response.paymentDutchTotal)
        let dutchTitle = "\(borrowerName) owe \(lenderName) $\(dutchValue)."
        let shouldDisplayDutchHeader = (dutchValue != 0.0)
        let viewModel = PNShowRoom.ShowPayments.ViewModel(dutchPaymentTitle: dutchTitle,
                                                          shouldDisplayDutchHeader: shouldDisplayDutchHeader,
                                                          paymentViewModels: paymentViewModels)
        viewController?.displayPayments(viewModel: viewModel)
    }

    func presentError(response: PNShowRoom.ShowError.Response) {
        let viewModel = PNShowRoom.ShowError.ViewModel(errorMessage: response.errorMessage)
        viewController?.displayError(viewModel: viewModel)
    }

    func presentAddPayment(response: PNShowRoom.AddPayment.Response) {
        guard let paymentViewModel = PaymentViewModel(with: response.payment,
                                                      members: response.members, currentMemberId: response.currentMemberId)
            else { return }
        let viewModel = PNShowRoom.AddPayment.ViewModel(paymentViewModel: paymentViewModel)
        viewController?.displayAddPayment(viewModel: viewModel)
    }

    func presentRemovePayment(response: PNShowRoom.RemovePayment.Response) {
        guard let paymentName = response.payment.name else { return }
        let successMessage = "Delete payment \(paymentName) successfully!"
        let viewModel = PNShowRoom.RemovePayment.ViewModel(successMessage: successMessage,
                                                           removeIndex: response.removeIndex)
        viewController?.displayRemovePayment(viewModel: viewModel)
    }

    func presentDutchPayments(response: PNShowRoom.DutchPayments.Response) {
        let viewModel = PNShowRoom.DutchPayments.ViewModel(successMessage: "Dutch all payments successfully!")
        viewController?.displayDutchPayments(viewModel: viewModel)
    }
}

// MARK: - Private helper

extension PaymentViewModel {
    init?(with payment: Payment, members: [Member], currentMemberId: String) {
        guard let payerId = payment.payerId else { return nil }

        var payer: String?
        members.forEach {
            if $0.id == payerId {
                payer = $0.nickName
            }
        }
        payer = "\(payer ?? "Unknown") paid"

        let payType: PayType = currentMemberId == payerId ? .plus : .minus
        let cost: String
        switch payType {
        case .plus: cost = "+ \(payment.cost) NTD"
        case .minus: cost = "- \(payment.cost) NTD"
        }

        self.init(name: payment.name ?? "Unknown",
                  cost: cost,
                  payerName: payer ?? "Unknown",
                  dateString: payment.timestamp.date.display(with: .yyyyMMdd),
                  payType: payType)
    }
}
