//
//  SKegnTool.m
//  STDemo
//
//  Created by hanfeng on 2017/11/28.
//  Copyright © 2017年 hanfeng. All rights reserved.
//

#import "SKegnTool.h"
#import "NSDictionary+JSON.h"

@implementation SKegnTool

+ (instancetype)shareSKegn{
    
    static SKegnTool *shareSKegn;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        shareSKegn = [[self alloc] init];
        
        [shareSKegn initAll];
        
    });
    return shareSKegn;
}

- (void)initAll{
    
    /*
     1;用字典拼出参数
     2；把字典，转换为json
     */
    
    NSString *path = [[NSBundle mainBundle] pathForResource:[[NSString alloc] initWithUTF8String:"skegn.provision"] ofType:NULL];
    
    NSDictionary *para = @{@"appKey":APP_KEY, @"secretKey":SECRET_KEY, @"provision": path, @"cloud":@{@"enable":@1, @"server":SERVER_ADDR}};
    
    NSString *cfg = [para toJSONString];
    engine = skegn_new([cfg UTF8String]);
    
    recorder = airecorder_new();
    player = aiplayer_new();
    
}

@end
