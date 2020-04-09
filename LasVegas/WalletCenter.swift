//
//  WalletManager.swift
//  Cattle
//
//  Created by Tyrant on 2020/1/8.
//  Copyright © 2020 Tyrant. All rights reserved.
//

import Foundation

import XKit

import ReactiveSwift

import PKHUD


final class WalletCenter: NSObject {
    
    enum Prepare {
        case ready(Wallet), noWalletExist
    }
    
    static let `default` = WalletCenter()
    
    let ready: Property<Prepare>
    
    private let haveAtLeastOneWallet = MutableProperty<Wallet?>(nil)
    
    let getBalance: Action<String, [CoinBalance], Wrong>
    
    private override init() {
        
        ready = Property(capturing: haveAtLeastOneWallet.map { $0 != nil ? .ready($0!) : .noWalletExist})
        
        getBalance = Action { WalletCenter.reactive.balance(by: $0, coin: "DC") }
        
        super.init()
        
        prepare()
        
        getBalance.values.combineLatest(with: Game.default.state.signal).observeValues { (coins, state) in
            if !state { return }
            guard let v = coins.first(where: { $0.symbol == "DC" }) else { return }
            //            let d = Decimal(string: v.balance) ?? 0
            WalletCenter.balanceDidUpdate(v.balance)
        }
        
        
        //        getBalance <~ ready.producer.compactMap { (prepare) -> Wallet? in
        //            switch prepare {
        //            case .noWalletExist: return nil
        //            case let .ready(wallet): return wallet
        //            }
        //        }
        
        ready.producer.compactMap { (prepare) -> Wallet? in
            switch prepare {
            case .noWalletExist: return nil
            case let .ready(wallet): return wallet
            }
        }.startWithValues { (wallet) in
//            WalletCenter.setCurrent(wallet: wallet)
        }
        
    }
    
    private func prepare() {
        
        
        WalletBridge.manager().delegate = self
        
        WalletCenter.load { [unowned self] in
            //0x5157d97b7c79d0d24ceaccfdbb12061cf265124c8489d805b95c35106407a731
            //            0xc262c71d86be9ca85926441848e5bcc3a6f2025a5d04c2ff011e30b498f4afd8
            //            WalletCenter.create(.init(name: "abcd", password: "aa123456", way: .import(encKey: "0xc262c71d86be9ca85926441848e5bcc3a6f2025a5d04c2ff011e30b498f4afd8"))) { (result) in
            
            let all = WalletCenter.all()
            
            self.haveAtLeastOneWallet.swap(all.first)
            
            //            }
            
            
            
        }
        
    }
    
    typealias CALLBACK<T> = (Result<T, ICSDKResultModel.Wrong>) -> ()
    
    /// 所有钱包
    static func all() -> [Wallet] {
        
        return WalletBridge.findAllWallets().result([Wallet].self).x.success ?? []
        
    }
    
//    static func setCurrent(wallet: Wallet) {
//        WalletBridge.setCurrentWallet(wallet.address)
//    }
    
    static func create(_ create: Create, wallet: @escaping CALLBACK<Wallet>) {
        
        switch create.way {
        case .import(encKey: let key):
            WalletBridge.import(create.name, privateKey: key, password: create.password) { (model) in
                wallet(model.result(Wallet.self))
            }
        case .create:
            WalletBridge.createWallet(create.name, password: create.password) { (model) in
                wallet(model.result(Wallet.self))
            }
        }
        
    }
    
    
    
    static func balance(by wallet: String, coin: String, balance: @escaping CALLBACK<[CoinBalance]>) {
        WalletBridge.balance(byName: wallet) { (model) in
            balance(model.result([CoinBalance].self))
        }
    }
    
    static func load(ready: @escaping () -> ()) {
        WalletBridge.prepare { (model) in
            print(model)
            if model.code == 0 {
                ready()
            }
            else {
                WalletCenter.load(ready: ready)
            }
        }
    }
    
    var balanceDispose: Disposable?
}

extension WalletCenter {
    
