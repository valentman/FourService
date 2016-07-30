//
//  CZJGeneralSubCell.m
//  CZJShop
//
//  Created by Joe.Pen on 1/11/16.
//  Copyright © 2016 JoeP. All rights reserved.
//

#import "CZJGeneralSubCell.h"
#import "BadgeButtonView.h"

@interface CZJGeneralSubCell ()
{
    NSMutableArray* buttons;
    NSMutableArray* titles;
    int cellType;
}
@property (weak, nonatomic) IBOutlet BadgeButton *button1;
@property (weak, nonatomic) IBOutlet BadgeButton *button2;
@property (weak, nonatomic) IBOutlet BadgeButton *button3;
@property (weak, nonatomic) IBOutlet BadgeButton *button4;
@property (weak, nonatomic) IBOutlet BadgeButton *button5;

@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UILabel *title2;
@property (weak, nonatomic) IBOutlet UILabel *title3;
@property (weak, nonatomic) IBOutlet UILabel *title4;
@property (weak, nonatomic) IBOutlet UILabel *title5;

- (IBAction)btnAction:(id)sender;

@end

@implementation CZJGeneralSubCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setGeneralSubCell:(NSArray*)items andType:(int)type
{
    cellType = type;
    for (int i =0; i < items.count; i++)
    {
        NSDictionary* dict = (NSDictionary*)items[i];
        BadgeButtonView* btnView;
        if (!VIEWWITHTAG(self, i + 1000)) {
            btnView = [PUtils getXibViewByName:@"BadgeButtonView"];
            CGRect btnViewRect = [PUtils viewFrameFromDynamic:CZJMarginMake(20, 0) size:CGSizeMake(60, 60) index:i divide:(int)items.count subWidth:0];
            btnView.frame = btnViewRect;
            [self addSubview:btnView];
            [btnView.viewBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            btnView.tag = i + 1000;
            btnView.viewBtn.tag = i + 1;
            btnView.viewLabel.text = [dict valueForKey:@"title"];
        }
        else
        {
            btnView = VIEWWITHTAG(self, i + 1000);
        }
        
        if (type == kCZJGeneralSubCellTypePersonal)
        {
            [btnView.viewBtn setImage:nil forState:UIControlStateNormal];
            [btnView.viewBtn setTitle:[dict valueForKey:@"budge"] forState:UIControlStateNormal];
            [btnView.viewBtn setTitleColor:CZJREDCOLOR forState:UIControlStateNormal];
            btnView.viewBtn.titleLabel.font = BOLDSYSTEMFONT(14);
        }
        if (type == kCZJGeneralSubCellTypeOrder)
        {
            [btnView.viewBtn setBadgeNum:0];
            [btnView.viewBtn setImage:IMAGENAMED([dict valueForKey:@"buttonImage"]) forState:UIControlStateNormal];
            [btnView.viewBtn setBadgeNum:[[dict valueForKey:@"budge"] integerValue]];
            [btnView.viewBtn setBadgeLabelPosition:CGPointMake(btnView.viewBtn.frame.size.width*0.75, btnView.viewBtn.frame.size.height*0.1)];
        }
    }
}

- (IBAction)btnAction:(id)sender
{
    [self.delegate clickSubCellButton:sender andType:cellType];
}
@end
