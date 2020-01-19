//
//  WalletBridge.h
//  Cattle
//
//  Created by Tyrant on 2020/1/6.
//  Copyright © 2020 Tyrant. All rights reserved.
//

#import <Foundation/Foundation.h>



#import "ICSDKResultModel+JSON.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WalletDidWantNew) {
    WalletDidWantNewCreate = 0,
    WalletDidWantNewImport = 1
};


@protocol WalletBridgeDelegate <NSObject>

- (void)walletDidNeed;

- (void)makeTransaction:(NSString *)txs success:(NSString *)transactionSuccess failure: (NSString *)transactionFail;

- (NSArray <NSString *>*)getAllWallets;

- (void)newWallet:(WalletDidWantNew)enums keyIfNeeded:(NSString *)key jsCall:(NSString *)jsCall;

- (void)balanceBy:(NSString *)address jsCall:(NSString *)jsCall;

- (void)didCopy:(NSString *)value display:(NSString *)display;

@end


@interface WalletBridge : NSObject

+ (WalletBridge *)manager;

@property (nonatomic, weak)id<WalletBridgeDelegate> delegate;


@property (nonatomic, copy)NSString *currentWalletAddress;

+ (NSString *)getWalletAddress;

+ (void)prepare:(void(^)(ICSDKResultModel * result))results;



+ (ICSDKResultModel *)findAllWallets;

+ (void)balanceByName:(NSString *)name results:(void(^)(ICSDKResultModel * result))result;

/// 获取余额
//+ (void)getBalance:(NSString *)js_callBack;

+ (void)makeATransaction:(NSString *)txs success:(NSString *)transactionSuccess failure: (NSString *)transactionFail;


/// 目前的钱包地址
+ (NSString *)currentWalletAddress;
+ (void)setCurrentWallet:(NSString *)wallet;


+ (void)walletBalanceDidUpdate:(NSString *)balance;


/// js 游戏需要钱包地址
+ (void)GameDidNeedWallet:(NSString *)balance_callBack;

/// js 是否有可用的地址
+ (NSString *)isAnyWalletAvailable;

/// js 用户输入了钱包密钥
+ (void)userDidInputPrivateKey:(NSString *)key callBack:(NSString *)callback;

/// js 获取指定钱包地址的余额
+ (void)requestBalanceByAddress:(NSString *)address callBack:(NSString *)callback;


/// js 需要复制
+ (void)didWannaCopy:(NSString *)value display:(NSString *)display;

@end

NS_ASSUME_NONNULL_END

@interface WalletBridge (Creation)

+ (void)createWallet:(NSString *_Nonnull)name password:(NSString *_Nonnull)password results:(void(^_Nonnull)(ICSDKResultModel * _Nonnull result))results;
+ (void)import:(NSString *_Nonnull)name privateKey:(NSString *_Nonnull)key password:(NSString *_Nonnull)passwor results:(void(^_Nonnull)(ICSDKResultModel * _Nonnull result))results;

@end


@interface JSFunctionCall : NSObject

+ (void)call:(NSString *_Nonnull)function;

@end

