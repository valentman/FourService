//
//  CZJSerFilterChooseCar.m
//  CZJShop
//
//  Created by Joe.Pen on 12/10/15.
//  Copyright © 2015 JoeP. All rights reserved.
//

#import "CZJCarBrandChooseController.h"
#import "FSBaseDataManager.h"
#import "FSCarForm.h"
#import "CZJCarSeriesChooseController.h"
#import "CZJHotBrandViewCell.h"
#import "CZJGeneralCell.h"

static NSString *CarListCellIdentifierID = @"CarListCellIdentifierID";
@interface CZJCarBrandChooseController ()
<
UITableViewDataSource,
UITableViewDelegate
>
{
    NSMutableDictionary* _carBrands;
    NSArray* _haveCars;
    NSArray* _hotBrands;
    NSArray* _keys;
    id _currentSelect;
    
    UIImageView   *_bgImageView;
    UIView        *_tipsView;
    UILabel       *_tipsLab;
    NSTimer       *_timer;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation CZJCarBrandChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self initData];
}

- (void)initTableView
{
    self.title = @"选择品牌";
    
    if ([_viewFrom isEqualToString:@"carList"])
    {
        [self addCZJNaviBarViewWithNotHiddenNavi:CZJNaviBarViewTypeGeneral];
        self.naviBarView.mainTitleLabel.text = @"选择品牌";
    }
    
    NSInteger width = PJ_SCREEN_WIDTH - (CZJCarListTypeFilter == _carlistType ? kMGLeftSpace  : 0);
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, width, PJ_SCREEN_HEIGHT - 64)];
    self.tableView.clipsToBounds = YES;
    self.tableView.backgroundColor = CZJTableViewBGColor;
    self.tableView.tableFooterView = [[UIView alloc]init];
    UINib *nib=[UINib nibWithNibName:@"CZJGeneralCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"CZJGeneralCell"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
}

- (void)initData
{
    _carBrands = [[FSBaseDataInstance carForm]carBrandsForms];
    if (_carBrands.count == 0)
    {
        [MBProgressHUD showHUDAddedTo: self.view animated:YES];
        [FSBaseDataInstance getCarBrandsList:^(id json) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self dealWithCarData];
        }];
    }
    else
    {
        [self dealWithCarData];
    }
}


