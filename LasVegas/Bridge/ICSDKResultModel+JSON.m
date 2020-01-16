//
//  ICSDKResultModel+JSON.m
//  Cattle
//
//  Created by Tyrant on 2020/1/7.
//  Copyright © 2020 Tyrant. All rights reserved.
//

#import "ICSDKResultModel+JSON.h"

//#import <AppKit/AppKit.h>


@implementation ICSDKResultModel (JSON)

- (NSData *)jsonData {
    return [NSJSONSerialization dataWithJSONObject:self.result options:NSJSONWritingFragmentsAllowed error:nil];
}

@end
