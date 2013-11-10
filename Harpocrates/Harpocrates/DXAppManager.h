//
//  DXAppManager.h
//  Harpocrates
//
//  Created by 徐 东 on 13-11-7.
//  Copyright (c) 2013年 DeanXu. All rights reserved.
//

#import "DXAppDelegate.h"
@interface DXAppManager : NSObject

+ (instancetype)sharedInstance;

@property (weak,nonatomic) NSManagedObjectContext *pManagedContext;
@property (weak,nonatomic) DXAppDelegate *pAppDelegate;


@end
