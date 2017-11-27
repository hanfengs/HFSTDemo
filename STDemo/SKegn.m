//
//  SKegn.m
//  STDemo
//
//  Created by hanfeng on 2017/11/27.
//  Copyright © 2017年 hanfeng. All rights reserved.
//

#import "SKegn.h"

@implementation SKegn

+ (instancetype)shareSKegn{
    
    static SKegn *shareSKegn;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        shareSKegn = [[self alloc] init];
        
    });
    return shareSKegn;
}

@end
