//
//  FSMyServiceFeedbackController.m
//  FourService
//
//  Created by Joe.Pen on 7/26/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSMyServiceFeedbackController.h"

@interface FSMyServiceFeedbackController ()<UITextViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UITextField *contactTextField;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
- (IBAction)commitAction:(id)sender;

@end

@implementation FSMyServiceFeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDatas];
    [self initViews];
    [self addCZJNaviBarView:CZJNaviBarViewTypeGeneral];
    self.naviBarView.mainTitleLabel.text = @"反馈咨询";
}

- (void)initDatas
{
    self.contentTextView.delegate = self;
    self.contactTextField.delegate = self;
}

- (void)initViews
{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
    leftView.backgroundColor = [UIColor whiteColor];
    self.contactTextField.leftView = leftView;
    self.contactTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.contactTextField.leftView = leftView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)commitAction:(id)sender
{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.completionBlock = ^{
        [PUtils tipWithText:@"感谢反馈" withCompeletHandler:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    };
    [hud hide:YES afterDelay:1.5];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.promptLabel.hidden = YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [self.commitButton setBackgroundColor:[PUtils isBlankString:text] ? FSDisButtonBG : FSBlue];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.promptLabel.hidden = ![PUtils isBlankString:textView.text];
}
@end
