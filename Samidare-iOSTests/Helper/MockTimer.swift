//
//  MockTimer.swift
//  Samidare-iOSTests
//
//  Created by 杉岡成哉 on 2022/02/05.
//

import Foundation

class MockTimer: Timer {

    var block: ((Timer) -> Void)!
    static var timer: MockTimer?

    static var callCountInvalidate = 0
    static var callCountScheduledTimer = 0

    override func fire() {
        block(self)
    }

    override open class func scheduledTimer(withTimeInterval interval: TimeInterval,
                                            repeats: Bool,
                                            block: @escaping (Timer) -> Void) -> Timer {
        let mockTimer = MockTimer()
        mockTimer.block = block

        MockTimer.timer = mockTimer
        MockTimer.callCountScheduledTimer += 1

        return mockTimer
    }

    override open func invalidate() {
        MockTimer.callCountInvalidate += 1
    }

}
