//
//  FSActivityCell.h
//  FourService
//
//  Created by Joe.Pen on 7/5/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZADScrollerView.h"

@interface FSActivityCell : PBaseTableViewCell<FZADScrollerViewDelegate>{
    NSMutableArray* _imageArray;
}

@property (strong, nonatomic) FZADScrollerView *adScrollerView;
@property (strong, nonatomic) NSMutableArray* activeties;
@property (weak, nonatomic) id<FSImageViewTouchDelegate> delegate;

- (void)someMethodNeedUse:(NSIndexPath *)indexPath DataModel:(NSArray*)array;
@end
