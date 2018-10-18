//
//  StateMachine.swift
//  StateMachine
//
//  Created by Paul Ossenbruggen on 10/16/18.
//  Copyright © 2018 Paul Ossenbruggen. All rights reserved.
//

import Foundation

class CoffeeStateMachine {
    var currentState: State = SystemCheck()
    let states: [String: State]

    init(states types: [State.Type]) {
        self.states = types.reduce(into: [:]) {
            $0[String(describing: $1)] = $1.init()
        }
        self.states.forEach {
            $0.value.stateMachine = self
        }
    }
    
    func enter(state: AnyClass) {
        let previousState = currentState
        if let newState = states[String(describing: state)], newState !== previousState {
            previousState.didExit()
            currentState = newState
            print(currentState)
            currentState.didEnter()
        }
    }
}

protocol State: class, CustomStringConvertible {
    var stateMachine: CoffeeStateMachine? { get set }
    init()
    func didEnter()
    func didExit()
}

class SystemCheck: State {
    weak var stateMachine: CoffeeStateMachine?
    
    var description = String(describing: SystemCheck.self)
    
    required init() {
    }
    
    func didEnter() {
        DispatchQueue.global().asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(3)) {
            let allOK = true
            if allOK {
                self.stateMachine?.enter(state: WaitingState.self)
            } else {
                self.stateMachine?.enter(state: ErrorState.self)
            }
        }
    }
    
    func didExit() {
        // do any cleanup here.
    }
}

class WaitingState: State {
    weak var stateMachine: CoffeeStateMachine?

    var description = String(describing: WaitingState.self)

    required init() {
    }

    func didEnter() {
        // wait for someone to press button.
        DispatchQueue.global().asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(3)) {
            self.stateMachine?.enter(state: FillingState.self)
        }
    }
    
    func didExit() {
    }
    
}

class FillingState: State {
    weak var stateMachine: CoffeeStateMachine?

    var description = String(describing: FillingState.self)

    required init() {
    }

    func didEnter() {
        DispatchQueue.global().asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(3)) {
            
            // wait for filling to complete.
            DispatchQueue.global().asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(3)) {
                let fullSensor = true
                if fullSensor {
                    self.stateMachine?.enter(state: FilledState.self)
                } else {
                    self.stateMachine?.enter(state: ErrorState.self)
                }
            }
        }
    }
    
    func didExit() {
    }
    
}

class FilledState: State {
    weak var stateMachine: CoffeeStateMachine?
    var description = String(describing: FilledState.self)

    required init() {
    }

    func didEnter() {
        DispatchQueue.global().asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(3)) {
            
            // Wait for someone to take coffee.
            DispatchQueue.global().asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(3)) {
                self.stateMachine?.enter(state: SystemCheck.self)
            }
        }
    }
    
    func didExit() {
    }
    
}

class ErrorState: State {
    weak var stateMachine: CoffeeStateMachine?

    var description = String(describing: ErrorState.self)

    required init() {
    }

    func didEnter() {
    }
    
    func didExit() {
    }
    
}


