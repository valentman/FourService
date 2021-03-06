//
//  MXPullDownMenu000.m
//  MXPullDownMenu
//
//  Created by 马骁 on 14-8-21.
//  Copyright (c) 2014年 Mx. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "MXPullDownMenu.h"
#import "MXPullDownCollectionViewCell.h"
#import "ProvinceForm.h"
#import "FSBaseDataManager.h"
#define kMXPullDownCollectionViewCell @"MXPullDownCollectionViewCell"


@implementation MXPullDownMenu
{
    UIColor *_menuColor;

    UIView *_backGroundView;
    UITableView *_tableView;
    UICollectionView *_subCollectionView;
    
    NSArray *_array;
    NSMutableArray *_titles;
    NSMutableArray *_indicators;
    NSMutableArray *_containCitys;
    
    NSInteger _numOfMenu;
    NSInteger _currentSelectedMenudIndex;
    NSInteger _selectIndex;
    NSInteger _goodsServiceSelectIndex;
    NSIndexPath* _selelctIndexPath;
    NSIndexPath* _lastSelectIndexPath;
    
    CGFloat _viewContentHeight;
    CGFloat _collectionViewWidth;
    
    NSString* _selectedCityName;
    bool _show;
    __block BOOL _isTableViewShow;
    BOOL isFirstTitle;
    
    CZJMXPullDownMenuType _menuType;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
    }
    return self;
}


- (MXPullDownMenu *)initWithArray:(NSArray *)array AndType:(CZJMXPullDownMenuType)menutype WithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        //设置Frame及背景颜色
        self.frame = CGRectMake(0, 0, PJ_SCREEN_WIDTH, 44);
        self.backgroundColor = CLEARCOLOR;
        
        //菜单名字及小三角颜色
        _menuColor = WHITECOLOR;
        
        //菜单栏名称数组,在根据菜单栏数目计算标题，箭头的数量。
        _array = array;
        _numOfMenu = _array.count;
        CGFloat textLayerInterval = PJ_SCREEN_WIDTH / ( _numOfMenu * 2);
        CGFloat separatorLineInterval = PJ_SCREEN_WIDTH / _numOfMenu;
        _titles = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
        _indicators = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
        
        //菜单栏类型
         _menuType = menutype;
    
        //数据初始化
        _containCitys = [NSMutableArray array];
        _show = NO;
        
        //当前选择栏索引初始化
        _selectIndex = -1;
        _currentSelectedMenudIndex = 0;

        
        //确定下拉菜单的高度
        switch (_menuType) {
            case CZJMXPullDownMenuTypeNone:
                break;
                
            case CZJMXPullDownMenuTypeStore:
                 _viewContentHeight = PJ_SCREEN_HEIGHT - StatusBar_HEIGHT - NavigationBar_HEIGHT - self.frame.size.height - Tabbar_HEIGHT - 200;
                break;
                
            default:
                break;
        }
        
        //菜单名、小三角、中间分隔线
        for (int i = 0; i < _numOfMenu; i++)
        {   //菜单名
            CGPoint position = CGPointMake( (i * 2 + 1) * textLayerInterval , self.frame.size.height / 2);
            CATextLayer *title = [CATextLayer new];
            switch (_menuType)
            {
                case CZJMXPullDownMenuTypeNone:
                    title = [self creatTextLayerWithNSString:_array[i][0] withColor:_menuColor andPosition:position];
                    break;
                    
                case CZJMXPullDownMenuTypeStore:
                    if (0 == i) {
                        ProvinceForm* form = _array[i][0];
                        title = [self creatTextLayerWithNSString:@"成都" withColor:_menuColor andPosition:position];
                    }
                    else
                    {
                        title = [self creatTextLayerWithNSString:_array[i][0] withColor:_menuColor andPosition:position];
                    }
                    break;
                    

                default:
                    title = [self creatTextLayerWithNSString:_array[i][0] withColor:_menuColor andPosition:position];
                    break;
            }
            [self.layer addSublayer:title];
            [_titles addObject:title];
            
            //小三角图形
            CGPoint pt = CGPointMake(position.x + title.bounds.size.width / 2 + 8, self.frame.size.height / 2);
            CAShapeLayer *indicator = [self creatIndicatorWithColor:_menuColor andPosition:pt];
            [self.layer addSublayer:indicator];
            [_indicators addObject:indicator];
            
            //分割线
            if (i != _numOfMenu - 1)
            {
                CGPoint separatorPosition = CGPointMake((i + 1) * separatorLineInterval, self.frame.size.height / 2);
                CAShapeLayer *separator = [self creatSeparatorLineWithColor:WHITECOLOR andPosition:separatorPosition];
                [self.layer addSublayer:separator];
            }
        }
        
        
        //TableView
        _tableView = [self creatTableViewAtPosition:CGPointMake(0, self.frame.origin.y + self.frame.size.height)];
        _tableView.tintColor = CZJREDCOLOR;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _selelctIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        
        //CollectionView
        _subCollectionView = [self createCollectionViewAtPosition:CGPointMake(self.frame.size.width*0.5, self.frame.origin.y + self.frame.size.height)];
        _subCollectionView.dataSource = self;
        _subCollectionView.delegate = self;
        _subCollectionView.backgroundColor = [UIColor whiteColor];
        
        
        // 设置menu, 并添加手势
        UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMenu:)];
        [self addGestureRecognizer:tapGesture];
        
        // 创建半透黑色背景
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0,self.frame.origin.y + self.frame.size.height + 64, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT)];
        _backGroundView.backgroundColor = RGBA(100, 240, 240, 0);
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackGround:)];
        [_backGroundView addGestureRecognizer:gesture];
    }
    return self;
}

