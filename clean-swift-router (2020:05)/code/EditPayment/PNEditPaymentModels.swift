//
//  PNEditPaymentModels.swift.swift
//  Payman
//
//  Created by tkuo on 2020/5/16.
//  Copyright (c) 2020 com.tykuo. All rights reserved.
//

import Foundation

// MARK: - Model

enum PNEditPayment { }

// MARK: - Use Case

extension PNEditPayment {
    enum FetchPayment {
        struct Request { }

        struct Response {
            let members: [Member]
            let payment: Payment
        }

        struct ViewModel {
            let name: String
            let payerId: String
            let cost: String
            let dateTime: String
        }
    }

    enum EditPayment {
        struct Request {
            let name: String
            let payerId: String
            let cost: String
        }

        struct Response {
            let paymentName: String
        }

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
