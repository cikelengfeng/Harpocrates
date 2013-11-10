//
//  DXMasterEncryption.m
//  Harpocrates
//
//  Created by 徐 东 on 13-11-7.
//  Copyright (c) 2013年 DeanXu. All rights reserved.
//

#import "DXMasterEncryption.h"
#import "DXAppManager.h"
#import "DXTpyrcneEntity.h"

@interface DXMasterEncryption (private)

- (NSString *)getMasterPassword;

@end

@implementation DXMasterEncryption

@dynamic masterEncrypted;

static DXMasterEncryption *singleton;

+(instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[DXMasterEncryption alloc]init];
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

- (BOOL)verifyPassword:(NSString *)pd
{
    return [[self getMasterPassword] isEqualToString:pd];
}

- (BOOL)setMasterPassword:(NSString *)pd
{
    DXTpyrcneEntity *entity = [NSEntityDescription insertNewObjectForEntityForName:[DXTpyrcneEntity entityName] inManagedObjectContext:[DXAppManager sharedInstance].pManagedContext];
    entity.aTimeStamp = [NSDate date];
    entity.aKey = @"master";
    entity.aPassword = pd;
    NSError *error = nil;
    if (![[DXAppManager sharedInstance].pManagedContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return NO;
    }
    return YES;
}

- (NSString *)getMasterPassword
{
    NSFetchRequest *req = [[NSFetchRequest alloc]initWithEntityName:[DXTpyrcneEntity entityName]];
    [req setFetchBatchSize:20];
    [req setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"aTimeStamp" ascending:NO]]];
    NSError *error = nil;
    NSArray *pds = [[DXAppManager sharedInstance].pManagedContext executeFetchRequest:req error:&error];
    NSLog(@"first master pd %@",pds.firstObject);
    DXTpyrcneEntity *entity = pds.firstObject;
    NSString *result = entity.aPassword;
    return result;
}

- (BOOL)isMasterEncrypted
{
    return [self getMasterPassword].length > 0;
}

@end
