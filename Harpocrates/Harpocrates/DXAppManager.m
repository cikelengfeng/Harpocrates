//
//  DXAppManager.m
//  Harpocrates
//
//  Created by 徐 东 on 13-11-7.
//  Copyright (c) 2013年 DeanXu. All rights reserved.
//

#import "DXAppManager.h"

@implementation DXAppManager

static DXAppManager *singleton;

+(instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[DXAppManager alloc]init];
    });
    return singleton;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [super allocWithZone:zone];
    });
    return singleton;
}

@end
