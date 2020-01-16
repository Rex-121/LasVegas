//
//  ICSDKResultModel+JSON.h
//  Cattle
//
//  Created by Tyrant on 2020/1/7.
//  Copyright © 2020 Tyrant. All rights reserved.
//

//#import <AppKit/AppKit.h>


#import <ICWalletSDK/ICWalletSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface ICSDKResultModel (JSON)

- (NSData *)jsonData;

@end

NS_ASSUME_NONNULL_END
