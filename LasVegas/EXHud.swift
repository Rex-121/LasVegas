//
//  EXHud.swift
//  6xExchange
//
//  Created by daoge on 2019/11/5.
//  Copyright © 2019 6x. All rights reserved.
//

import UIKit
import PKHUD

import ReactiveSwift

final class EXHud {
    
    static let `default` = EXHud()
    
    private init() {
        PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = true
    }

    static func show(message: String?) {
        EXHud.default.show(message)
    }
    
    func show(_ message: String?, _ delay: TimeInterval = 1.5) {
        guard let msg = message?.nonEmpty else { return }
        HUD.flash(.label(msg), delay: delay)
    }
    
}

extension EXHud {
    
    static func show<T>(_ signal: T) where T: SignalProtocol, T.Value: CustomStringConvertible, T.Error == Never {
        EXHud.default.reactive.show <~ signal.signal.map { $0.description }
    }
    
}

extension EXHud: ReactiveExtensionsProvider { }

extension Reactive where Base == EXHud {
    
    var show: BindingTarget<String?> {
        return makeBindingTarget { $0.show($1) }
    }
    
//    var netmare: BindingTarget<Netmare> {
//        return makeBindingTarget { $0.show($1.description) }
//    }
    
}