    struct Create {
        let name: String
        let password: String
        let way: Way
        enum Way {
            case `import`(encKey: String)
            case create
            
            var functionDes: String {
                switch self {
                case .create: return "创建"
                case .import(encKey: _): return "导入"
                }
            }
        }
    }
    
    struct Wrong: Error, CustomStringConvertible {
        let msg: String?
        var description: String { msg ?? "" }
    }
    
}


extension ICSDKResultModel {
    
    typealias Wrong = WalletCenter.Wrong
    
    var swift_result: Result<Data, Wrong> {
        if self.code == 0 {
            return Result.success(self.jsonData())
        }
        return Result.failure(Wrong(msg: self.msg))
    }
    
    func result<T: Decodable>(_ type: T.Type) -> Result<T, Wrong> {
        if let fail = swift_result.x.failure { return Result.failure(fail) }
        let data = swift_result.x.success ?? Data()
        do {
            return Result.success(try JSONDecoder().decode(type, from: data))
        } catch {
            print(error)
            return Result.failure(Wrong(msg: "解析错误，请联系客服"))
        }
    }
    
}


extension WalletCenter {
    
    static func balanceDidUpdate(_ balance: String) {
        
        WalletBridge.walletBalanceDidUpdate(balance)
        
    }
    
}


extension WalletCenter: WalletBridgeDelegate {
    
    func setSelectedWallet(_ wallet: String) {
        let select = try! JSONDecoder().decode(Wallet.self, from: wallet.data(using: .utf8)!)
        WalletCenter.default.haveAtLeastOneWallet.swap(select)
    }
    
    
    func getSelectedWallet() -> String {
        guard let v = WalletCenter.default.haveAtLeastOneWallet.value else { return "" }
        return JSCall.Value.result(v).parameters
    }
    
    func didCopy(_ value: String, display: String) {
        UIPasteboard.general.string = WalletBridge.manager().currentWalletAddress
        EXHud.show(message: display + "成功")
    }
    
    struct VL: Encodable {
        let address: String
        let balance: String
        let coin: String
    }
    
    /// "DIDRecTypeT"
    func balance(by address: String, coin: String, jsCall: String) {
        
        balanceDispose?.dispose()
        
        //        let aa = address.nonEmpty// ?? WalletBridge.manager().currentWalletAddress
        
        guard let address = address.nonEmpty else {
            let vc = VL(address: "", balance: "0", coin: coin)
            JSCall(mainFunction: jsCall, value: .encodable(vc)).call()
            return
        }
        
        let net = WalletCenter.reactive.balance(by: address, coin: coin)
        
        balanceDispose = net.startWithResult { (result) in
            
            switch result {
            case .success(let coins):
                guard let v = coins.first(where: { $0.symbol == coin }) else { return }
                let vc = VL(address: address, balance: v.balance, coin: coin)
                
                JSCall(mainFunction: jsCall, value: .encodable(vc)).call()
                //                JSFunctionCall.call(js.function)
                
            case .failure(let error):
                EXHud.show(message: error.description)
                JSCall(mainFunction: jsCall, value: .void).call()
            }
            
        }
        
    }
    
    @discardableResult
    func setTheOnlyPassword(_ password: String) -> String {
        
        guard let string = ifThePasswordExists() else {
            
            UserDefaults.standard.setValue(password, forKey: "LasVegas_TheOnlyPassword")
            
            UserDefaults.standard.synchronize()
         
            return password
        }
        
        return string
    }
    
    func ifThePasswordExists() -> String? {
        return UserDefaults.standard.value(forKey: "LasVegas_TheOnlyPassword") as? String
    }
    
    /// 是否需要密码以s创建钱包
    func requirePasswordToCreateWallet() -> Bool {
        guard let password = ifThePasswordExists() else {
            return true
        }
        return password.isEmpty
    }
    
