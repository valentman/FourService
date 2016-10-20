//
//  FSMyMessageCenterController.m
//  FourService
//
//  Created by Joe.Pen on 7/24/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSMyMessageCenterController.h"
#import "FSMessageManager.h"
#import "CZJMyMessageCenterCell.h"
#import "FSButtomView.h"

@interface FSMyMessageCenterController ()
<
UITableViewDelegate,
UITableViewDataSource
>
{
    BOOL isEdit;
    NSMutableArray* messageInfoAry;
    __block FSButtomView* buttomView;
}
@property (strong, nonatomic)UITableView* myTableView;
@end

@implementation FSMyMessageCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDatas];
    [self initViews];
    [self getMessageInfosFromServer];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getMessageInfosFromServer) name:kCZJNotifiGetNewNotify object:nil];;
}

- (void)viewWillAppear:(BOOL)animated
{
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kCZJNotifiGetNewNotify object:nil];
}

- (void)initDatas
{
    messageInfoAry = [NSMutableArray array];
}

- (void)initViews
{
    isEdit = NO;
    [self addCZJNaviBarView:CZJNaviBarViewTypeGeneral];
    self.naviBarView.mainTitleLabel.text = @"消息中心";
    //右按钮
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(PJ_SCREEN_WIDTH - 100 , 0 , 100 , 44 );
    rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [rightBtn setTitle:@"取消" forState:UIControlStateSelected];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [rightBtn setSelected:NO];
    [rightBtn setTag:2999];
    rightBtn.titleLabel.font = SYSTEMFONT(16);
    [self.naviBarView addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    
    //消息中心表格视图
    CGRect tableRect = CGRectMake(0, 64, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT - 64);
    self.myTableView = [[UITableView alloc]initWithFrame:tableRect style:UITableViewStylePlain];
    self.myTableView.tableFooterView = [[UIView alloc]init];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.clipsToBounds = YES;
    self.myTableView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.myTableView];
    
    NSArray* nibArys = @[@"CZJMyMessageCenterCell"];
    
    for (id cells in nibArys)
    {
        UINib *nib=[UINib nibWithNibName:cells bundle:nil];
        [self.myTableView registerNib:nib forCellReuseIdentifier:cells];
    }
    
    
    //底部标记栏
    buttomView = (FSButtomView*)[PUtils getXibViewByName:@"FSButtomView"];
    [buttomView setSize:CGSizeMake(PJ_SCREEN_WIDTH, 60)];
    [buttomView setPosition:CGPointMake(0, PJ_SCREEN_HEIGHT) atAnchorPoint:CGPointZero];
    [self.view addSubview:buttomView];
    [buttomView.allChooseBtn addTarget:self action:@selector(allChooseAction:) forControlEvents:UIControlEventTouchUpInside];
    [buttomView.buttonOne addTarget:self action:@selector(markReadedAction:) forControlEvents:UIControlEventTouchUpInside];
    [buttomView.buttonTwo addTarget:self action:@selector(deleteMessageAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)edit:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    isEdit = !isEdit;
    btn.selected = !btn.selected;
    
    if (messageInfoAry.count <= 0)
        return;
    
    [self setButtomViewShowAnimation:isEdit];
    [self.myTableView reloadData];
}

- (void)getMessageInfosFromServer
{
    BACK(^{
        [FSMessageInstance readMessageFromPlist];
        MAIN(^{
            messageInfoAry = [FSMessageInstance.messages mutableCopy];
            if (messageInfoAry.count > 0)
            {
                buttomView.allChooseBtn.selected = NO;
                buttomView.allChooseBtn.enabled = YES;
                buttomView.buttonOne.enabled = YES;
                buttomView.buttonTwo.enabled = YES;
                [buttomView.buttonOne setBackgroundColor:CZJGREENCOLOR];
                [buttomView.buttonTwo setBackgroundColor:CZJREDCOLOR];
            }
            [self.myTableView reloadData];
        });
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = messageInfoAry.count;
    DLog(@"count:%ld",count);
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSNotificationForm* notifyForm = messageInfoAry[indexPath.row];
    CZJMyMessageCenterCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJMyMessageCenterCell" forIndexPath:indexPath];
    CGSize timeSize = [PUtils calculateStringSizeWithString:notifyForm.time Font:cell.notifyTimeLabel.font Width:280];
    CGSize contentSize = [PUtils calculateStringSizeWithString:notifyForm.msg Font:cell.notifyContentLabel.font Width:PJ_SCREEN_WIDTH - 55];
    cell.storeNameWidth.constant = PJ_SCREEN_WIDTH - 25 - 10 - 15 - timeSize.width;
    cell.notifyTimeLabelWidth.constant = timeSize.width;
    cell.notifyContentHeight.constant = contentSize.height > 20 ? 40 : 20;
    cell.storeNameLabel.text = notifyForm.storeName;
    cell.notifyTimeLabel.text = notifyForm.time;
    cell.notifyContentLabel.text = notifyForm.msg;
    cell.dotLabel.hidden = notifyForm.isRead || isEdit;
    cell.selectBtn.hidden = !isEdit;
    cell.selectBtn.selected = notifyForm.isSelected;
    cell.selectBtn.tag = indexPath.row;
    [cell.selectBtn addTarget:self action:@selector(notifyCellChoose:) forControlEvents:UIControlEventTouchUpInside];
    cell.separatorInset = IndentCellSeparator(10);
    return cell;
}

#pragma mark-UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSNotificationForm* notifyForm = messageInfoAry[indexPath.row];
    CGSize contentSize = [PUtils calculateStringSizeWithString:notifyForm.msg Font:SYSTEMFONT(15) Width:PJ_SCREEN_WIDTH - 55];
    return 80 + (contentSize.height > 20 ? 20 : 0);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!isEdit)
    {
//        FSNotificationForm* notifyForm = messageInfoAry[indexPath.row];
//        if (!notifyForm.isRead)
//        {
//            notifyForm.isRead = YES;
//            [CZJMessageInstance setMessages:messageInfoAry];
//            [[NSNotificationCenter defaultCenter]postNotificationName:kCZJNotifiRefreshMessageReadStatus object:nil];
//            [self.myTableView reloadData];
//        }
//        if (4 == [notifyForm.type integerValue])
//        {
//            CZJMyOrderDetailController* orderDetail = (CZJMyOrderDetailController*)[PUtils getViewControllerFromStoryboard:kCZJStoryBoardFileMain andVCName:@"orderDetailSBID"];
//            orderDetail.orderNo = notifyForm.orderNo;
//            orderDetail.orderDetailType = CZJOrderDetailTypeGeneral;
//            [self.navigationController pushViewController:orderDetail animated:YES];
//            
//        }
    }
    else
    {
        CZJMyMessageCenterCell* chatCell = [tableView cellForRowAtIndexPath:indexPath];
        [self notifyCellChoose:chatCell.selectBtn];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section)
    {
        return 0;
    }
    return 0;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isEdit)
    {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}


-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        FSNotificationForm* notifyForm = messageInfoAry[indexPath.row];
        [messageInfoAry removeObject:notifyForm];
        [PUtils tipWithText:@"删除成功" andView:nil];
        [FSMessageInstance setMessages:messageInfoAry];
        [self.myTableView reloadData];
    }
}


