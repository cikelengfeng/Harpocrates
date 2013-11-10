//
//  DXMasterVerifyViewController.m
//  Harpocrates
//
//  Created by 徐 东 on 13-11-6.
//  Copyright (c) 2013年 DeanXu. All rights reserved.
//

#import "DXVerifyMasterEncryptionViewController.h"
#import "DXMasterEncryption.h"

@interface DXVerifyMasterEncryptionViewController ()

@property (weak, nonatomic) IBOutlet UIButton *pConfirmButton;
@property (weak, nonatomic) IBOutlet UITextField *pTextField;
@end

@implementation DXVerifyMasterEncryptionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    RAC(self,pConfirmButton.enabled) = [self.pTextField.rac_textSignal map:^id(NSString *value) {
        return @(value.length >= 6);
    }];
    [[self rac_signalForSelector:@selector(viewDidAppear:)]subscribeNext:^(id x) {
        @weakify(self);
        [self_weak_.pTextField becomeFirstResponder];
    }];
    [[self.pConfirmButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @weakify(self);
        NSString *input = self_weak_.pTextField.text;
        if ([[DXMasterEncryption sharedInstance] verifyPassword:input]) {
            [self_weak_ dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
