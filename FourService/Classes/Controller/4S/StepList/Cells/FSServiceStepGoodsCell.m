//
//  FSServiceStepGoodsCell.m
//  FourService
//
//  Created by Joe.Pen on 8/16/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSServiceStepGoodsCell.h"
#import "WLZ_ChangeCountView.h"
#import "BadgeButtonView.h"

@interface FSServiceStepGoodsCell ()
@property (strong, nonatomic) WLZ_ChangeCountView *changeView;
@property(nonatomic,assign)NSInteger choosedCount;
@end

@implementation FSServiceStepGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [self addGestureRecognizer:_swipeLeft];
    self.swipeLeft.delegate = self;
//    self.operateViewLeading.constant = PJ_SCREEN_WIDTH;
    
    BadgeButtonView *deleteBtn = [PUtils getXibViewByName:@"BadgeButtonView"];
    [deleteBtn setSize:CGSizeMake(60, 70)];
    [deleteBtn setPosition:CGPointMake(150, self.size.height*0.5) atAnchorPoint:CGPointMiddle];
    deleteBtn.viewLabel.text = @"删除";
    [deleteBtn.viewBtn setImage:IMAGENAMED(@"productDelete") forState:UIControlStateNormal];
    [deleteBtn.viewBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    BadgeButtonView *changeBtn = [PUtils getXibViewByName:@"BadgeButtonView"];
    [changeBtn setSize:CGSizeMake(60, 70)];
    [changeBtn setPosition:CGPointMake(220, self.size.height*0.5) atAnchorPoint:CGPointMiddle];
    changeBtn.viewLabel.text = @"更换";
    [changeBtn.viewBtn setImage:IMAGENAMED(@"productChange") forState:UIControlStateNormal];
    [changeBtn.viewBtn addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.operateView addSubview:deleteBtn];
    [self.operateView addSubview:changeBtn];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setChooseCount:(NSInteger)chooseCount
{
    self.choosedCount = chooseCount;
    
    if (!self.changeView)
    {
        self.changeView = [[WLZ_ChangeCountView alloc]initWithFrame:CGRectMake(0, 5, 100,35)  totalCount: 99];
        [self.changeView setSize:CGSizeMake(100, 35)];
        [self.changeView setPosition:CGPointMake(10, self.size.height*0.5) atAnchorPoint:CGPointLeftMiddle];
    }
    
    self.changeView.choosedCount =self.choosedCount;
    self.changeView.tag = 998;
    self.changeView.layer.cornerRadius = 3;
    self.changeView.numberFD.text = [NSString stringWithFormat:@"%ld", chooseCount];
    [self.changeView.subButton addTarget:self action:@selector(subButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.changeView.addButton addTarget:self action:@selector(addButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.operateView addSubview:self.changeView];
}

//加
- (void)addButtonPressed:(id)sender
{
    ++self.choosedCount ;
    if (self.choosedCount > 1) {
        _changeView.subButton.enabled=YES;
        _changeView.subButton.titleLabel.alpha = 1.0f;
    }
    
    if(self.choosedCount>=99)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"最多支持99个数量!";
        [hud hide:YES afterDelay:2];
        self.choosedCount  = 99;
        _changeView.addButton.enabled = NO;
        _changeView.addButton.titleLabel.alpha = 0.5f;
    }
    
    _changeView.numberFD.text=[NSString stringWithFormat:@"%zi",self.choosedCount];
    if ([self.delegate respondsToSelector:@selector(updateProductNum:andIndex:)])
    {
        [self.delegate updateProductNum:self.choosedCount andIndex:self.cellIndex];
    }
//    _changeView.choosedCount = self.choosedCount;
//    self.goodsInfoForm.itemCount = _changeView.numberFD.text;
//    self.goodsInfoForm.isSelect=_chooseBtn.selected;
//    [self calculatePriceNumber];
}


//减
- (void)subButtonPressed:(id)sender
{
    --self.choosedCount ;
    
    if (self.choosedCount <= 1) {
        self.choosedCount= 1;
        _changeView.subButton.enabled=NO;
        _changeView.subButton.titleLabel.alpha = 0.5f;
    }
    else
    {
        _changeView.addButton.enabled=YES;
        _changeView.addButton.titleLabel.alpha = 1.0f;
        
    }
    _changeView.numberFD.text=[NSString stringWithFormat:@"%zi",self.choosedCount];
    if ([self.delegate respondsToSelector:@selector(updateProductNum:andIndex:)])
    {
        [self.delegate updateProductNum:self.choosedCount andIndex:self.cellIndex];
    }
//    _changeView.choosedCount = self.choosedCount;
//    self.goodsInfoForm.itemCount = _changeView.numberFD.text;
//    self.goodsInfoForm.isSelect=_chooseBtn.selected;
//    [self calculatePriceNumber];
}

- (void)changeAction:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(changeProduct:)])
    {
        [self.delegate changeProduct:self.cellIndex];
    }
}

- (void)deleteAction:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(deleteProduct:)])
    {
        [self.delegate deleteProduct:self.cellIndex];
    }
}

@end
