//
//  XLPermanentThread.m
//  Permanent Thread
//
//  Created by XL Yuen on 2018/12/14.
//  Copyright © 2018 XL Yuen. All rights reserved.
//

#import "XLPermanentThread.h"

/*
 * XLThread
 */

@interface XLThread : NSThread

@end

@implementation XLThread

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

@end

/*
 * XLPermanentThread
 */

@interface XLPermanentThread ()

@property (nonatomic, strong) XLThread *innerThread;
@property (nonatomic, assign) BOOL stopped;

@end


@implementation XLPermanentThread

#pragma mark - public
- (instancetype)init
{
    if (self = [super init]) {
        [self __open]; // 创建一个线程，并开启线程
    }
    return self;
}

//- (void)run
//{
//    if (!self.innerThread) return;
//    [self.innerThread start];
//}

- (void)excuteTask:(TaskBlock)task
{
    if (!self.innerThread || !task) return;
    [self performSelector:@selector(__excuteTask:) onThread:self.innerThread withObject:task waitUntilDone:NO];
}

- (void)stop
{
    if (!self.innerThread) return;
    [self performSelector:@selector(__stop) onThread:self.innerThread withObject:nil waitUntilDone:YES];
}

#pragma mark - private

- (void)__open {
    //        __weak typeof(self)weakSelf = self;
    self.innerThread = [[XLThread alloc] initWithBlock:^{
        NSLog(@"begin -- %s", __func__);
        
        /*
         //1.使用 OC 语法创建 runloop
         [[NSRunLoop currentRunLoop] addPort:[NSPort new] forMode:NSDefaultRunLoopMode];
         
         while (weakSelf && !weakSelf.stopped) {
         [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
         }
         */
        
        //2.使用 C 语言创建 runloop
        CFRunLoopSourceContext context = { 0 };
        
        CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
        CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
        CFRelease(source);
        
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, false);
        
        /*
         // 第三个参数：returnAfterSourceHandled，设置为 true，代表执行完 source 后就会退出当前 loop
         while (weakSelf && !weakSelf.stopped) {
         [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
         }
         */
        
        NSLog(@"end -- %s", __func__);
    }];
    [self.innerThread start];
}

- (void)__excuteTask:(TaskBlock)task
{
    task();
}

- (void)__stop
{
    //    self.stopped = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.innerThread = nil;
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
    [self stop];
}

@end
