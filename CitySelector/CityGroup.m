//
//  CityGroup.m
//  CitySelector
//
//  Created by txx on 16/12/19.
//  Copyright © 2016年 txx. All rights reserved.
//

#import "CityGroup.h"

@implementation CityGroup

-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.index = dic[@"title"];
        NSArray *cities = dic[@"cities"];
        _cities = [NSMutableArray arrayWithCapacity:cities.count];
        
        for (NSString *name in cities) {
            Citys *city = [[Citys alloc]init];
            city.name = name ;
            [_cities addObject:city];
        }
    }
    return self;
}
@end
