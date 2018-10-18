//
//  StateMachineTests.swift
//  StateMachineTests
//
//  Created by Paul Ossenbruggen on 10/17/18.
//  Copyright © 2018 Paul Ossenbruggen. All rights reserved.
//

import XCTest
@testable import StateMachine

class StateMachineTests: XCTestCase {

    func testExample() {
        let expectation = self.expectation(description: "wait")
        let states:[State.Type] = [
                      SystemCheck.self,
                      WaitingState.self,
                      FillingState.self,
                      FilledState.self,
                      ErrorState.self]
        let coffeeMachine = CoffeeStateMachine(states: states)
        coffeeMachine.enter(state: SystemCheck.self)
        wait(for: [expectation], timeout: 2000)
    }
}
