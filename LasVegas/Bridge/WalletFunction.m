//
//  WalletFunction.m
//  Cattle
//
//  Created by Tyrant on 2020/1/13.
//  Copyright © 2020 Tyrant. All rights reserved.
//

#import "WalletFunction.h"

#import <ICWalletSDK/ICWalletSDK.h>

@implementation WalletFunction


+ (void)makeATransaction:(NSString *)txs address:(NSString *)address password:(NSString *)password results:(void(^)(ICSDKResultModel * result))result {

    [[WalletManager manager] walletCommonPay:address version:3 password:password walletCall:txs finish:result];
    
}


@end
