//
//  DiffProgramming.swift
//  work-with-legacy-code-2
//
//  Created by kuotinyen on 2020/3/2.
//  Copyright © 2020 com.tykuo. All rights reserved.
//

import Foundation

enum MailForwaderError: Error {

}

class Message {
    func getFrom() -> [Address]? {
        return []
    }
}

class Session {}
class MimeMessage {
    init(session: Session) {

    }

    func setFrom(_ address: InternetAddress) {

    }
}

class Address {
    var string: String = ""

    func toString() -> String {
        return string
    }
}

class InternetAddress {
    var string: String

    init(_ string: String) {
        self.string = string
    }
}

extension InternetAddress: Equatable {}
func ==(lhs: InternetAddress, rhs: InternetAddress) -> Bool {
    return lhs.string == rhs.string
}

class MailForwarder {

    var defaultFrom: Address = .init()

    func getDomain() -> String {
        return "fakedomain.com"
    }

    func getFromAddress(by message: Message) throws -> InternetAddress {
        let from: [Address]? = message.getFrom()
        if let from = from, from.count > 0 {
            return InternetAddress(from[0].toString())
        }

        return InternetAddress(defaultFrom.toString())
    }

    func forwardMessage(session: Session, message: Message) {
        let forward: MimeMessage = .init(session: session)

        do {
            forward.setFrom(try getFromAddress(by: message))
        } catch {
            // no-op
        }
    }
}
