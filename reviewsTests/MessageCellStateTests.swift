//
//  MessageCellStateTests.swift
//  reviews
//
//  Created by Alessio Borraccino on 15/05/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import RealmSwift
import XCTest
@testable import reviews

class MessageCellStateTests: XCTestCase {

    func testEquality() {

        XCTAssertEqual(MessageCellState.Cached, MessageCellState.Cached)
        XCTAssertNotEqual(MessageCellState.Cached, MessageCellState.Loading)
        XCTAssertEqual(MessageCellState.APIError(message: "hi"), MessageCellState.APIError(message: "hi"))
        XCTAssertNotEqual(MessageCellState.APIError(message: "hi"), MessageCellState.APIError(message: "ho"))
    }

}