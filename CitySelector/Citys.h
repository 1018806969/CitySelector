//
//  Citys.h
//  CitySelector
//
//  Created by txx on 16/12/19.
//  Copyright © 2016年 txx. All rights reserved.
//

/*
 
 一个城市
 
 */
#import <Foundation/Foundation.h>

@interface Citys : NSObject

/**
 城市名
 */
@property(nonatomic,strong)NSString *name;


// 搜索联系人的方法 (拼音/拼音首字母缩写/汉字)
+ (NSArray<Citys *> *)searchText:(NSString *)searchText inDataArray:(NSArray<Citys *> *)dataArray;


@end
