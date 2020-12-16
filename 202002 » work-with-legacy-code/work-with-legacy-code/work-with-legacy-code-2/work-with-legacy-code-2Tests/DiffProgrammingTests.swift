//
//  DiffProgrammingTests.swift
//  work-with-legacy-code-2Tests
//
//  Created by tkuo on 2020/3/2.
//  Copyright © 2020 com.tykuo. All rights reserved.
//

import Foundation
import XCTest
@testable import work_with_legacy_code_2

class SessionMock: Session {}
class MessageFack: Message {}

class DiffProgrammingTests: XCTestCase {

    func testAnonymous() {
        let forwarder: MailForwarder = .init()
        forwarder.forwardMessage(session: SessionMock(), message: MessageFack())

        let expectation = "anon-members@\(forwarder.getDomain())"

        do {
            let from = try forwarder.getFromAddress(by: MessageFack())


        } catch {
            XCTFail("forwarder can not get address")
        }



//        XCTAssertEqual(forwarder.getFromAddress(by: MessageFack())., expectation)
    }
}

