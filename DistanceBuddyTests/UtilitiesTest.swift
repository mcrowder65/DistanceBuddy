//
//  UtilitiesTest.swift
//
//
//  Created by Matt Crowder on 11/9/19.
//

@testable import DistanceBuddy
import XCTest
class UtilitiesTest: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTextToDate11032019() {
        let text = "11/03/2019"

        let date = textToDate(text)

        XCTAssert(date.year == 2019)
        XCTAssert(date.month == 11)
        XCTAssert(date.day == 3)
    }

    func testTextToDate12312019() {
        let text = "12/31/2019"

        let date = textToDate(text)

        XCTAssert(date.year == 2019)
        XCTAssert(date.month == 12)
        XCTAssert(date.day == 31)
    }

    func testDateToText11032019() {
        let date = Date(year: 2019, month: 11, day: 3, hour: 0, minute: 0)

        let text = dateToText(date)

        XCTAssert(text == "11/03/2019")
    }

    func testDateToText12312019() {
        let date = Date(year: 2019, month: 12, day: 31, hour: 0, minute: 0)

        let text = dateToText(date)

        XCTAssert(text == "12/31/2019")
    }
}
