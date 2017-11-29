//
//  SKegnTool.h
//  STDemo
//
//  Created by hanfeng on 2017/11/28.
//  Copyright © 2017年 hanfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "airecorder.h"
#include "aiplayer.h"
#include "skegn.h"

typedef void(^result_block)(NSString *);

@interface SKegnTool : NSObject

@property (nonatomic, copy) result_block block_result;

+ (instancetype)shareSKegn;

- (void)initEngine;

- (void)startEngine;
- (void)stopEngine;


@end