#pragma mark - 按钮点击事件
- (void)notifyCellChoose:(UIButton*)sender
{
    sender.selected = !sender.selected;
    FSNotificationForm* notifyForm = messageInfoAry[sender.tag];
    notifyForm.isSelected = sender.selected;
    
    BOOL isallchoosed = YES;
    for (FSNotificationForm* notifyForm2 in messageInfoAry)
    {
        if (!notifyForm2.isSelected)
        {
            isallchoosed = NO;
            break;
        }
    }
    buttomView.allChooseBtn.selected = isallchoosed;
}

- (void)allChooseAction:(UIButton*)sender
{
    sender.selected = !sender.selected;
    for (FSNotificationForm* notifyForm in messageInfoAry)
    {
        notifyForm.isSelected = sender.selected;
    }
    [self.myTableView reloadData];
}

- (void)markReadedAction:(UIButton*)sender
{
    BOOL isSelected = NO;
    for (FSNotificationForm* notifyForm in messageInfoAry)
    {
        if (notifyForm.isSelected)
        {
            isSelected = YES;
            notifyForm.isRead = YES;
        }
    }
    if (isSelected)
    {
        [self.myTableView reloadData];
        [FSMessageInstance setMessages:messageInfoAry];
        [[NSNotificationCenter defaultCenter]postNotificationName:kCZJNotifiRefreshMessageReadStatus object:nil];
        [PUtils tipWithText:@"标记成功" andView:nil];
    }
    else
    {
        [PUtils tipWithText:@"请选择消息记录" andView:nil];
    }
}

- (void)deleteMessageAction:(UIButton*)sender
{
    __weak typeof(self) weakSelf = self;
    BOOL isSelected = NO;
    NSMutableArray* tmpAry = [NSMutableArray array];
    for (FSNotificationForm* notifyForm in messageInfoAry)
    {
        if (notifyForm.isSelected)
        {
            isSelected = YES;
            [tmpAry addObject:notifyForm];
        }
    }
    
    if (isSelected)
    {
        NSString* alertStr = [NSString stringWithFormat:@"确认删除这%ld条消息记录吗?",tmpAry.count];
        [self showFSAlertView:alertStr andConfirmHandler:^{
            [weakSelf hideWindow];
            [PUtils tipWithText:@"删除成功" andView:nil];
            [messageInfoAry removeObjectsInArray:tmpAry];
            if (messageInfoAry.count == 0)
            {
                [weakSelf setButtomViewShowAnimation:NO];
            }
            [ FSMessageInstance setMessages:messageInfoAry];
            if (messageInfoAry.count == 0)
            {
                buttomView.allChooseBtn.selected = NO;
                buttomView.allChooseBtn.enabled = NO;
                buttomView.buttonOne.enabled = NO;
                buttomView.buttonTwo.enabled = NO;
                [buttomView.buttonOne setBackgroundColor:CZJGRAYCOLOR];
                [buttomView.buttonTwo setBackgroundColor:CZJGRAYCOLOR];
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:kCZJNotifiRefreshMessageReadStatus object:nil];
            [weakSelf.myTableView reloadData];
        } andCancleHandler:nil];
    }
    else
    {
        [PUtils tipWithText:@"请选择消息记录" andView:nil];
    }
}

- (void)setButtomViewShowAnimation:(BOOL)_isShow
{
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint destPt = CGPointMake(0, _isShow? PJ_SCREEN_HEIGHT - 60 : PJ_SCREEN_HEIGHT);
        CGSize destSize = CGSizeMake(PJ_SCREEN_WIDTH, _isShow ? PJ_SCREEN_HEIGHT - 124 - 60 : PJ_SCREEN_HEIGHT - 124);
        [buttomView setPosition:destPt atAnchorPoint:CGPointZero];
        [self.myTableView setSize:destSize];
    }];
    
}
@end
