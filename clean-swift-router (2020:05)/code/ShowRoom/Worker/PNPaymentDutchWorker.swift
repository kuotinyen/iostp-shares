//
//  PNPaymentDutchWorker.swift
//  Payman
//
//  Created by tkuo on 2020/5/17.
//  Copyright © 2020 com.tykuo. All rights reserved.
//

import Foundation

class PNPaymentDutchWorker {
    func calculatePaymentDutchValue(currentMemberId: String, payments: [Payment]) -> Double {
        var total: Double = 0
        for payment in payments {
            if let payerId = payment.payerId, payerId == currentMemberId {
                total += Double(payment.cost)
            } else {
                total -= Double(payment.cost)
            }
        }
        return total
    }
}
