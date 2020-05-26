//
//  PNShowRoomInteractor.swift
//  Payman
//
//  Created by tkuo on 2020/5/4.
//  Copyright © 2020 com.tykuo. All rights reserved.
//

import Foundation

protocol PNShowRoomBusinessLogic {
    func fetchRoom(request: PNShowRoom.FetchRoom.Request)
    func refreshRoom(request: PNShowRoom.RefreshRoom.Request)
    func removePayment(request: PNShowRoom.RemovePayment.Request)
    func selectPayment(request: PNShowRoom.SelectPayment.Request)
    func dutchPayments(request: PNShowRoom.DutchPayments.Request)
}

protocol PNShowRoomDataStore {
    var currentMember: Member? { get set }
    var friend: Member? { get set }
    var payroom: PayRoom? { get set }
    var payments: [Payment] { get set }
    var members: [Member] { get set }
    var selectedPayment: Payment? { get set }
}

class PNShowRoomInteractor: PNShowRoomBusinessLogic, PNShowRoomDataStore {
    var memberIds: [String] {
        return members.map { $0.id }
    }

    lazy var members: [Member] = {
        return [self.currentMember, self.friend].compactMap { $0 }
    }()

    var payroom: PayRoom?
    var payments: [Payment] = []
    var currentMember: Member?
    var friend: Member?

    private var shouldRefreshPayments: Bool = false
    var selectedPayment: Payment?

    var presenter: PNShowRoomPresentationLogic?
    var dutchWorker: PNPaymentDutchWorker = .init()
    var databaseService: FirebaseFireStoreService = .shared

    func fetchRoom(request: PNShowRoom.FetchRoom.Request) {
        shouldRefreshPayments = false
        databaseService.getAll(PayRoom.self) { [weak self] (result) in
            self?.handle(fetchRoomResult: result)
        }
    }

    func refreshRoom(request: PNShowRoom.RefreshRoom.Request) {
        guard shouldRefreshPayments else { return }
        guard let currentMemberId = currentMember?.id else { return }
        let dutchTotal = dutchWorker.calculatePaymentDutchValue(currentMemberId: currentMemberId,
                                                                payments: payments)
        let response = PNShowRoom.ShowPayments.Response(payments: payments,
                                                        members: members,
                                                        currentMemberId: currentMemberId,
                                                        paymentDutchTotal: dutchTotal)
        presenter?.presentPayments(response: response)
    }

    func removePayment(request: PNShowRoom.RemovePayment.Request) {
        let selectedIndex = request.selectedIndex
        let payment = payments[selectedIndex]
        guard let payroom = payroom else { return }
        databaseService.deletePayment(payment, payroom: payroom) { [weak self] (result) in
            switch result {
            case .success:
                self?.payments.remove(at: request.selectedIndex)
                self?.payroom?.paymentIds.remove(at: request.selectedIndex)
                let response = PNShowRoom.RemovePayment.Response(payment: payment,
                                                                 removeIndex: selectedIndex)
                self?.presenter?.presentRemovePayment(response: response)
            case let .failure(error):
                let response = PNShowRoom.ShowError.Response(errorMessage: error.localizedDescription)
                self?.presenter?.presentError(response: response)
            }
        }
    }

    func selectPayment(request: PNShowRoom.SelectPayment.Request) {
        let payment = payments[request.selectedIndex]
        selectedPayment = payment
    }

    func dutchPayments(request: PNShowRoom.DutchPayments.Request) {
        guard let payroom = payroom else { return }

        databaseService.dutchPayments(payments, in: payroom) { [weak self] (result) in
            switch result {
            case .success:
                self?.payments.removeAll()
                self?.payroom?.paymentIds.removeAll()
                let response = PNShowRoom.DutchPayments.Response()
                self?.presenter?.presentDutchPayments(response: response)
            case let .failure(error):
                let response = PNShowRoom.ShowError.Response(errorMessage: error.localizedDescription)
                self?.presenter?.presentError(response: response)
            }
        }
    }
}

// MARK: - Fetch Room

