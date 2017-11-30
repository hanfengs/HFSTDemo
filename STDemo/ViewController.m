//
//  ViewController.m
//  STDemo
//
//  Created by hanfeng on 2017/11/27.
//  Copyright © 2017年 hanfeng. All rights reserved.
//

#import "ViewController.h"
#import "SKegnTool.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *tv_input;
@property (weak, nonatomic) IBOutlet UITextView *tv_result;
@property (weak, nonatomic) IBOutlet UIButton *btn_record;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment_type;

@property (nonatomic, copy) NSString *result;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btn_record.selected = NO;
    [[SKegnTool shareSKegn] initEngine];
    
    [SKegnTool shareSKegn].block_result = ^(NSString *data) {
        
        self.result = data;
    };
    
}

- (void)setResult:(NSString *)result{
    _result = result;
    
    self.tv_result.text = result;
}

- (IBAction)clickBtn_record:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        NSInteger index = self.segment_type.selectedSegmentIndex;
        switch (index) {
            case 0:
                [[SKegnTool shareSKegn] startEngineWithRefText:self.tv_input.text coreType:CoreType_word_eval];
                break;
            case 1:
                [[SKegnTool shareSKegn] startEngineWithRefText:self.tv_input.text coreType:CoreType_sent_eval];
                break;
                
            default:
                break;
        }

    }else{
        [[SKegnTool shareSKegn] stopEngine];
    }
    
}

- (IBAction)segmentControl:(UISegmentedControl *)sender {
    
    NSInteger index = sender.selectedSegmentIndex;
    switch (index) {
        case 0:
            [self.tv_input setText:@"good"];
            [self.tv_result setText:@"测评结果"];
            
            break;
        case 1:
            [self.tv_input setText:@"where are you from?"];
            [self.tv_result setText:@"测评结果"];
            
            break;
            
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

@end
