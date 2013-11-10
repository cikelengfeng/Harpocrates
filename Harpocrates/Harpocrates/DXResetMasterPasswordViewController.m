//
//  DXResetMasterPasswordViewController.m
//  Harpocrates
//
//  Created by 徐 东 on 13-11-6.
//  Copyright (c) 2013年 DeanXu. All rights reserved.
//

#import "DXResetMasterPasswordViewController.h"
#import "DXMasterEncryption.h"

@interface DXResetMasterPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *pTextField;
@property (weak, nonatomic) IBOutlet UIButton *pConfirmButton;
@end

@implementation DXResetMasterPasswordViewController

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
	// Do any additional setup after loading the view.
    RAC(self,pConfirmButton.enabled) = [self.pTextField.rac_textSignal map:^id(NSString *value) {
        return @(value.length >= 6);
    }];
    [[self.pConfirmButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @weakify(self);
        if([[DXMasterEncryption sharedInstance]setMasterPassword:self.pTextField.text]) {
            [self_weak_ dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    [[self rac_signalForSelector:@selector(viewDidAppear:)]subscribeNext:^(id x) {
        @weakify(self);
        [self_weak_.pTextField becomeFirstResponder];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