extension PNShowRoomInteractor {
    private func handle(fetchRoomResult result: Result<[PayRoom], Error>) {
        defer {
            shouldRefreshPayments = true
        }

        DispatchQueue.main.async {
            switch result {
            case let .success(payRooms):
                if let existPayroom = self.getExistPayRoom(from: payRooms) {
                    self.payroom = existPayroom
                    self.fetchPayments(by: existPayroom) { [weak self] result in
                        self?.handle(fetchPaymentsResult: result)
                    }
                } else {
                    self.createRoom()
                }
            case let .failure(error):
                let response = PNShowRoom.ShowError.Response(errorMessage: error.localizedDescription)
                self.presenter?.presentError(response: response)
            }
        }
    }

    private func getExistPayRoom(from payRooms: [PayRoom]) -> PayRoom? {
        let existPayRoom = payRooms.filter { $0.userIds.containsSameElements(as: memberIds) }.first
        return existPayRoom
    }
}

// MARK: - Create Room if not exist

extension PNShowRoomInteractor {
    private func createRoom() {
        let payRoomId = NSUUID().uuidString
        let payroom = PayRoom(id: payRoomId,
                              name: nil,
                              ownerId: nil,
                              paymentIds: [],
                              userIds: memberIds)
        databaseService.update(payroom) { [weak self] (result) in
            self?.handle(createRoomResult: result, payroom: payroom)
        }
    }

    private func handle(createRoomResult result: FirebaseFireStoreService.UpdateObjectAPIResult, payroom: PayRoom) {
        DispatchQueue.main.async {
            switch result {
            case .success:
                self.payroom = payroom
                self.fetchPayments(by: payroom) { [weak self] result in
                    self?.handle(fetchPaymentsResult: result)
                }
            case let .failure(error):
                let response = PNShowRoom.ShowError.Response(errorMessage: error.localizedDescription)
                self.presenter?.presentError(response: response)
            }
        }
    }
}

// MARK: - Fetch Payments by Room

extension PNShowRoomInteractor {
    typealias FetchPaymentsAPIResult = Result<[Payment], Error>
    typealias FetchPaymentsAPICompletion = (FetchPaymentsAPIResult) -> Void
    private func fetchPayments(by room: PayRoom,
                       then handler: @escaping FetchPaymentsAPICompletion) {
        let paymentIds = room.paymentIds
        databaseService.getAll(Payment.self, ids: paymentIds) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case let .success(thePayments):
                guard let currentMemberId = self.currentMember?.id else { return } // FIXME: Erro Handle
                let payments = thePayments.sorted(by: \.timestamp,
                                                  order: .decreasing)
                self.payments = payments
                let dutchTotal = self.dutchWorker.calculatePaymentDutchValue(currentMemberId: currentMemberId, payments: payments)
                let response = PNShowRoom.ShowPayments.Response(payments: payments,
                                                                members: self.members,
                                                                currentMemberId: currentMemberId,
                                                                paymentDutchTotal: dutchTotal)
                self.presenter?.presentPayments(response: response)
            case let .failure(error):
                let response = PNShowRoom.ShowError.Response(errorMessage: error.localizedDescription)
                self.presenter?.presentError(response: response)
            }
        }
    }

    private func handle(fetchPaymentsResult result: FetchPaymentsAPIResult) {
        switch result {
        case let .success(payments):
            guard let currentMemberId = self.currentMember?.id else { return } // FIXME: Erro Handle
            let dutchTotal = self.dutchWorker.calculatePaymentDutchValue(currentMemberId: currentMemberId, payments: payments)

            let response = PNShowRoom.ShowPayments.Response(payments: payments,
                                                            members: members,
                                                            currentMemberId: currentMemberId,
                                                            paymentDutchTotal: dutchTotal)
            self.presenter?.presentPayments(response: response)
        case let .failure(error):
            let response = PNShowRoom.ShowError.Response(errorMessage: error.localizedDescription)
            self.presenter?.presentError(response: response)
        }
    }
}

// MARK: - Private helpers

private extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}
