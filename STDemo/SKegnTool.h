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

@interface SKegnTool : NSObject{
    
    struct airecorder * recorder;
    struct aiplayer * player;
    struct skegn * engine;
}

+ (instancetype)shareSKegn;

@end
