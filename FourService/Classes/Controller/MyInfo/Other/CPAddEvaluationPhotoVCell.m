//
//  CPAddEvaluationPhotoVCell.m
//  CityPlus
//
//  Created by Joe.Pen on 9/13/16.
//  Copyright © 2016 JHQC. All rights reserved.
//

#import "CPAddEvaluationPhotoVCell.h"
#import "VPImageCropperViewController.h"
#import "FSDeletableImageView.h"
#import "ZLPhotoActionSheet.h"
#import "FSBaseDataManager.h"
#import "AppDelegate.h"

@interface CPAddEvaluationPhotoVCell ()
<
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
VPImageCropperDelegate
>
@property (weak, nonatomic) IBOutlet UIButton *picBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picBtnLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picBtnTop;
@property (nonatomic, strong) NSArray<ZLSelectPhotoModel *> *lastSelectMoldels;
@property (nonatomic, strong) NSMutableArray *arrDataSources;

- (IBAction)addPicAction:(id)sender;
@end

@implementation CPAddEvaluationPhotoVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPicAry:(NSArray*)picAry
{
    [self.arrDataSources removeAllObjects];
    self.arrDataSources = [picAry mutableCopy];
    [self.contentView removeAllSubViewsExceptView:self.picBtn];
    
    
    for (int i = 0; i < self.arrDataSources.count; i++)
    {
        NSString* imgUrl = self.arrDataSources[i];
        CGRect imageFrame = [PUtils viewFrameFromDynamic:CZJMarginMake(15, 10) size:CGSizeMake(60, 60) index:i divide:Divide subWidth:0];
        FSDeletableImageView* picImage = [[FSDeletableImageView alloc]initWithFrame:imageFrame andImageName:imgUrl];
        picImage.deleteButton.tag = i;
        [picImage.deleteButton addTarget:self action:@selector(picViewDeleteBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:picImage];
    }
    CGRect picBtnFrame = [PUtils viewFrameFromDynamic:CZJMarginMake(15, 10) size:CGSizeMake(60, 60) index:(int)self.arrDataSources.count divide:Divide subWidth:0];
    self.picBtnLeading.constant = picBtnFrame.origin.x;
    self.picBtnTop.constant = picBtnFrame.origin.y;
}

- (IBAction)addPicAction:(id)sender
{
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self];
}


- (void)picViewDeleteBtnHandler:(UIButton*)sender
{
    if ([_delegate respondsToSelector:@selector(deleteEvaluatePic:andIndex:)])
    {
        [_delegate deleteEvaluatePic:self.arrDataSources[sender.tag] andIndex:self.cellIndexPath];
    }
}

#pragma mark- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([PUtils isCameraAvailable] &&
            [PUtils doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([PUtils isRearCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [(UIViewController*)_delegate presentViewController:controller
                                                       animated:YES
                                                     completion:^(void){
                                                         NSLog(@"Picker View Controller is presented");
                                                     }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([PUtils isPhotoLibraryAvailable]) {
            ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
            //设置照片最大选择数
            actionSheet.maxSelectCount = 10;
            //设置照片最大预览数
            actionSheet.maxPreviewCount = 30;
            
            weakSelf(self);
            
            [actionSheet showWithSender:(UIViewController*)_delegate  animate:YES lastSelectPhotoModels:self.lastSelectMoldels completion:^(NSArray<UIImage *> * _Nonnull selectPhotos, NSArray<ZLSelectPhotoModel *> * _Nonnull selectPhotoModels) {
                strongSelf(weakSelf);
                strongSelf.arrDataSources = [selectPhotos mutableCopy];
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:CZJAppdelegate.window animated:YES];
                hud.labelText = @"上传中";
                [FSBaseDataInstance uploadImages:self.arrDataSources param:@{@"imageType" : @"1"} progress:nil success:^(id json) {
                    [hud hide:YES afterDelay:0.5];
                    NSArray* tmpAry = json[kResoponData];
                    NSMutableArray* urls = [NSMutableArray array];
                    for (NSDictionary* dictKey in tmpAry)
                    {
                        [urls addObject:dictKey[@"image_url"]];
                        
                    }
                    if ([_delegate respondsToSelector:@selector(addEvaluatePic:andIndex:)])
                    {
                        [_delegate addEvaluatePic:urls andIndex:self.cellIndexPath];
                    }
                } failure:^{
                    [hud hide:YES afterDelay:0.5];
                }];
            }];
        }
    }
}


#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        //获取从ImagePicker返回来的图像信息生成一个UIImage
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [PUtils imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, ((UIViewController*)_delegate).view.frame.size.width, ((UIViewController*)_delegate).view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [(UIViewController*)_delegate presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}


#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        [FSBaseDataInstance uploadImages:@[editedImage] param:nil progress:nil success:^(id json) {
            iLog(@"%@",[json description]);
            if ([_delegate respondsToSelector:@selector(addEvaluatePic:andIndex:)])
            {
                [_delegate addEvaluatePic:json[kResoponData][@"image1"][@"url"] andIndex:self.cellIndexPath];
            }
        } failure:^{
            
        }];
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
