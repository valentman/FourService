//
//  CPAddEvaluationPhotoVCell.h
//  CityPlus
//
//  Created by Joe.Pen on 9/13/16.
//  Copyright © 2016 JHQC. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol CPAddEvaluatePhotoDelegate <NSObject>
- (void)deleteEvaluatePic:(NSString*)url andIndex:(NSIndexPath*)indexP;;
- (void)addEvaluatePic:(NSArray*)urls andIndex:(NSIndexPath*)indexP;;
@end

@interface CPAddEvaluationPhotoVCell : PBaseTableViewCell
@property (weak, nonatomic) id<CPAddEvaluatePhotoDelegate> delegate;
- (void)setPicAry:(NSArray*)picAry;
@end
