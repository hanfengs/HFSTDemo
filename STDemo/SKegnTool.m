//
//  SKegnTool.m
//  STDemo
//
//  Created by hanfeng on 2017/11/28.
//  Copyright © 2017年 hanfeng. All rights reserved.
//

#import "SKegnTool.h"
#import "NSDictionary+JSON.h"
#import <AVFoundation/AVFoundation.h>

@interface SKegnTool (){
    
    struct airecorder * recorder;
    struct aiplayer * player;
    struct skegn * engine;
}

@end

@implementation SKegnTool


static int _skegn_callback(const void *usrdata, const char *id, int type, const void *message, int size){
    
    if (type == SKEGN_MESSAGE_TYPE_JSON) {
        
        
        /* received score result in json formatting */
//        [(__bridge ViewController *)usrdata performSelectorOnMainThread:@selector(showResult:) withObject:[[NSString alloc] initWithUTF8String:(char *)message] waitUntilDone:NO];
        
        NSString *result = [[NSString alloc] initWithUTF8String:(char *)message];
        NSLog(@"%@",result);
        
        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSDictionary *resultDict = [dict objectForKey:@"result"];
        NSString *overall = [resultDict objectForKey:@"overall"];
        NSString *score = [NSString stringWithFormat:@"总分：%@\n", overall];
        
        NSString *res = [dict toReadableJSONString];
        
        SKegnTool *shareTool = (__bridge SKegnTool *)usrdata;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (shareTool.block_result) {                
                shareTool.block_result([score stringByAppendingString:res]);
            }
        });
        
    }
    return 0;
}

static int _recorder_callback(const void * usrdata, const void * data, int size){
    
    printf("feed: %d\n", size);
    return skegn_feed((struct skegn*) usrdata, data, size);
}


+ (instancetype)shareSKegn{
    
    static SKegnTool *shareSKegn;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        shareSKegn = [[self alloc] init];
        
//        [shareSKegn initAll];
        
    });
    return shareSKegn;
}

- (void)initEngine{
    
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

- (void)startEngineWithRefText:(NSString *)refText coreType:(CoreType)type{
    
    NSString *coreType;
    switch (type) {
        case 0:
            coreType = @"word.eval";
            break;
        case 1:
            coreType = @"sent.eval";
            break;
            
        default:
            break;
    }
    int rv = 0;
    
    /*
     "{"coreProvideType":"cloud","app": {"userId": "this-is-user-id"}, "audio": {"audioType": "wav", "sampleRate": 16000, "channel": 1, "sampleBytes": 2}, "request" : {"coreType": "word.eval", "refText": "school", "getParam": 0, "dict_type":"KK", "phoneme_output": 1}}}"
     
     "{"coreProvideType":"cloud","app": {"userId": "this-is-user-id"}, "audio": {"audioType": "wav", "sampleRate": 16000, "channel": 1, "sampleBytes": 2}, "request" : {"coreType": "sent.eval", "refText": "where are you from?", "getParam": 0, "dict_type":"KK", "phoneme_output": 0}}}"

     */
    NSDictionary *para = @{@"coreProvideType":@"cloud", @"app":@{@"userId":@"this-is-user-id"}, @"audio":@{@"audioType":@"wav", @"sampleRate":@16000, @"channel":@1, @"sampleBytes":@2},@"request":@{@"coreType":coreType, @"refText": refText, @"getParam":@1, @"phoneme_output":@1, @"attachAudioUrl":@1}};
    
    NSString *param = [para toJSONString];
//    NSString *requestId = @"1";
    char record_id[64] = {0};
    
    
    rv = skegn_start(engine, [param UTF8String], record_id, (skegn_callback)_skegn_callback, (__bridge const void *)(self));
    
    if (rv) {
        NSLog(@"engine start 失败%d", rv);
        int res = skegn_stop(engine);
        NSLog(@"失败原因%d", res);
        
        return;
    }
    
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    NSString *requestId = [[NSString alloc] initWithCString:record_id encoding:NSUTF8StringEncoding];
    NSString *path = [NSString stringWithFormat:@"%@/Documents/record/%@.wav", NSHomeDirectory(), requestId];
    NSLog(@"=========%@",path);
    
    
    if ((rv = airecorder_start(recorder, [path UTF8String], _recorder_callback, engine, 100)) != 0) {
        
        NSLog(@"airecorder_start 失败%d", rv);
        return;
    }
    
}

- (void)stopEngine{
    
    airecorder_stop(recorder);
    skegn_stop(engine);
    
}

- (void)dealloc{
    
    if (engine) {
        skegn_delete(engine);
        engine = NULL;
    }
    
    if (player) {
        aiplayer_delete(player);
        player = NULL;
    }
    
    if (recorder) {
        airecorder_delete(recorder);
        recorder = NULL;
    }
    
}

#pragma mark-

- (NSString *)overall:(NSDictionary *)dic{
    
    NSDictionary *result = [dic objectForKey:@"result"];
    NSString *overall = [result objectForKey:@"overall"];
    
    return [NSString stringWithFormat:@"总分：%@\n", overall];
}
@end
