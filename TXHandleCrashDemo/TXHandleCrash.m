//
//  TXHandleCrash.m
//  TXHandleCrashDemo
//
//  Created by txx on 16/11/22.
//  Copyright © 2016年 txx. All rights reserved.
//

#import "TXHandleCrash.h"
#import <objc/runtime.h>
#import "NSDictionary+TXHandleCrash.h"
#import "NSArray+TXHandleCrash.m"

@implementation TXHandleCrash
+(void)startHandle
{
    dispatch_once_t token;
    dispatch_once(&token , ^{
        [NSDictionary handleCrash];
        [NSMutableDictionary handleCrash];
        
        [NSArray handleCrash];
        
        //还可以添加NSMutableArray、NSString、NSMutableString、NSObject、NSAttributedString、NSMutableAttributedString等类的分类，进行处理相关方法。
        //方法类似，不再重写。
        
    });
}
+(void)handleClass:(Class)anClass exchangeClassMethod:(SEL)method1 Method:(SEL)method2
{
    Method mtd1 = class_getClassMethod(anClass, method1);
    Method mtd2 = class_getClassMethod(anClass, method2);
    method_exchangeImplementations(mtd1, mtd2);
}

+(void)handleClass:(Class)anClass exchangeCInstanceMethod:(SEL)method1 Method:(SEL)method2
{
    Method mtd1 = class_getInstanceMethod(anClass, method1);
    Method mtd2 = class_getInstanceMethod(anClass, method2);
    method_exchangeImplementations(mtd1, mtd2);
}

+(void)handleException:(NSException *)exception remark:(NSString *)remark
{
    //堆栈数据
    NSArray *callStackSymbols = [NSThread callStackSymbols];
    
    //获取在哪个类的哪个方法中实例化的数组，并格式化：-[类名 方法名]、+[类名 方法名]
    NSString *locationMsg = [self locationExcptionThroughCallStackSymbols:callStackSymbols];
    if (!locationMsg) {
        locationMsg = @"崩溃位置定位失败，请查看函数调用栈排查错误";
    }
    NSString *exceptionName = exception.name ;
    NSString *exceptionReason = exception.reason ;
    NSString *exceptionLocation = [NSString stringWithFormat:@"exception location:%@",locationMsg];
    NSString *exceptionMsg = [NSString stringWithFormat:@"\n\n%@\n\n%@\n%@\n%@\n%@\n\n%@\n\n",HandleCrashLogBegin, exceptionName, exceptionReason, exceptionLocation, remark, HandleCrashLogEnd];
    NSLog(@"%@", exceptionMsg);

    NSDictionary *exceptionInfoDic = @{
                                   @"exceptionName"        : exceptionName,
                                   @"exceptionReason"      : exceptionReason,
                                   @"exceptionLocation"    : exceptionLocation,
                                   @"remark"               : remark,
                                   @"exception"            : exception,
                                   @"callStackSymbols"     : callStackSymbols
                                   };
    //将错误信息放在字典里，用通知的形式发送出去
    [[NSNotificationCenter defaultCenter] postNotificationName:HandleCrashLogNotification object:nil userInfo:exceptionInfoDic];
}
+(NSString *)locationExcptionThroughCallStackSymbols:(NSArray <NSString *>*)callStackSymbols
{
    __block NSString *locationMsg = nil ;
    
    NSLog(@"callStackSymbols=%@",callStackSymbols);
    //通过正则匹配出的格式为，-[类名 方法名]、+[类名 方法名]
    NSString *regularExpStr = @"[-\\+]\\[.+\\]";
    NSRegularExpression *regularExp = [[NSRegularExpression alloc]initWithPattern:regularExpStr options:NSRegularExpressionCaseInsensitive error:nil];
    for (int index = 2; index <callStackSymbols.count; index++) {
        NSString *callStackSymbol = callStackSymbols[index];
        
        [regularExp enumerateMatchesInString:callStackSymbol options:NSMatchingReportProgress range:NSMakeRange(0, callStackSymbol.length)usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            if (result) {
                NSString *tmpLocationMsg = [callStackSymbol substringWithRange:result.range];
                
                //get class name
                NSString *className = [tmpLocationMsg componentsSeparatedByString:@" "].firstObject;
                className = [className componentsSeparatedByString:@"["].lastObject;
                
                NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(className)];
                
                //filter catalog and system Class
                if (![className hasPrefix:@")"] && bundle == [NSBundle mainBundle]) {
                    locationMsg = tmpLocationMsg ;
                }
                *stop = YES ;
            }
        }];
        if (locationMsg.length) {
            break ;
        }
    }
    
    return locationMsg ;
}

@end
