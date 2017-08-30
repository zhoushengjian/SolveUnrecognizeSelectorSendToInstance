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
    // Do any additional setup after loading the view, typically from a nib.
    
//    for (int i=0; i<100; i++) {
//        @autoreleasepool {
//            NSObject *objc = [NSObject new];
//
//        }
//    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self performSelector:@selector(abc)];
//    [self abc];
    NSLog(@"--------");

    

}


- (void)abc {
    NSLog(@"%s", __func__);
}

//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    
//    if (sel == @selector(aaa)) {
//        class_replaceMethod([self class], @selector(aaa), class_getMethodImplementation([self class], @selector(abc)), method_getTypeEncoding(class_getInstanceMethod([self class], @selector(abc))));
//        NSLog(@"%s", __func__);
//    }
//    
//    return YES;
//}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return [NSObject new];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return nil;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}

@end
