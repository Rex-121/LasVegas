//
//  ViewController.swift
//  LasVegas
//
//  Created by Tyrant on 2020/1/2.
//  Copyright © 2020 Tyrant. All rights reserved.
//

import UIKit

import ReactiveSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        WalletCenter.default.ready.signal.observeValues { (value) in
            print(value)
        }
        
        
//        WalletCenter.load {
//            print(WalletCenter.all())
//            //0xda789c998d0da17a0f99c1e86f12bd05ec3299a942e721a5fd5d3600ed2e8c7e
//
//            WalletCenter.create(.init(name: "abcd", password: "aa123456", way: .import(encKey: "0x5157d97b7c79d0d24ceaccfdbb12061cf265124c8489d805b95c35106407a731"))) { (result) in
//                print(result)
//                print(WalletCenter.all())
//                let first = WalletCenter.all().first!
//                WalletCenter.setCurrent(wallet: first)
//                WalletCenter.balance(by: first.address) { (value) in
//                    print(value)
//                }
//            }
//
//
//
//
//        }
//
        
        
    }

    
    @IBAction func ss() {
        
        present(RootViewController(), animated: true, completion: nil)
        
        Game.execute(.start)
    }

}

