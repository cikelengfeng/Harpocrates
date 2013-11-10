//
//  DXMasterEncryption.h
//  Harpocrates
//
//  Created by 徐 东 on 13-11-7.
//  Copyright (c) 2013年 DeanXu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXMasterEncryption : NSObject

@property (assign,nonatomic,readonly,getter = isMasterEncrypted) BOOL masterEncrypted;

+ (instancetype)sharedInstance;

- (BOOL)verifyPassword:(NSString *)pd;

- (BOOL)setMasterPassword:(NSString *)pd;

@end
