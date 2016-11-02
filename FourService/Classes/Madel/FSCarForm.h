//
//  FSCarForm.h
//  FourService
//
//  Created by Joe.Pen on 7/25/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSCarForm : NSObject
{
    NSMutableDictionary* _carBrandsForms;    //汽车品牌列表
    NSMutableArray* _carSeries;         //汽车指定品牌车系列表
    NSMutableArray* _carModels;              //汽车车型
    NSMutableArray* _hotBrands;              //热门品牌
    NSArray* _haveCarsForms;      //已有车辆
}
@property(nonatomic,strong)NSMutableDictionary* carBrandsForms;
@property(nonatomic,strong)NSMutableArray* carSeries;
@property(nonatomic,strong)NSMutableArray* carModels;
@property(nonatomic,strong)NSArray* haveCarsForms;
@property(nonatomic,strong)NSMutableArray* hotBrands;

- (id)init;
- (void)setNewCarBrandsFormDictionary:(NSDictionary*)dict;
- (void)setNewCarSeriesWithDict:(NSDictionary*)dict AndBrandName:(NSString*)brandName;
- (void)setNewCarModelsWithDict:(NSDictionary*)dict;
- (void)cleanData;
@end


//---------------------汽车品牌信息----------------------
@interface CarBrandsForm : NSObject
@property(nonatomic, strong) NSString* icon;
@property(nonatomic, strong) NSString* initial;
@property(nonatomic, strong) NSString* car_brand_name;
@property(nonatomic, strong) NSString* car_brand_id;
@property(nonatomic, assign) BOOL popular;
@end

//---------------------汽车车系信息----------------------
@interface CarSeriesForm : NSObject
@property(nonatomic,strong)NSString* brand_id;
@property(nonatomic,strong)NSString* car_model_id;
@property(nonatomic,strong)NSString* car_model_name;
@end


//---------------------汽车车型信息----------------------
@interface  CarModelForm : NSObject
@property(nonatomic,strong)NSString* car_type_id;
@property(nonatomic,strong)NSString* car_model_id;
@property(nonatomic,strong)NSString* car_type_name;
@property(nonatomic,assign)int seriesId;
@end
