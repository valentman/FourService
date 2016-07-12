//
//  CommonViewControllerDelegate.h
//  FourService
//
//  Created by Joe.Pen on 15/7/30.
//  Copyright (c) 2015年 Joe.Pen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FSViewControllerDelegate <NSObject>

@optional
- (void)didCancel:(id)controller;
- (void)didDone:(id)controller;
- (void)didDone:(id)controller Info:(id)info;
- (void)didDone:(id)controller Text1:(NSString*)text1 Text2:(NSString*)text2 HeadImage:(UIImage*)image;
@end


@protocol FSImageViewTouchDelegate <NSObject>

@optional
- (void)showActivityHtmlWithUrl:(NSString*)url;

- (void)showDetailInfoWithIndex:(NSInteger)index;

- (void)showDetailInfoWithForm:(id)form;

@end


@protocol FSFilterControllerDelegate <NSObject>

@optional
- (void)chooseFilterOK:(id)data;
- (void)chooseGoodFilterOk:(NSArray*)selectAry andData:(id)data;

@end