- (void)registNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resetIndicatorTitleName:) name:kCZJChangeCurCityName  object:nil];
}

- (void)removeNotificationObserve
{
    [[NSNotificationCenter  defaultCenter] removeObserver:self name:kCZJChangeCurCityName object:nil];
}

- (void)resetIndicatorTitleName:(NSNotification*)notif
{
    _selectedCityName = [notif.userInfo objectForKey:@"cityname"];
    [self confiMenuWithSelectRow:0];
}



#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DLog(@"%ld",[_array[_currentSelectedMenudIndex] count]);
    return [_array[_currentSelectedMenudIndex] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* reuserIdefier = @"MXPullDwonCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdefier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserIdefier];
        cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    }
    
    if( nil == (UILabel*)[cell viewWithTag:1001])
    {
        UILabel* totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(PJ_SCREEN_WIDTH*0.5 - 60, 8, 30, 21)];
        totalLabel.font = [UIFont systemFontOfSize:13.0];
        totalLabel.textColor = [UIColor grayColor];
        totalLabel.textAlignment = NSTextAlignmentRight;
        [totalLabel setTag:1001];
        [cell addSubview:totalLabel];
    }
    [cell.textLabel setTextColor:[UIColor grayColor]];
    [((UILabel*)[cell viewWithTag:1001]) setTextColor:[UIColor grayColor]];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    if (0 == _currentSelectedMenudIndex)
    {
        switch (_menuType) {
            case CZJMXPullDownMenuTypeStore:
            {
                ProvinceForm* province = ((ProvinceForm*)_array[_currentSelectedMenudIndex][indexPath.row]);
                cell.textLabel.text = @"成都";
                ((UILabel*)[cell viewWithTag:1001]).text = province.total;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
                break;
                
            case CZJMXPullDownMenuTypeNone:
            {
                cell.textLabel.text = _array[_currentSelectedMenudIndex][indexPath.row];
                if (cell.textLabel.text == [(CATextLayer *)[_titles objectAtIndex:_currentSelectedMenudIndex] string]) {
                    [cell.textLabel setTextColor:[tableView tintColor]];
                }
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
                break;
                
            default:
                break;
        }

    }
    else
    {
        ((UILabel*)[cell viewWithTag:1001]).text = @"";
        cell.textLabel.text = _array[_currentSelectedMenudIndex][indexPath.row];
        if (cell.textLabel.text == [(CATextLayer *)[_titles objectAtIndex:_currentSelectedMenudIndex] string]) {
            [cell.textLabel setTextColor:[tableView tintColor]];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    }

    cell.backgroundColor = CZJNAVIBARBGCOLOR;
    
    if (_selectIndex == indexPath.row &&
        0 == _currentSelectedMenudIndex)
    {
        DLog(@"selectinde:%ld",_selectIndex);
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}


#pragma mark  tableViewDelegate
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = CZJNAVIBARBGCOLOR;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_lastSelectIndexPath != indexPath)
    {
        [self tableView:tableView didDeselectRowAtIndexPath:_lastSelectIndexPath];
    }
    _lastSelectIndexPath = indexPath;
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = YES;
    if (0 == _currentSelectedMenudIndex)
    {
        if (0 == _selectIndex)
        {
            [self tableView:tableView didDeselectRowAtIndexPath:_selelctIndexPath];
        }
        cell.backgroundColor = [UIColor whiteColor];
        _selectIndex = indexPath.row;
        switch (_menuType) {
            case CZJMXPullDownMenuTypeStore:
            {
//                _containCitys = [((ProvinceForm*)_array[0][indexPath.row]).containCitys mutableCopy];
//                [_subCollectionView reloadData];
            }
                break;
                
            case CZJMXPullDownMenuTypeNone:
            {
            }
                break;
                
            default:
                break;
        }
        
    }
    else
    {
        [self confiMenuWithSelectRow:indexPath.row];
        [self.delegate PullDownMenu:self didSelectRowAtColumn:_currentSelectedMenudIndex row:indexPath.row];
    }
}


#pragma mark - collectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return   1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _containCitys.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MXPullDownCollectionViewCell *cell = (MXPullDownCollectionViewCell*)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    [cell.cityName setTextColor:[_tableView tintColor]];
    [cell.cityStoreNum setTextColor:[_tableView tintColor]];
    _selectedCityName = cell.cityName.text;
    [self confiMenuWithSelectRow:indexPath.row];
    [self.delegate pullDownMenu:self didSelectCityName:_selectedCityName];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MXPullDownCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:kMXPullDownCollectionViewCell forIndexPath:indexPath];
    cell.shaixuanImage.hidden = YES;

    CitysForm* form = (CitysForm*)(_containCitys[indexPath.row]);
    cell.cityName.text = form.name;
    cell.cityStoreNum.text = form.total;
    cell.backgroundColor = [UIColor whiteColor];
    
    [cell.cityName setTextColor:[self tableView:_tableView cellForRowAtIndexPath:_selelctIndexPath].textLabel.textColor];
    [cell.cityStoreNum setTextColor:[self tableView:_tableView cellForRowAtIndexPath:_selelctIndexPath].textLabel.textColor];
    if (cell.cityName.text == [(CATextLayer *)[_titles objectAtIndex:_currentSelectedMenudIndex] string]) {
        [cell.cityName setTextColor:[_tableView tintColor]];
        [cell.cityStoreNum setTextColor:[_tableView tintColor]];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(collectionView.frame.size.width, 36);
}


