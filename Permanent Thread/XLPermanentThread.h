//
//  XLPermanentThread.h
//  Permanent Thread
//
//  Created by XL Yuen on 2018/12/14.
//  Copyright © 2018 XL Yuen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TaskBlock)(void);

@interface XLPermanentThread : NSObject

//- (void)run;

// 添加任务到常驻线程中并执行任务
- (void)excuteTask:(TaskBlock)task;

// 结束常驻线程
- (void)stop;

@end

NS_ASSUME_NONNULL_END
