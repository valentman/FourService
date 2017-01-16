//
//  FSMyServiceFeedbackController.m
//  FourService
//
//  Created by Joe.Pen on 7/26/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSMyServiceFeedbackController.h"
#import "CPAddEvaluationPhotoVCell.h"
#import "FSBaseDataManager.h"

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
        .leftSpaceToView(self.view, 0)
        .topSpaceToView(self.contactTextField, 15)
        .rightSpaceToView(self.view, 0)
        .heightIs(80);
    }
}

- (CPAddEvaluationPhotoVCell *)photoView
{
    if (!_photoView) {
        _photoView = [PUtils getXibViewByName:@"CPAddEvaluationPhotoVCell"];
        _photoView.delegate = self;
        _photoView.backgroundColor = CLEARCOLOR;
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
    switch (self.fromType) {
        case FSFeedbackFromTypeGeneral:
        {
            NSDictionary *params = @{@"image_list" : self.photoPicArray,
                                     @"feedback_type" : @"1",
                                     @"content" : @"'"};
            [FSBaseDataInstance feedBack:params success:^(id json) {
                hud.completionBlock = ^{
                    [PUtils tipWithText:@"感谢反馈" withCompeletHandler:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                };
                [hud hide:YES afterDelay:0];
                
            } fail:^(){
                hud.completionBlock = ^{
                    [PUtils tipWithText:@"反馈失败" withCompeletHandler:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                };
                [hud hide:YES afterDelay:0];
            }];
        }
            break;
            
        case FSFeedbackFromTypeFix:
        {
            NSDictionary *params = @{@"image_list" : self.photoPicArray,
                                     @"shop_id" : @"1",
                                     @"content" : @"'"};
            [FSBaseDataInstance maintainceFeedback:params success:^(id json) {
                hud.completionBlock = ^{
                    [PUtils tipWithText:@"感谢反馈" withCompeletHandler:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                };
                [hud hide:YES afterDelay:0];
                
            } fail:^(){
                hud.completionBlock = ^{
                    [PUtils tipWithText:@"反馈失败" withCompeletHandler:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                };
                [hud hide:YES afterDelay:0];
            }];
        }
            break;
            
        default:
            break;
    }

    
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
    [self.photoView setSize_sd:CGSizeMake(PJ_SCREEN_WIDTH, (1 + self.photoPicArray.count/Divide) * 90)];
    [self.photoView setPicAry:self.photoPicArray];
}
@end
