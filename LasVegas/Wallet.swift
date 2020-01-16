//
//  Wallet.swift
//  Cattle
//
//  Created by Tyrant on 2020/1/7.
//  Copyright © 2020 Tyrant. All rights reserved.
//

import Foundation

struct Wallet: Decodable {
    
    /// 名称
    let name: String
    
    /// 地址
    let address: String
    
    
    private enum CodingKeys: String, CodingKey {
        case name, address = "walletAddr"
    }
    
}
