//
//  ViewController.m
//  TXHandleCrashDemo
//
//  Created by txx on 16/11/22.
//  Copyright © 2016年 txx. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *nilStr = nil ;
    NSDictionary *dictionary = @{@"keys":nilStr,@"keys":@"values"};
    NSLog(@"dic=%@",dictionary);
    
    
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
    [mutableDictionary setObject:nilStr forKey:@"keys"];
    [mutableDictionary removeObjectForKey:nilStr];
    
    
    
    
    
    NSArray *array = @[@"chuan",nilStr,@"xia"];
    NSLog(@"array=%@---%@",array,array[100]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
