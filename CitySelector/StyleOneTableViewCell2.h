//
//  StyleOneTableViewCell2.h
//  CitySelector
//
//  Created by txx on 16/12/19.
//  Copyright © 2016年 txx. All rights reserved.
//
/*
 
 热门城市cell
 
 */
#import <UIKit/UIKit.h>
#import "CityGroup.h"

@interface StyleOneTableViewCell2 : UITableViewCell

typedef void(^TSelectCityHandle)(NSString *name);

/**
 热门城市都有哪些城市
 */
@property(nonatomic,strong)CityGroup *group;

/**
 本cell的高度，根据热门城市的个数
 */
@property(nonatomic,assign)CGFloat    cellHeight;


/**
 选择一个城市的回调
 */
-(void)selectedCityHandle:(TSelectCityHandle)handle;

@end
