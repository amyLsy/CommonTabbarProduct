//
//  CommomUIUtils.m
//  
//
//  Created by LuuuSY on 2018/3/20.
//  Copyright © 2018年 LuuuSY. All rights reserved.
//

#import "CommomUIUtils.h"

@implementation CommomUIUtils


+(UIStoryboard *)getStoryBoard:(NSString *)sbName {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:sbName bundle:nil];
    return storyboard;
}

@end
