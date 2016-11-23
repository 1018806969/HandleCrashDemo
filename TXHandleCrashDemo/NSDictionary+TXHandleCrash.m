//
//  NSDictionary+TXHandleCrash.m
//  TXHandleCrashDemo
//
//  Created by txx on 16/11/22.
//  Copyright © 2016年 txx. All rights reserved.
//

#import "NSDictionary+TXHandleCrash.h"
#import "TXHandleCrash.h"

@implementation NSDictionary (TXHandleCrash)
+(void)handleCrash
{
    [TXHandleCrash handleClass:[self class] exchangeClassMethod:@selector(dictionaryWithObjects:forKeys:count:) Method:@selector(handleCrashDictionaryWithObjects:forKeys:count:)];
}
+(instancetype)handleCrashDictionaryWithObjects:(const id  _Nonnull __unsafe_unretained *)objects forKeys:(const id<NSCopying>  _Nonnull __unsafe_unretained *)keys count:(NSUInteger)cnt
{
    id instance = nil ;
    @try {
        instance = [self handleCrashDictionaryWithObjects:objects forKeys:keys count:cnt];
    } @catch (NSException *exception) {
        [TXHandleCrash handleException:exception remark:HandleCrashInsertNil];
        
        NSUInteger index = 0 ;
        id  _Nonnull __unsafe_unretained newObjects[cnt];
        id  _Nonnull __unsafe_unretained newKeys[cnt];
        for (int i = 0 ; i<cnt; i++) {
            if (keys[i] && objects[i]) {
                newObjects[index] = objects[i];
                newKeys[index] = keys[i];
                index ++ ;
            }
        }
        instance = [self handleCrashDictionaryWithObjects:newObjects forKeys:newKeys count:index];

    } @finally {
        return instance ;
    }
}
@end