#pragma mark - tapEvent
// 处理菜单点击事件.通过点击区域判定点击项
- (void)tapMenu:(UITapGestureRecognizer *)paramSender
{
    // 得到tapIndex(点击的菜单项)
    CGPoint touchPoint = [paramSender locationInView:self];
    NSInteger tapIndex = touchPoint.x / (PJ_SCREEN_WIDTH / _numOfMenu);
    [self touchMXPullDownMenuAtMenuIndex:tapIndex];
}

- (void)touchMXPullDownMenuAtMenuIndex:(NSInteger)tapIndex
{
    _selectIndex = -1;
    
    //=================指定界面情况=======================
    //商品列表和服务列表模块筛选按钮
//    if ((CZJMXPullDownMenuTypeService == _menuType || CZJMXPullDownMenuTypeGoods== _menuType) &&
//        2 == tapIndex)
//    {
//        [self.delegate pullDownMenuDidSelectFiliterButton:self];
//        [self tapBackGround:nil];
//        return;
//    }
    
    //商品列表的价格按钮
//    if (CZJMXPullDownMenuTypeGoods== _menuType &&
//        1 == tapIndex)
//    {
//        //改变点击菜单的颜色
//        [self tapIndexSetTitleColor:tapIndex];
//        [self.delegate pullDownMenuDidSelectPriceButton:self];
//        [self tapBackGround:nil];
//        return;
//    }
    
    //改变点击菜单的颜色
    [self tapIndexSetTitleColor:tapIndex];
    
    //门店详情界面下拉菜单
//    if (CZJMXPullDownMenuTypeStoreDetail == _menuType && 0 != tapIndex)
//    {
//        [self.delegate pullDownMenu:self didSelectCityName:_array[tapIndex][0]];
//        [self tapBackGround:nil];
//        return;
//    }
    
    
    //=================一般情况=======================
    //如果点击的是当前已经显示出来的按钮，则该按钮就隐藏
    if (tapIndex == _currentSelectedMenudIndex && _show)
    {
        [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView tableView:_tableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
            _currentSelectedMenudIndex = tapIndex;
            _show = NO;
        }];
        
    } else {
        //否则就显示新点击按钮的信息列表
        _currentSelectedMenudIndex = tapIndex;
        [_tableView reloadData];
        [self animateIdicator:_indicators[tapIndex] background:_backGroundView tableView:_tableView title:_titles[tapIndex] forward:YES complecte:^{
            _show = YES;
            if (0 == _currentSelectedMenudIndex )
            {
                [self tableView:_tableView didSelectRowAtIndexPath:_selelctIndexPath];
            }
        }];
    }
}

