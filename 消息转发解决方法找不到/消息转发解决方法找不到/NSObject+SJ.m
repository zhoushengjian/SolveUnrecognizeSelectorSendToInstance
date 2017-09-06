//
//  NSObject+SJ.m
//  消息转发解决方法找不到
//
//  Created by zhoushengjian on 2017/8/14.
//  Copyright © 2017年 zhuanbei. All rights reserved.
//

#import "NSObject+SJ.h"
#import <objc/message.h>

@interface SJClass : NSObject

@end

@implementation SJClass

- (void)aaa {
    NSLog(@"SJClass: I sovled it");
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    
    class_replaceMethod([self class], sel, class_getMethodImplementation([self class], @selector(aaa)), method_getTypeEncoding(class_getInstanceMethod([self class], @selector(aaa))));
    
    return [super resolveInstanceMethod:sel];
}

//尝试1：这样也行
//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    
//    class_replaceMethod([self class], aSelector, class_getMethodImplementation([self class], @selector(aaa)), method_getTypeEncoding(class_getInstanceMethod([self class], @selector(aaa))));
//    id sup = [super forwardingTargetForSelector:aSelector];
//    return sup;
//}


@end

@implementation NSObject (SJ)

+ (void)load {
    //替换快速转发方法  将消息转发给一个自己的对象  然后重启消息转发 在自己类的转发过程把方法实现加上
//    [self methodChange:@selector(forwardingTargetForSelector:) mySel:@selector(sj_forwardingTargetForSelector:) isIntance:YES];
    
    //尝试2：这样会奔溃  可能会替换掉很多系统的实现 不可取
//    [self methodChange:@selector(resolveInstanceMethod:) mySel:@selector(sj_resolveInstanceMethod:) isIntance:NO];
    
    //尝试3：通过自己的类给方法返回一个签名  让消息走到常规转发 然后实现常规转发方法 吞掉这个消息
    [self methodChange:@selector(methodSignatureForSelector:) mySel:@selector(sj_methodSignatureForSelector:) isIntance:YES];
}


+ (void)bbb {
    NSLog(@"我解决了奔溃，%s", __func__);
}

- (void)replcingSel {
    NSLog(@"我解决了奔溃，%s", __func__);
}


/**
+ (BOOL)sj_resolveInstanceMethod:(SEL)sel {
    
    //    class_replaceMethod([self class], sel, class_getMethodImplementation([self class], @selector(bbb)), method_getTypeEncoding(class_getInstanceMethod([self class], @selector(bbb))));
    
    class_addMethod(self, sel, class_getMethodImplementation(self, @selector(bbb)), method_getTypeEncoding(class_getClassMethod(self, @selector(bbb))));
    
        return YES;
} */

- (id)sj_forwardingTargetForSelector:(SEL)selector {
    
    return [SJClass new];
}

- (NSMethodSignature *)sj_methodSignatureForSelector:(SEL)sel {
    
    return [self sj_methodSignatureForSelector:@selector(replcingSel)];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"消息被吞掉：%s", __func__);
}

+ (void)methodChange:(SEL)originSel mySel:(SEL)mySel isIntance:(BOOL)isInstance {
    
    Method originMethod;
    Method myMethod;
    
    if (isInstance) {
         originMethod = class_getInstanceMethod(self, originSel);
         myMethod     = class_getInstanceMethod(self, mySel);
    }else {
         originMethod = class_getClassMethod([self class], originSel);
         myMethod     = class_getClassMethod([self class], mySel);
    }
    
    BOOL isAdd = class_addMethod([self class], originSel, method_getImplementation(myMethod), method_getTypeEncoding(myMethod));
    
    if (isAdd) {
        class_replaceMethod([self class], mySel, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    }else {
        method_exchangeImplementations(originMethod, myMethod);
    }
}

@end
