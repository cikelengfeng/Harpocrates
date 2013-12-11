//
//  DXDetailViewController.m
//  Harpocrates
//
//  Created by 徐 东 on 13-11-6.
//  Copyright (c) 2013年 DeanXu. All rights reserved.
//

#import "DXDetailViewController.h"
#import "DXAppManager.h"
#import "RFPasswordGenerator.h"

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
@property (weak, nonatomic) IBOutlet UIButton *pCopyPdButton;
@property (weak, nonatomic) IBOutlet UIButton *pGenPdButton;

- (BOOL)isTitleExists:(NSString *)title;
- (BOOL)isTitleFormateValid:(NSString *)title;
- (BOOL)isPasswordFormateValid:(NSString *)pd;
- (BOOL)saveEncryption;
- (void)copyTextToPasteboard:(NSString *)text;

@property (strong) RACSubject *pDaemonSignal;
@property (strong) NSString *pPassword;

@end

@implementation DXDetailViewController

#pragma mark - Managing the detail item

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _pDaemonSignal = [RACSubject subject];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    RACSignal *detailItemSignal = RACObserve(self,detailItem);
    RACSignal *passwordSignal = RACObserve(self,pPassword);
    
    
    RAC(self,pTitleTextField.text) = [detailItemSignal map:^NSString *(DXEncryptEntity *value) {
        return value.aKey;
    }];
    RAC(self,pPasswordTextField.text) = passwordSignal;
    
    RAC(self,pPassword) = [RACSignal merge:@[self.pPasswordTextField.rac_textSignal,[detailItemSignal map:^NSString *(DXEncryptEntity *value) {
        return value.aPassword;
    }],[[self.pGenPdButton rac_signalForControlEvents:UIControlEventTouchUpInside] map:^id(id value) {
        return [RFPasswordGenerator generateHighSecurityPassword];
    }]]];
    
    RACSignal *passwordCheckSignal = [passwordSignal map:^id(id value) {
        @weakify(self);
        BOOL result = [self_weak_ isPasswordFormateValid:value];
        if (!result) {
            [self_weak_.pDaemonSignal sendNext:[NSError errorWithDomain:kPasswordErrorDomain code:kPasswordFormateErrorCode userInfo:nil]];
        }else {
            [self_weak_.pDaemonSignal sendNext:kDaemonSignalPasswordOK];
        }
        return @(result);
    }];
    RACSignal *titleCheckSignal = [self.pTitleTextField.rac_textSignal map:^id(id value) {
        @weakify(self);
        BOOL exists = [self_weak_ isTitleExists:value];
        BOOL formatCorrect = [self_weak_ isTitleFormateValid:value];
        if (exists) {
            [self_weak_.pDaemonSignal sendNext:[NSError errorWithDomain:kTitleErrorDomain code:kTitleExistsErrorCode userInfo:nil]];
        }
        if (!formatCorrect) {
            [self_weak_.pDaemonSignal sendNext:[NSError errorWithDomain:kTitleErrorDomain code:kTitleFormateErrorCode userInfo:nil]];
        }
        if (!exists && formatCorrect) {
            [self_weak_.pDaemonSignal sendNext:kDaemonSignalTitleOK];
        }
        return @(!exists && formatCorrect);
    }];
    RACSignal *formateValidSiglnal = [RACSignal combineLatest:@[passwordCheckSignal,titleCheckSignal] reduce:^id(NSNumber *pdv,NSNumber *titlev){
        return @([pdv boolValue] && [titlev boolValue]);
    }];
    RAC(self,pConfirmButton.enabled) = formateValidSiglnal;
    [[self.pConfirmButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @weakify(self);
        self_weak_.pConfirmButton.enabled = ![self_weak_ saveEncryption];
    }];
    
    RAC(self,pTitleAlertLabel.text) = [[self.pDaemonSignal filter:^BOOL(NSError *value) {
        return [value isKindOfClass:[NSError class]] && [value.domain isEqualToString:kTitleErrorDomain];
    }]map:^id(NSError *value) {
        if (value.code == kTitleExistsErrorCode) {
            return @"title is existed";
        }else if (value.code == kTitleFormateErrorCode) {
            return @"title MUST NOT be empty";
        }else {
            return [value description];
        }
    }];
    
    RAC(self,pPasswordAlertLabel.text) = [[self.pDaemonSignal filter:^BOOL(NSError *value) {
        return [value isKindOfClass:[NSError class]] && [value.domain isEqualToString:kPasswordErrorDomain];
    }]map:^id(NSError *value) {
        if (value.code == kPasswordFormateErrorCode) {
            return @"password MUST NOT be shorter than 6";
        }else {
            return [value description];
        }
    }];
    [[self.pDaemonSignal filter:^BOOL(id value) {
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
    [[self.pCopyPdButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @weakify(self);
        [UIPasteboard generalPasteboard].string = self_weak_.pPasswordTextField.text;
    }];
}

- (BOOL)saveEncryption
{
    NSManagedObjectContext *context = [DXAppManager sharedInstance].pManagedContext;
    
    [self.detailItem setValue:[NSDate date] forKey:@"aTimeStamp"];
    [self.detailItem setValue:self.pTitleTextField.text forKey:@"aKey"];
    [self.detailItem setValue:self.pPassword forKey:@"aPassword"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        [self.pDaemonSignal sendNext:error];
        return NO;
    }
    [self.pDaemonSignal sendNext:kDaemonSignalSaveOK];
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

- (void)copyTextToPasteboard:(NSString *)text
{
    if (text.length > 0) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = text;
    }
}

- (void)dealloc
{
    [_pDaemonSignal sendCompleted];
}

@end
