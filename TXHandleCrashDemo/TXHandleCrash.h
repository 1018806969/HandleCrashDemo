//
//  TXHandleCrash.h
//  TXHandleCrashDemo
//
//  Created by txx on 16/11/22.
//  Copyright © 2016年 txx. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HandleCrashLogBegin @"===========================handleCrashLogBegin==========================="
#define HandleCrashLogEnd @"===============================handleCrash==============================="
#define HandleCrashLogNotification @"HandleCrashLogNotification"

#define HandleCrashReturnNil  @"This framework default is to return nil to avoid crash."
#define HandleCrashInsertNil  @"This framework default is to ignore this operation to avoid crash."


@interface TXHandleCrash : NSObject

/**
 start handle crash
 */
+(void)startHandle;

/**
 exchange class method
 */
+(void)handleClass:(Class)anClass exchangeClassMethod:(SEL)method1 Method:(SEL)method2;

/**
 exchange instance method
 */
+(void)handleClass:(Class)anClass exchangeCInstanceMethod:(SEL)method1 Method:(SEL)method2;


/**
 handle exception
 @param remark remark
 */
+(void)handleException:(NSException *)exception remark:(NSString *)remark;

@end
