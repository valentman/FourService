//
//  ProvinceForm.m
//  FourService
//
//  Created by Joe.Pen on 12/3/15.
//  Copyright © 2015 JoeP. All rights reserved.
//

#import "ProvinceForm.h"

@implementation ProvinceForm
@synthesize provinceId = _provinceId;
@synthesize total = _total;
@synthesize name = _name;
@synthesize containCitys = _containCitys;

- (id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init]) {
        self.provinceId = [dict valueForKey:@"provinceId"];
        self.total = [dict valueForKey:@"total"];
        self.name = [dict valueForKey:@"name"];
        _containCitys = [NSMutableArray array];
        return self;
    }
    return nil;
}

@end

@implementation CitysForm
@end