//改变点击菜单的颜色
- (void)tapIndexSetTitleColor:(NSInteger)tapIndex
{
    for (int i = 0; i < _numOfMenu; i++)
    {
        [self animateTitle:_titles[i] show:(i == tapIndex) complete:^{
            [self animateIndicator:_indicators[i] Forward:(i == tapIndex) complete:^{
            }];
        }];
    }
}


- (void)tapBackGround:(UITapGestureRecognizer *)paramSender
{
    [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView tableView:_tableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
        _show = NO;
    }];
}


#pragma mark - animation
//小三角指示器执行旋转动画
- (void)animateIndicator:(CAShapeLayer *)indicator Forward:(BOOL)forward complete:(void(^)())complete
{
    DLog();
    if (![indicator isKindOfClass:[CALayer class]])
    {
        return;
    }
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.35];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.2 :1.0]];
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values = forward ? @[ @0, @(M_PI) ] : @[ @(M_PI), @0 ];
    
    if (!anim.removedOnCompletion) {
        [indicator addAnimation:anim forKey:anim.keyPath];
    } else {
        [indicator addAnimation:anim andValue:anim.values.lastObject forKeyPath:anim.keyPath];
    }
    
    [CATransaction commit];
    
    if ([indicator isKindOfClass:[CAShapeLayer class]])
    {
        indicator.fillColor = forward ? _tableView.tintColor.CGColor : _menuColor.CGColor;
    }
    
    if (complete)
    {
        complete();
    }
    
}

- (void)animateTitle:(CATextLayer *)title show:(BOOL)show complete:(void(^)())complete
{
    DLog();
    if (show) {
        title.foregroundColor = _tableView.tintColor.CGColor;
    } else {
        title.foregroundColor = _menuColor.CGColor;
    }
    CGSize size = [PUtils calculateTitleSizeWithString:title.string AndFontSize:15];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - 25) ? size.width : self.frame.size.width / _numOfMenu - 25;
    title.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    
    if (complete) {
        complete();
    }
}

- (void)animateBackGroundView:(UIView *)view show:(BOOL)show complete:(void(^)())complete
{
    DLog();
    if (show) {
        [self.superview addSubview:view];
        [view.superview addSubview:self];

        [UIView animateWithDuration:0.35 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        }];
    
    } else {
        [UIView animateWithDuration:0.35 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
    if (complete)
    {
        complete();
    }
}

- (void)animateTableView:(UITableView *)tableView show:(BOOL)show complete:(void(^)())complete
{
    DLog();
    if (show)
    {
        tableView.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);
        [self.superview addSubview:tableView];
        CGFloat tableViewHeight;
        
        
        if (_currentSelectedMenudIndex == 0)
        {
            tableViewHeight = _viewContentHeight;
            _subCollectionView.frame = CGRectMake(PJ_SCREEN_WIDTH - _collectionViewWidth, self.frame.origin.y + self.frame.size.height, _collectionViewWidth, 0);
            [self.superview addSubview:_subCollectionView];
            [_subCollectionView setTag:1001];
        }
        else
        {
            [[self.superview viewWithTag:1001] removeFromSuperview];
             tableViewHeight = ([tableView numberOfRowsInSection:0] > 6) ? (6 * tableView.rowHeight) : ([tableView numberOfRowsInSection:0] * tableView.rowHeight);
        }
        
        
        [UIView animateWithDuration:0.35 animations:^{
            tableView.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, self.frame.size.width, tableViewHeight);
            if (_currentSelectedMenudIndex == 0)
            {
                _subCollectionView.frame = CGRectMake(PJ_SCREEN_WIDTH - _collectionViewWidth, self.frame.origin.y + self.frame.size.height, _collectionViewWidth, tableViewHeight);
            }
        } completion:^(BOOL finished)
        {
            _isTableViewShow = YES;
        }];
    }
    else
    {
        
        [UIView animateWithDuration:0.35 animations:^{
            tableView.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);
            if (_currentSelectedMenudIndex == 0)
            {
                _subCollectionView.frame = CGRectMake(PJ_SCREEN_WIDTH - _collectionViewWidth, self.frame.origin.y + self.frame.size.height, _collectionViewWidth, 0);
            }
        } completion:^(BOOL finished) {
            [tableView removeFromSuperview];
            if (_currentSelectedMenudIndex == 0)
            {
                _isTableViewShow = NO;
                [[self.superview viewWithTag:1001] removeFromSuperview];
            }
        }];
    }
    if (complete) {
        complete();
    }
}


