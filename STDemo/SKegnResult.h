//
//  SKegnResult.h
//  STDemo
//
//  Created by hanfeng on 2017/11/30.
//  Copyright © 2017年 hanfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKParams : NSObject

@end

@interface SKegnResult : NSObject

@property (nonatomic, copy) NSString *recordId;
@property (nonatomic, copy) NSString *tokenId;
@property (nonatomic, copy) NSString *applicationId;
@property (nonatomic, copy) NSString *audioUrl;
@property (nonatomic, copy) NSString *dtLastResponse;
@property (nonatomic, copy) NSString *refText;



@end