- (void)dealWithCarData
{
    _carBrands = [[FSBaseDataInstance carForm]carBrandsForms];
    _haveCars = [[FSBaseDataInstance carForm]haveCarsForms];
    _hotBrands = [[FSBaseDataInstance carForm]hotBrands];
    _keys = [_carBrands allKeys];
    NSArray *resultArray = [_keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    _keys = resultArray;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2 + _keys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section)
    {
        if (CZJCarListTypeFilter == _carlistType)
        {
            return 0;
        }
        else if (CZJCarListTypeGeneral == _carlistType)
        {
            return 0;
        }
        else
        {
            return 1;
        }
    }
    else if (1 == section)
    {
        return 2;
    }
    else
    {
        NSString* tmp_key = [_keys objectAtIndex:(section- 2)];
        NSArray*  brands = [_carBrands objectForKey:tmp_key];
        UIView* headerview = [tableView headerViewForSection:(section - 2)];
        [headerview setBackgroundColor:[UIColor whiteColor]];
        return [brands count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.tableView respondsToSelector:@selector(setSectionIndexColor:)]) {
        self.tableView.sectionIndexBackgroundColor = CLEARCOLOR;  //修改索引试图未选中时的背景颜色
        self.tableView.sectionIndexTrackingBackgroundColor = CLEARCOLOR;//修改索引试图选中时的背景颜色
        self.tableView.sectionIndexColor = GRAYCOLOR;//修改索引试图字体颜色
    }
    
    if (indexPath.section == 0)
    {
        UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SKStableCell"];
        cell.textLabel.text = @"已有车辆";
        if (_haveCars.count > 0)
        {
//            cell.detailTextLabel.text = ((HaveCarsForm*)_haveCars[0]).brandName;
//            cell.detailTextLabel.textColor  = CZJREDCOLOR;
//            cell.detailTextLabel.font = SYSTEMFONT(14);
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (1 == indexPath.section)
    {
        if (0 == indexPath.row)
        {
            CZJGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralCell" forIndexPath:indexPath];
            cell.nameLabel.text = @"热门品牌";
            cell.nameLabel.textColor = LIGHTGRAYCOLOR;
            [cell.headImgView setImage:IMAGENAMED(@"shaixuan_icon_hot")];
            cell.imageViewWidth.constant = 18;
            cell.imageViewHeight.constant = 18;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.arrowImg.hidden = YES;
            return cell;
        }
        else
        {
            UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"hotBrandCell"];
            for (int i = 0; i < _hotBrands.count; i++)
            {
                int divide = 5;
                CarBrandsForm* brandForm = _hotBrands[i];
                int subWidth = self.viewFrom == nil ? 50 : 0;
                CGRect hotBrandRect = [PUtils viewFrameFromDynamic:CZJMarginMake(15, 10) size:CGSizeMake(40, 55) index:i divide:divide subWidth:subWidth];
                CZJHotBrandViewCell* hotCell = [PUtils getXibViewByName:@"CZJHotBrandViewCell"];
                hotCell.frame = hotBrandRect;
                [hotCell.brandImg sd_setImageWithURL:[NSURL URLWithString:ConnectString(kCZJServerAddr, brandForm.icon)] placeholderImage:DefaultPlaceHolderSquare];
                hotCell.brandName.text = brandForm.car_brand_name;
                [hotCell.hotBrandBtn setTag:i];
                [hotCell.hotBrandBtn addTarget:self action:@selector(hotBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:hotCell];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else
    {
        CZJGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralCell" forIndexPath:indexPath];
        NSString* tmp_key = [_keys objectAtIndex:(indexPath.section - 2)];
        NSArray*  brands = [_carBrands objectForKey:tmp_key];
        CarBrandsForm* obj = [brands objectAtIndex:indexPath.row];
        
        cell.arrowImg.hidden = YES;
        cell.nameLabel.text = obj.car_brand_name;
        NSString *userAgent = @"";
        userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
        
        if (userAgent) {
            if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
                NSMutableString *mutableUserAgent = [userAgent mutableCopy];
                if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
                    userAgent = mutableUserAgent;
                }
            }
            [[SDWebImageDownloader sharedDownloader] setValue:userAgent forHTTPHeaderField:@"User-Agent"];
        }
        [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:ConnectString(kCZJServerAddr, obj.icon)]
                          placeholderImage:DefaultPlaceHolderSquare
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                                     
                                 }];

        cell.imageViewHeight.constant = 40;
        cell.imageViewWidth.constant = 40;
        cell.nameLabel.textColor = BLACKCOLOR;
        cell.nameLabelLeading.constant = 65;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}


#pragma mark- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section)
    {
        if (0 == indexPath.row)
        {
            if (CZJCarListTypeFilter == _carlistType)
            {
                //return 44;
                return 0;
            }
            else if (CZJCarListTypeGeneral == _carlistType)
            {
                return 0;
            }
            else
            {
                return 44;
            }
        }
        else
        {
            return 44;
        }
    }
    else if (1 == indexPath.section)
    {
        //热门车辆的排列
        if (0 == indexPath.row)
        {
            return 44;
        }
        else
        {//动态调整
            int divide = (iPhone5 || iPhone4) ? 4 : 5;
            NSInteger row = 0;
            if (_hotBrands.count > 0)
            {
                row = ceilf((float)_hotBrands.count / (float)divide);
            }
            return (65 + 10) * row;
        }
    }
    else
    {
        return 55;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section)
    {
        return 0;
    }
    else if (1 == section)
    {
        return 10;
    }
    else
    {
        return 44;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _keys;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (0 == section || 1 == section)
    {
        return nil;
    }
    NSString *sectionName = [_keys objectAtIndex:(section - 2)];
    return sectionName;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor whiteColor];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor grayColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section >= 2 )
    {
        NSString* tmp_key = [_keys objectAtIndex:(indexPath.section - 2)];
        NSArray*  brands = [_carBrands objectForKey:tmp_key];
        CarBrandsForm* obj = [brands objectAtIndex:indexPath.row];
        _currentSelect = obj;
        [FSBaseDataInstance setCarBrandForm:obj];
        CZJCarSeriesChooseController *svc = [[CZJCarSeriesChooseController alloc] initWithType:_carlistType];
        svc.carBrand = obj;
        [self.navigationController pushViewController:svc animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    //    NSLog(@"title = %@",title);
    [self showTipsWithTitle:title];
    
    return index;
}

- (void)showTipsWithTitle:(NSString*)title
{
    //获取当前屏幕window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!_tipsView) {
        //添加字母提示框
        _tipsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        _tipsView.center = window.center;
        _tipsView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.8];
        //设置提示框圆角
        _tipsView.layer.masksToBounds = YES;
        _tipsView.layer.cornerRadius  = _tipsView.frame.size.width/20;
        _tipsView.layer.borderColor   = [UIColor whiteColor].CGColor;
        _tipsView.layer.borderWidth   = 2;
        [window addSubview:_tipsView];
    }
    if (!_tipsLab) {
        //添加提示字母lable
        _tipsLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _tipsView.frame.size.width, _tipsView.frame.size.height)];
        //设置背景为透明
        _tipsLab.backgroundColor = [UIColor clearColor];
        _tipsLab.font = [UIFont boldSystemFontOfSize:50];
        _tipsLab.textAlignment = NSTextAlignmentCenter;
        
        [_tipsView addSubview:_tipsLab];
    }
    _tipsLab.text = title;//设置当前显示字母
    
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(hiddenTipsView) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
}

- (void)hiddenTipsView
{
    [UIView animateWithDuration:0.2 animations:^{
        _bgImageView.alpha = 0;
        _tipsView.alpha = 0;
    } completion:^(BOOL finished) {
        [_bgImageView removeFromSuperview];
        [_tipsView removeFromSuperview];
        _bgImageView = nil;
        _tipsLab     = nil;
        _tipsView    = nil;
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


#pragma mark- 点击事件
- (void)hotBtnClick:(UIButton*)sender
{
    CarBrandsForm* obj = [_hotBrands objectAtIndex:sender.tag];
    _currentSelect = obj;
    [FSBaseDataInstance setCarBrandForm:obj];
    CZJCarSeriesChooseController *svc = [[CZJCarSeriesChooseController alloc] initWithType:_carlistType];
    svc.carBrand = obj;
    [self.navigationController pushViewController:svc animated:YES];
}
@end
