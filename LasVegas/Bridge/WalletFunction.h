//
//  WalletFunction.h
//  Cattle
//
//  Created by Tyrant on 2020/1/13.
//  Copyright © 2020 Tyrant. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "ICSDKResultModel+JSON.h"


NS_ASSUME_NONNULL_BEGIN

@interface WalletFunction : NSObject



+ (void)makeATransaction:(NSString *)txs address:(NSString *)address password:(NSString *)password results:(void(^)(ICSDKResultModel * result))result;



@end



NS_ASSUME_NONNULL_END
