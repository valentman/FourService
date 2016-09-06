//
//  FSPageCell.h
//  FourService
//
//  Created by Joe.Pen on 9/6/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSPageCell : CZJTableViewCell
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentView;
- (IBAction)segmentChooseAction:(id)sender;

@end
