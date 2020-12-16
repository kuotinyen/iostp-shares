//
//  PNShowRoomModels.swift
//  Payman
//
//  Created by tkuo on 2020/5/4.
//  Copyright © 2020 com.tykuo. All rights reserved.
//

import Foundation

// MARK: - Model

enum PNShowRoom {}

// MARK: - Use Case

extension PNShowRoom {
    enum FetchRoom {
        struct Request { }
    }

    enum RefreshRoom {
        struct Request {}
    }

    enum ShowPayments {
        struct Response {
            let payments: [Payment]
            let members: [Member]
            let currentMemberId: String
            let paymentDutchTotal: Double
        }

        struct ViewModel {
            let dutchPaymentTitle: String
            let shouldDisplayDutchHeader: Bool
            let paymentViewModels: [PaymentViewModel]
        }
    }

    enum AddPayment {
        struct Request {
            let name: String
            let cost: Int
        }

        struct Response {
            let payment: Payment
            let members: [Member]
            let currentMemberId: String
        }

        struct ViewModel {
            let paymentViewModel: PaymentViewModel
        }
    }

    enum RemovePayment {
        struct Request {
            let selectedIndex: Int
        }

        struct Response {
            let payment: Payment
            let removeIndex: Int
        }

        struct ViewModel {
            let successMessage: String
            let removeIndex: Int
        }
    }

    enum SelectPayment {
        struct Request {
            let selectedIndex: Int
        }
    }

    enum DutchPayments {
        struct Request { }
        struct Response { }
        struct ViewModel {
            let successMessage: String
        }
    }

    enum ShowError {
        struct Response {
            let errorMessage: String
        }
        
        struct ViewModel {
            let errorMessage: String
        }
    }
}
