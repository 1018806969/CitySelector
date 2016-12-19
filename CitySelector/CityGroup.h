//
//  CityGroup.h
//  CitySelector
//
//  Created by txx on 16/12/19.
//  Copyright © 2016年 txx. All rights reserved.
//


/*
 
 一个城市组
 
 */
#import <Foundation/Foundation.h>
#import "Citys.h"

@interface CityGroup : NSObject


/**
 一个城市组的索引，如，A、热门等
 */
@property(nonatomic,strong)NSString *index;

/**
 一个城市组里面的城市数组
 */
@property(nonatomic,strong)NSMutableArray<Citys *> *cities;


-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end