- (void)animateIdicator:(CAShapeLayer *)indicator background:(UIView *)background tableView:(UITableView *)tableView title:(CATextLayer *)title forward:(BOOL)forward complecte:(void(^)())complete
{
    [self animateIndicator:indicator Forward:forward complete:^{
        [self animateTitle:title show:forward complete:^{
            [self animateBackGroundView:background show:forward complete:^{
                [self animateTableView:tableView show:forward complete:^{
                }];
            }];
        }];
    }];
    if (complete) {
        complete();
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"MXPullDownMenuTitleChange" object:nil];
}


#pragma mark - drawing
//画小三角图形
- (CAShapeLayer *)creatIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point
{
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(8, 0)];
    [path addLineToPoint:CGPointMake(4, 5)];
    [path closePath];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.fillColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    layer.position = point;
    
    return layer;
}

- (CAShapeLayer *)creatSeparatorLineWithColor:(UIColor *)color andPosition:(CGPoint)point
{
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(160,0)];
    [path addLineToPoint:CGPointMake(160, 20)];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.strokeColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    layer.position = point;
    
    return layer;
}

- (CATextLayer *)creatTextLayerWithNSString:(NSString *)string withColor:(UIColor *)color andPosition:(CGPoint)point
{
    CGSize size = [PUtils calculateTitleSizeWithString:string AndFontSize:15];
    
    CATextLayer *layer = [CATextLayer new];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - 25) ? size.width : self.frame.size.width / _numOfMenu - 25;
    layer.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    layer.string = string;
    layer.fontSize = 15.0;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.foregroundColor = color.CGColor;
    layer.contentsScale = [[UIScreen mainScreen] scale];
    
    layer.position = point;
    
    return layer;
}


- (UITableView *)creatTableViewAtPosition:(CGPoint)point
{
    UITableView *tableView = [UITableView new];
    tableView.frame = CGRectMake(point.x, point.y, self.frame.size.width, 0);
    tableView.rowHeight = 36;
    tableView.backgroundColor = CZJNAVIBARBGCOLOR;
    tableView.tableFooterView=[[UIView alloc] init];
    
    return tableView;
}

- (UICollectionView*)createCollectionViewAtPosition:(CGPoint)point
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing=0.f;//左右间隔
    flowLayout.minimumLineSpacing=0.f;
    
    _collectionViewWidth = PJ_SCREEN_WIDTH - point.x;
    UICollectionView* collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(point.x, point.y, _collectionViewWidth, _viewContentHeight) collectionViewLayout:flowLayout];
    
    UINib *nib=[UINib nibWithNibName:kMXPullDownCollectionViewCell bundle:nil];
    [collectionView registerNib: nib forCellWithReuseIdentifier:kMXPullDownCollectionViewCell];
    
    return collectionView;
}


#pragma mark - otherMethods

- (void)confiMenuWithSelectRow:(NSInteger)row
{
    CATextLayer *title = (CATextLayer *)_titles[_currentSelectedMenudIndex];
    
    if (0 != _currentSelectedMenudIndex) {
        title.string = [[_array objectAtIndex:_currentSelectedMenudIndex] objectAtIndex:row];
    }
    if (0 == _currentSelectedMenudIndex)
    {
        title.string = _selectedCityName;
    }
    
    [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView tableView:_tableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
        _show = NO;
        
    }];
    CAShapeLayer *indicator = (CAShapeLayer *)_indicators[_currentSelectedMenudIndex];
    indicator.position = CGPointMake(title.position.x + title.frame.size.width / 2 + 8, indicator.position.y);
}

- (NSString*)getMenuTitleByCurrentMenuIndex
{
    CATextLayer *title = (CATextLayer *)_titles[0];
    DLog(@"titlestring:%@",title.string);
    return title.string;
}


- (void)animateIndicator:(BOOL)forward
{
    [self animateIndicator:_indicators[1] Forward:forward complete:nil];
}


@end

#pragma mark - CALayer Category
@implementation CALayer (MXAddAnimationAndValue)

- (void)addAnimation:(CAAnimation *)anim andValue:(NSValue *)value forKeyPath:(NSString *)keyPath
{
    [self addAnimation:anim forKey:keyPath];
    [self setValue:value forKeyPath:keyPath];
}
@end
