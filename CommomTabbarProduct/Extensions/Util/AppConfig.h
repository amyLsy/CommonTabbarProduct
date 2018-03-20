//
//  AppConfig.h
//  ZhiBoMei
//
//  Created by apple on 2018/3/20.
//  Copyright © 2018年 com.xunyun.zhibomei. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 布局
#define SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height
#define SCALE_WIDTH      ([UIScreen mainScreen].bounds.size.width/375)
#define SCALE_HEIGHT     ([UIScreen mainScreen].bounds.size.height/667)

#pragma mark - 简化代码
#define KWeakSelf              __weak typeof(self) weakSelf = self;
#define KStrongSelf            __strong typeof(weakSelf) strongSelf = weakSelf;
#define iOSSystemVersion(_x)    ([[UIDevice currentDevice].systemVersion doubleValue] >= _x)

#pragma mark - APP配置

/* 包名**/
#define APPPackagename   [[NSBundle mainBundle] bundleIdentifier]
/* 版本号**/
#define APPVersion       [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
/* 版本号**/
#define APPBuild         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]


@interface AppConfig : NSObject

@end
