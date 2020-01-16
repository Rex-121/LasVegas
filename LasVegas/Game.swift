//
//  Game.swift
//  Cattle
//
//  Created by Tyrant on 2020/1/10.
//  Copyright © 2020 Tyrant. All rights reserved.
//

import Foundation

import ReactiveSwift



final class Game {
    
    static let `default` = Game()
    
    
    let state = MutableProperty(false)
    
    private init() { }
    
    enum Execute {
        case start, end
    }
    
    static func execute(_ to: Execute) {
        switch to {
        case .start:
            GameControl.start()
            Game.default.state.swap(true)
        case .end:
            GameControl.end()
            Game.default.state.swap(false)
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
