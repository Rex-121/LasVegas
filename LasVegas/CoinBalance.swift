//
//  CoinBalance.swift
//  Cattle
//
//  Created by Tyrant on 2020/1/9.
//  Copyright © 2020 Tyrant. All rights reserved.
//

import Foundation


struct CoinBalance: Decodable {
    
    private let idx: Int?
    
    let isToken: Bool?
    
    
//    private let feeInfo: Any?
    
    let symbol: String
    
    let balance: String
    
    
    let address: String
    
    let decimals: String
    
    let coinType: String?
    
    let name: String?
    
    let conAddress: String?
    
    private enum CodingKeys: String, CodingKey {
        case idx, isToken, symbol, balance, address = "addr"
        case decimals, coinType, name, conAddress = "conAddr"
    }
    
}