    func doneWithResult(result: Result<Wallet, ICSDKResultModel.Wrong>, password: String, way: Create.Way, jsCall: String) {
        var success = false
        
        switch result {
        case .success(let wallet):
            print("创建", wallet)
            EXHud.show(message: "\(way.functionDes)钱包成功")
            let all = WalletCenter.all()
            
            self.haveAtLeastOneWallet.swap(all.first)
            success = true
            
            /// 存储唯一密码
            setTheOnlyPassword(password)
            
        case .failure(let error):
            EXHud.show(message: error.description.nonEmpty ?? "\(way.functionDes)钱包失败")
        }
        
        JSFunctionCall.call(JSCall(mainFunction: jsCall, value: .result(success)).function)
        
    }
    
    
    func newWallet(_ enums: WalletDidWantNew, name: String, password: String, keyIfNeeded key: String, jsCall: String) {
        
        let thePassword = ifThePasswordExists() ?? password
        
        print("尝试创建钱包", name, thePassword, key)
        
        switch enums {
        case .create:
            WalletCenter.create(.init(name: name, password: thePassword, way: .create)) { [weak self] (result) in
                self?.doneWithResult(result: result, password: thePassword, way: .create, jsCall: jsCall)
            }
        case .import:
            WalletCenter.create(.init(name: name, password: thePassword, way: .import(encKey: key))) { [weak self] (result) in
                self?.doneWithResult(result: result, password: thePassword, way: .import(encKey: key), jsCall: jsCall)
            }
        default: break
        }
        
        
    }
    
    func getAllWallets() -> [String] {
        return WalletCenter.all().map { $0.address }
    }
    
    func allWallets() -> String {
        let all = WalletCenter.all()
        
        let vv = JSCall.Value.result(all)
        print(vv)
        return vv.parameters
    }
    
    
    func walletDidNeed() {
        
    }
    
    struct Hash: Decodable {
        let txHash: String
    }
    
    func makeTransaction(_ txs: String, success transactionSuccess: String, failure transactionFail: String) {
        
        WalletFunction.makeATransaction(txs, address: WalletBridge.manager().currentWalletAddress, password: "aa123456") { (model) in
            let vaul = model.result(Hash.self)
            
            if let success = vaul.successValue() {
                let call = JSCall(mainFunction: transactionSuccess, value: .string(success.txHash))
                JSFunctionCall.call(call.function)
            }
            else if let _ = vaul.x.failure {
                let call = JSCall(mainFunction: transactionFail, value: .string("投注失败"))
                JSFunctionCall.call(call.function)
            }
            
            //            EXHud.show(message: msg)
            
            WalletCenter.default.getBalance.apply(WalletBridge.currentWalletAddress()).start()
        }
        
        
    }
    
    
}

struct WalletResult<T: Encodable>: Encodable {
    let success: Bool
    let value: T
}

struct JSCall {
    
    let mainFunction: String
    
    enum Value {
        
        case void
        
        case bool(Bool)
        
        case string(String)
        
        case encodable(Encodable)
        
        case result(Encodable)
        
        var parameters: String {
            switch self {
            case .void:
                return ""
            case .string(let value):
                return "'\(value)'"
            case .encodable(let encode):
                do {
                    let data = try JSONEncoder().encode(AnyEncodable(encode))
                    let jsonObj = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    
                    let json = try JSONSerialization.data(withJSONObject: jsonObj, options: .fragmentsAllowed)
                    return String(data: json, encoding: .utf8) ?? ""
                }
                catch {
                    return ""
                }
            case .bool(let value):
                return Value.string(value ? "true" : "false").parameters
            case .result(let value):

                let a = JSCall.Value.encodable(value).parameters
                let zz = Value.encodable(WalletResult(success: true, value: a)).parameters
                print(zz)
                return zz
            }
            
        }
    }
    
    let value: Value
    
    
    var function: String {
        return "cc.\(mainFunction)(\(value.parameters));"
    }
    
    func call() {
        JSFunctionCall.call(self.function)
    }
    
}


struct AnyEncodable: Encodable {
    
    private let encodable: Encodable
    
    public init(_ encodable: Encodable) {
        self.encodable = encodable
    }
    
    func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}
