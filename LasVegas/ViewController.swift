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
    
    @IBOutlet weak var progressView: UIProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Game.execute(.start)
        
        
        let ready = WalletCenter.default.ready.signal
        
        ready.observe(on: UIScheduler()).observeValues { [weak self] (value) in
            print(value)
            
            self?.progressView.progress = 1
            
        }
        
        ready.delay(0.5, on: QueueScheduler.main).take(first: 1).observeValues { [weak self] (_) in
            self?.ss()
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
        
        present(RootViewController(), animated: false, completion: nil)
        
    }

}

