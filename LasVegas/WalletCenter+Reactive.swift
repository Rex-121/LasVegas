//
//  WalletCenter+Reactive.swift
//  Cattle
//
//  Created by Tyrant on 2020/1/9.
//  Copyright © 2020 Tyrant. All rights reserved.

import Foundation
import ReactiveSwift
import ReactiveCocoa


extension Reactive where Base: WalletCenter {
    
    
    static func balance(by wallet: String?, coin: String) -> SignalProducer<[CoinBalance], WalletCenter.Wrong> {
        
        return SignalProducer { (observer, lifetime) in
            
            WalletCenter.balance(by: wallet ?? "", coin: coin, balance: { (result) in
                
                switch result {
                case let .success(value): observer.send(value: value)
                case let .failure(error): observer.send(error: error)
                }
                
                observer.sendCompleted()
                
                lifetime.observeEnded {
                    observer.sendCompleted()
                }
                
            })
            
            
        }
        
    }
    
    
    
}
