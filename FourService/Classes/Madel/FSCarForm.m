//
//  FSCarForm.m
//  FourService
//
//  Created by Joe.Pen on 7/25/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSCarForm.h"

@implementation FSCarForm
-(id)init
{
    if (self = [super init])
    {
        _carBrandsForms = [NSMutableDictionary dictionary]; //汽车品牌列表信息
        _carSeries = [NSMutableDictionary dictionary];     //汽车指定品牌车系列表
        _carModels = [NSMutableArray array];                //汽车车型信息列表
        _hotBrands = [NSMutableArray array];
        _haveCarsForms = [NSArray array];
        return self;
    }
    return nil;
}

-(void)setNewCarBrandsFormDictionary:(NSDictionary*)dict
{
    NSArray* carbrands = [[dict valueForKey:@"msg"] valueForKey:@"brands"];
    for (NSDictionary* dictone in carbrands) {
        CarBrandsForm* tmp_ser = [CarBrandsForm objectWithKeyValues:dictone];
        if (tmp_ser.popular)
        {
            [_hotBrands addObject:tmp_ser];
        }
        if ( _carBrandsForms.count > 0 && [_carBrandsForms objectForKey:tmp_ser.initial] )
        {
            [[_carBrandsForms objectForKey:tmp_ser.initial] addObject:tmp_ser];
        }
        else
        {
            NSMutableArray* tmp_brands = [NSMutableArray array];
            [tmp_brands addObject:tmp_ser];
            NSString* tmp_key = tmp_ser.initial;
            
            [_carBrandsForms setObject:tmp_brands forKey:tmp_key];
        }
    }
}

- (void)setNewCarSeriesWithDict:(NSDictionary*)dict AndBrandName:(NSString*)brandName
{
    [_carSeries removeAllObjects];
    //对车牌数据进行整理
    NSArray* array = [dict valueForKey:@"msg"];
    for (NSDictionary* dict in array) {
        CarSeriesForm* Obj = [CarSeriesForm objectWithKeyValues:dict];
        
        if (_carSeries.count > 0 && [_carSeries objectForKey:Obj.groupName]) {
            [[_carSeries objectForKey:Obj.groupName] addObject:Obj];
        }else{
            NSMutableArray* tmp_series = [NSMutableArray array];
            [tmp_series addObject:Obj];
            if (Obj.groupName || [Obj.groupName isEqualToString:@" "]) {
                [_carSeries setValue:tmp_series forKey:Obj.groupName];
            }else{
                [_carSeries setValue:tmp_series forKey:brandName];
            }
            
        }
    }
}

- (void)setNewCarModelsWithDict:(NSDictionary*)dict
{
    [_carModels removeAllObjects];
    //对车牌数据进行整理
    NSArray* array = [dict valueForKey:@"msg"];
    for (NSDictionary* dict in array) {
        CarModelForm* form = [CarModelForm objectWithKeyValues:dict];
        [_carModels addObject:form];
    }
}

-(void)cleanData
{
    [_carBrandsForms removeAllObjects];
}
@end


@implementation CarBrandsForm
@end

@implementation CarSeriesForm
@end

@implementation CarModelForm
@end