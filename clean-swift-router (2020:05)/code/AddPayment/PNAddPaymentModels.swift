//
//  PNAddPaymentModels.swift
//  Payman
//
//  Created by tkuo on 2020/5/7.
//  Copyright © 2020 com.tykuo. All rights reserved.
//

import Foundation

enum PNAddPayment {
    enum AddPayment {
        struct Request {
            let name: String
            let payerId: String
            let cost: Int
        }

        struct Response {
            let payment: Payment
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
