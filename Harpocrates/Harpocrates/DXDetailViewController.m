//
//  DXDetailViewController.m
//  Harpocrates
//
//  Created by 徐 东 on 13-11-6.
//  Copyright (c) 2013年 DeanXu. All rights reserved.
//

#import "DXDetailViewController.h"
#import "DXAppManager.h"

#define kPasswordErrorDomain @"password_error"
#define kPasswordFormateErrorCode 0

#define kTitleErrorDomain @"title_error"
#define kTitleFormateErrorCode 0
#define kTitleExistsErrorCode 1

#define kDaemonSignalSaveOK @"0"
#define kDaemonSignalTitleOK @"1"
#define kDaemonSignalPasswordOK @"2"


@interface DXDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *pTitleTextField;
@property (weak, nonatomic) IBOutlet UITextField *pPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *pConfirmButton;
@property (weak, nonatomic) IBOutlet UILabel *pTitleAlertLabel;
@property (weak, nonatomic) IBOutlet UILabel *pPasswordAlertLabel;
@property (weak, nonatomic) IBOutlet UILabel *pSavingAlertLabel;

- (BOOL)isTitleExists:(NSString *)title;
- (BOOL)isTitleFormateValid:(NSString *)title;
- (BOOL)isPasswordFormateValid:(NSString *)pd;
- (BOOL)saveEncryption;

@property (strong) RACSubject *daemonSignal;


@end

@implementation DXDetailViewController

#pragma mark - Managing the detail item

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _daemonSignal = [RACSubject subject];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    RACSignal *detailItem = RACObserve(self,detailItem);
    
    RAC(self,pTitleTextField.text) = [detailItem map:^NSString *(DXEncryptEntity *value) {
        return value.aKey;
    }];
    RAC(self,pPasswordTextField.text) = [detailItem map:^NSString *(DXEncryptEntity *value) {
        return value.aPassword;
    }];
    RACSignal *passwordSignal = [self.pPasswordTextField.rac_textSignal map:^id(id value) {
        @weakify(self);
        BOOL result = [self_weak_ isPasswordFormateValid:value];
        if (!result) {
            [self_weak_.daemonSignal sendNext:[NSError errorWithDomain:kPasswordErrorDomain code:kPasswordFormateErrorCode userInfo:nil]];
        }else {
            [self_weak_.daemonSignal sendNext:kDaemonSignalPasswordOK];
        }
        return @(result);
    }];
    RACSignal *titleSignal = [self.pTitleTextField.rac_textSignal map:^id(id value) {
        @weakify(self);
        BOOL exists = [self_weak_ isTitleExists:value];
        BOOL formate = [self_weak_ isTitleFormateValid:value];
        if (exists) {
            [self_weak_.daemonSignal sendNext:[NSError errorWithDomain:kTitleErrorDomain code:kTitleExistsErrorCode userInfo:nil]];
        }
        if (!formate) {
            [self_weak_.daemonSignal sendNext:[NSError errorWithDomain:kTitleErrorDomain code:kTitleFormateErrorCode userInfo:nil]];
        }
        if (!exists && formate) {
            [self_weak_.daemonSignal sendNext:kDaemonSignalTitleOK];
        }
        return @(!exists && formate);
    }];
    RACSignal *formateValidSiglnal = [RACSignal combineLatest:@[passwordSignal,titleSignal] reduce:^id(NSNumber *pdv,NSNumber *titlev){
        return @([pdv boolValue] && [titlev boolValue]);
    }];
    RAC(self,pConfirmButton.enabled) = formateValidSiglnal;
    [[self.pConfirmButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @weakify(self);
        self_weak_.pConfirmButton.enabled = ![self_weak_ saveEncryption];
    }];
    
    RAC(self,pTitleAlertLabel.text) = [[self.daemonSignal filter:^BOOL(NSError *value) {
        return [value isKindOfClass:[NSError class]] && [value.domain isEqualToString:kTitleErrorDomain];
    }]map:^id(NSError *value) {
        if (value.code == kTitleExistsErrorCode) {
            return @"此标题已存在";
        }else if (value.code == kTitleFormateErrorCode) {
            return @"标题不能为空";
        }else {
            return [value description];
        }
    }];
    
    RAC(self,pPasswordAlertLabel.text) = [[self.daemonSignal filter:^BOOL(NSError *value) {
        return [value isKindOfClass:[NSError class]] && [value.domain isEqualToString:kPasswordErrorDomain];
    }]map:^id(NSError *value) {
        if (value.code == kPasswordFormateErrorCode) {
            return @"密码长度不应少于6位";
        }else {
            return [value description];
        }
    }];
    [[self.daemonSignal filter:^BOOL(id value) {
        return [value isKindOfClass:[NSString class]];
    }]subscribeNext:^(NSString *value) {
        @weakify(self);
        if ([value isEqualToString:kDaemonSignalPasswordOK]) {
            self_weak_.pPasswordAlertLabel.text = @"OK";
        }else if ([value isEqualToString:kDaemonSignalTitleOK]) {
            self_weak_.pTitleAlertLabel.text = @"OK";
        }else if ([value isEqualToString:kDaemonSignalSaveOK]) {
            [self_weak_.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (BOOL)saveEncryption
{
    NSManagedObjectContext *context = [DXAppManager sharedInstance].pManagedContext;
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [self.detailItem setValue:[NSDate date] forKey:@"aTimeStamp"];
    [self.detailItem setValue:self.pTitleTextField.text forKey:@"aKey"];
    [self.detailItem setValue:self.pPasswordTextField.text forKey:@"aPassword"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        [self.daemonSignal sendNext:error];
        return NO;
    }
    [self.daemonSignal sendNext:kDaemonSignalSaveOK];
    return YES;
}

- (BOOL)isTitleExists:(NSString *)title
{
    NSFetchRequest *req = [[NSFetchRequest alloc]initWithEntityName:[DXEncryptEntity entityName]];
    [req setPredicate:[NSPredicate predicateWithFormat:@"self.aKey == %@",title]];
    NSError *error = nil;
    NSArray *result = [[DXAppManager sharedInstance].pManagedContext executeFetchRequest:req error:&error];
    return ![result.firstObject isEqual:self.detailItem] && result.firstObject != nil;
}

- (BOOL)isTitleFormateValid:(NSString *)title
{
    return title.length > 0;
}

- (BOOL)isPasswordFormateValid:(NSString *)pd
{
    return pd.length > 5;
}

- (void)dealloc
{
    [_daemonSignal sendCompleted];
}

@end
