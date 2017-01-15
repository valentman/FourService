//
//  FSMyServiceFeedbackController.m
//  FourService
//
//  Created by Joe.Pen on 7/26/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSMyServiceFeedbackController.h"
#import "CPAddEvaluationPhotoVCell.h"

@interface FSMyServiceFeedbackController ()<UITextViewDelegate,UITextFieldDelegate, CPAddEvaluatePhotoDelegate>
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UITextField *contactTextField;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@property (strong, nonatomic) NSMutableArray *photoPicArray;
@property (strong, nonatomic) CPAddEvaluationPhotoVCell *photoView;
- (IBAction)commitAction:(id)sender;

@end

@implementation FSMyServiceFeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDatas];
    [self initViews];
    [self addCZJNaviBarView:CZJNaviBarViewTypeGeneral];
    NSString *title;
    switch (self.fromType) {
        case FSFeedbackFromTypeFix:
            title = @"维修报修";
            break;
            
        case FSFeedbackFromTypeGeneral:
            title = @"反馈咨询";
            break;
            
        default:
            break;
    }
    self.naviBarView.mainTitleLabel.text = title;
}

- (void)initDatas
{
    self.contentTextView.delegate = self;
    self.contactTextField.delegate = self;
    self.photoPicArray = [NSMutableArray array];
}

- (void)initViews
{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
    leftView.backgroundColor = [UIColor whiteColor];
    self.contactTextField.leftView = leftView;
    self.contactTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.contactTextField.leftView = leftView;
    
    if (self.fromType == FSFeedbackFromTypeFix)
    {
        self.photoView.sd_layout
        .leftSpaceToView(self.view, 15)
        .topSpaceToView(self.contactTextField, 15)
        .rightSpaceToView(self.view, 15)
        .heightIs(80);
    }
}

- (CPAddEvaluationPhotoVCell *)photoView
{
    if (!_photoView) {
        _photoView = [PUtils getXibViewByName:@"CPAddEvaluationPhotoVCell"];
        _photoView.delegate = self;
        _photoView.backgroundColor = WHITECOLOR;
        [self.view addSubview:_photoView];
    }
    return _photoView;
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


- (void)deleteEvaluatePic:(NSString*)url andIndex:(NSIndexPath*)indexP
{
    [self.photoPicArray removeObject:url];
    [self updatePhotoView];
}

- (void)addEvaluatePic:(NSArray*)urls andIndex:(NSIndexPath*)indexP
{
    [self.photoPicArray addObjectsFromArray:urls];
    [self updatePhotoView];
}

- (void)updatePhotoView
{
    [self.photoView setSize_sd:CGSizeMake(PJ_SCREEN_WIDTH - 30, 1 + self.photoPicArray.count/4 * 80)];
    [self.photoView setPicAry:self.photoPicArray];
}
@end
