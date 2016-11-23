//
//  NSMutableDictionary+TXHandleCrash.m
//  TXHandleCrashDemo
//
//  Created by txx on 16/11/23.
//  Copyright © 2016年 txx. All rights reserved.
//

#import "NSMutableDictionary+TXHandleCrash.h"
#import "TXHandleCrash.h"

@implementation NSMutableDictionary (TXHandleCrash)

+(void)handleCrash
{
    Class dictionaryM = NSClassFromString(@"__NSDictionaryM");
    
    [TXHandleCrash handleClass:dictionaryM exchangeCInstanceMethod:@selector(setObject:forKey:) Method:@selector(handleCrashSetObject:forKey:)];
    
    [TXHandleCrash handleClass:dictionaryM exchangeCInstanceMethod:@selector(removeObjectForKey:) Method:@selector(handleCrashRemoveObjectForKey:)];
}
-(void)handleCrashSetObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    @try {
        [self handleCrashSetObject:anObject forKey:aKey];
    } @catch (NSException *exception) {
        [TXHandleCrash handleException:exception remark:HandleCrashInsertNil];
    } @finally {
        
    }
}
-(void)handleCrashRemoveObjectForKey:(id)aKey
{
    @try {
        [self handleCrashRemoveObjectForKey:aKey];
    } @catch (NSException *exception) {
        [TXHandleCrash handleException:exception remark:HandleCrashInsertNil];
    } @finally {
        
    }
}
@end
