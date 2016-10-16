//
//  FSCityLocationController.h
//  FourService
//
//  Created by Joe.Pen on 10/15/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CityLocationDelegate <NSObject>

- (void)didClickedWithCityName:(NSString*)cityName;

@end

@interface FSCityLocationController : UIViewController

@property (strong, nonatomic) id<CityLocationDelegate>delegate;

@property (strong, nonatomic) NSMutableArray *arrayLocatingCity;//定位城市数据
@property (strong, nonatomic) NSMutableArray *arrayHotCity;//热门城市数据
@property (strong, nonatomic) NSMutableArray *arrayHistoricalCity;//常用城市数据

@property(nonatomic,strong)UITableView *tableView;
@end
