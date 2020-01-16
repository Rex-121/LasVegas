//
//  WalletBridge.m
//  Cattle
//
//  Created by Tyrant on 2020/1/6.
//  Copyright © 2020 Tyrant. All rights reserved.
//

#import "WalletBridge.h"

#import <ICWalletSDK/ICWalletSDK.h>

#import "cocos2d.h"

#include "scripting/js-bindings/jswrapper/SeApi.h"

static WalletBridge *manager = nil;

@implementation WalletBridge

+ (WalletBridge *)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

+ (void)load {
    [WalletBridge config];
}

+ (void)config {
    [[WalletManager manager] setWalletChain:@"yy"];
    [[WalletManager manager] setWalletDebug:ICRunType_Develop OTCDebug:ICRunType_Develop];
    
}

+ (void)prepare:(void (^)(ICSDKResultModel * _Nonnull))results {
    [[WalletManager manager] loadAllChainsFinish:results];
}



+ (ICSDKResultModel *)findAllWallets {
    ICSDKResultModel *v = [[WalletManager manager] getWallets];
    return v;
}

+ (void)balanceByName:(NSString *)name results:(nonnull void (^)(ICSDKResultModel * _Nonnull))result {
    [[WalletManager manager] getAddrsBalance:name legalSymbol:@"CNY" finish:^(ICSDKResultModel *r) {
        result(r);
    }];
}

+ (NSString *)getWalletAddress {
    
    
    
//    ScriptCode::getInstance()->evalString("");

    return @"address";
    
}

+ (NSString *)isAnyWalletAvailable {
    WalletBridge *bridge = [WalletBridge manager];

    if ((bridge.delegate != nil) && ([bridge.delegate respondsToSelector:@selector(getAllWallets)])) {
        NSArray <NSString *>*value = [bridge.delegate getAllWallets];
        if ([value count] >= 1) {
            return value.firstObject;
        }
    }
    return @"";
}

+ (void)requestBalanceByAddress:(NSString *)address callBack:(NSString *)callback {
    WalletBridge *bridge = [WalletBridge manager];

    if ((bridge.delegate != nil) && ([bridge.delegate respondsToSelector:@selector(balanceBy:jsCall:)])) {
        [bridge.delegate balanceBy:address jsCall:callback];
    }
}

+ (void)makeATransaction:(NSString *)txs success:(NSString *)transactionSuccess failure: (NSString *)transactionFail {
    
    WalletBridge *bridge = [WalletBridge manager];
    
    if ((bridge.delegate != nil) && ([bridge.delegate respondsToSelector:@selector(makeTransaction:success:failure:)])) {
        [bridge.delegate makeTransaction:txs success:transactionSuccess failure:transactionFail];
    }
    
//    [[WalletManager manager] walletCommonPay:[[WalletBridge bridge] currentWalletAddress] version:3 password:@"aa123456" walletCall:txs finish:^(ICSDKResultModel *result) {
//        NSLog(@"%@", result);
//
//        if (result.code == 0) {
//
//            NSData *data = [NSJSONSerialization dataWithJSONObject:result.result options:(NSJSONWritingFragmentsAllowed) error:nil];
//
//            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//
//                std::string vRet = [@"D9774BA54CD4D0DFF8F32A5D1164F01120B37905B6E07DD125A84065EE84450B" UTF8String];
//
////                std::string jsCallStr = cocos2d::StringUtils::format("cc.wallet.callBack(\"%s\");", vRet.c_str());
//
//            std::string jsCallStr = cocos2d::StringUtils::format("cc.%s(\"%s\");", [transactionSuccess UTF8String], vRet.c_str());
//            se::ScriptEngine::getInstance()->evalString(jsCallStr.c_str());
//
//        }
//
//    }];
    
}

+ (NSString *)currentWalletAddress {
    
    return [[WalletBridge manager] currentWalletAddress];
    
}
+ (void)setCurrentWallet:(NSString *)wallet {
    [WalletBridge manager].currentWalletAddress = wallet;
}


+ (void)userDidInputPrivateKey:(NSString *)key callBack:(NSString *)callback {
    
    WalletBridge *bridge = [WalletBridge manager];
    
    if ((bridge.delegate != nil) && ([bridge.delegate respondsToSelector:@selector(newWallet:keyIfNeeded:jsCall:)])) {
        [bridge.delegate newWallet:WalletDidWantNewImport keyIfNeeded:key jsCall:callback];
    }
    
    
}

+ (void)walletBalanceDidUpdate:(NSString *)balance {
    std::string jsCallStr = cocos2d::StringUtils::format("cc.WalletBalanceDidUpdate(\"%s\");", [balance UTF8String]);
    se::ScriptEngine::getInstance()->evalString(jsCallStr.c_str());
}

+ (void)GameDidNeedWallet:(NSString *)balance_callBack {
    
    WalletBridge *bridge = [WalletBridge manager];
    
    if ((bridge.delegate != nil) && ([bridge.delegate respondsToSelector:@selector(walletDidNeed)])) {
        [bridge.delegate walletDidNeed];
    }
    
}


@end



@implementation WalletBridge (Creation)

+ (void)createWallet:(NSString *)name password:(NSString *)password results:(void(^)(ICSDKResultModel * result))results {
        
    [[WalletManager manager] createWallet:name password:password recommend:@"" finish:^(ICSDKResultModel *result) {
        results(result);
    }];
    
}
+ (void)import:(NSString *)name privateKey:(NSString *)key password:(NSString *)passwor results:(void(^)(ICSDKResultModel * result))results {
    
    
    [[WalletManager manager] importPrivateKey:name key:key password:passwor recommend:@"" finish:^(ICSDKResultModel *result) {
        results(result);
    }];
    
}


@end


@implementation JSFunctionCall

+ (void)call:(NSString *)function {
    
//    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//
//    std::string vRet = [@"D9774BA54CD4D0DFF8F32A5D1164F01120B37905B6E07DD125A84065EE84450B" UTF8String];
        
    NSLog(@"call----%@", function);
    
    std::string jsCallStr = cocos2d::StringUtils::format("%s", [function UTF8String]);
    se::ScriptEngine::getInstance()->evalString(jsCallStr.c_str());
    
    
}

@end
