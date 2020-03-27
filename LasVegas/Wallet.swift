//
//  Wallet.swift
//  Cattle
//
//  Created by Tyrant on 2020/1/7.
//  Copyright © 2020 Tyrant. All rights reserved.
//

import Foundation

struct Wallet: Codable {
    
    /// 名称
    let name: String
    
    /// 地址
    let address: String
    
    
    private enum CodingKeys: String, CodingKey {
        case name, address, walletAddr
    }
    
    private enum CodingKeysK: String, CodingKey {
        case name, address
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let walletAddr = try container.decodeIfPresent(String.self, forKey: .walletAddr)
        if let add = walletAddr?.nonEmpty {
            self.address = add
        }
        else {
            self.address = try container.decode(String.self, forKey: .address)
        }
        self.name = try container.decode(String.self, forKey: .name)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeysK.self)
        try container.encode(name, forKey: .name)
        try container.encode(address, forKey: .address)
    }
    
}
