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
        [[SKegnTool shareSKegn] startEngineWithRefText:self.tv_input.text];
    }else{
        [[SKegnTool shareSKegn] stopEngine];
    }
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

@end
