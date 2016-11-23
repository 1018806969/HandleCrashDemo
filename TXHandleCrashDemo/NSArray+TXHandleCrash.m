//
//  NSArray+TXHandleCrash.m
//  TXHandleCrashDemo
//
//  Created by txx on 16/11/23.
//  Copyright © 2016年 txx. All rights reserved.
//

#import "NSArray+TXHandleCrash.h"
#import "TXHandleCrash.h"

@implementation NSArray (TXHandleCrash)

+(void)handleCrash
{
     //NSArray的快速创建方式NSArray *array = @[@“value”]，其实是调用如下方法
     //NSArray *array = [NSArray arrayWithObjects:<#(const id  _Nonnull __unsafe_unretained *)#> count:<#(NSUInteger)#>];
    //处理上面的方法
    [TXHandleCrash handleClass:self exchangeClassMethod:@selector(arrayWithObjects:count:) Method:@selector(handleCrashArrayWithObjects:count:)];
    
    [TXHandleCrash handleClass:self exchangeCInstanceMethod:@selector(objectAtIndexedSubscript:) Method:@selector(handleCrashObjectAtIndexedSubscript:)];
}
+ (instancetype)handleCrashArrayWithObjects:(const id  _Nonnull __unsafe_unretained *)objects count:(NSUInteger)cnt
{
    id instance = nil ;
    @try {
        instance = [self handleCrashArrayWithObjects:objects count:cnt];
    } @catch (NSException *exception) {
        [TXHandleCrash handleException:exception remark:HandleCrashInsertNil];
        NSInteger index = 0 ;
        id  _Nonnull __unsafe_unretained newObjects[cnt];
        for (int i = 0; i< cnt; i++) {
            if (objects[i]) {
                newObjects[index] = objects[i];
                index ++;
            }
        }
        instance = [self handleCrashArrayWithObjects:newObjects count:index];
    } @finally {
        return instance; 
    }
}
-(id)handleCrashObjectAtIndexedSubscript:(NSUInteger)idx
{
    id obj = nil ;
    @try {
        obj = [self handleCrashObjectAtIndexedSubscript:idx];
    } @catch (NSException *exception) {
        [TXHandleCrash handleException:exception remark:HandleCrashReturnNil];
    } @finally {
        return obj;
    }
}
@end
