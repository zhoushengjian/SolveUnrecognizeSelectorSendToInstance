//
//  ViewController.m
//  消息转发解决方法找不到
//
//  Created by zhoushengjian on 2017/8/13.
//  Copyright © 2017年 zhuanbei. All rights reserved.
//

#import "ViewController.h"
#import <objc/message.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self performSelector:@selector(abc)];
//    [self abc];

}

- (void)sjTest {
    NSLog(@"%s", __func__);
}

@end
