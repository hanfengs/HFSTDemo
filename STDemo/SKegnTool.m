//
//  SKegnTool.m
//  STDemo
//
//  Created by hanfeng on 2017/11/28.
//  Copyright © 2017年 hanfeng. All rights reserved.
//

#import "SKegnTool.h"

@implementation SKegnTool

+ (instancetype)shareSKegn{
    
    static SKegnTool *shareSKegn;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        shareSKegn = [[self alloc] init];
        
    });
    return shareSKegn;
}

@end
