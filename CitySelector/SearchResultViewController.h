//
//  SearchResultViewController.h
//  CitySelector
//
//  Created by txx on 16/12/19.
//  Copyright © 2016年 txx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Citys;
@interface SearchResultViewController : UIViewController

typedef void(^TSelectedCityHandle)(NSString *name);


/**
 搜索的结果
 */
@property(nonatomic,strong)NSArray<Citys *> *results;

/**
 选择了某个城市传递出去
 */
-(void)selectedCityHandle:(TSelectedCityHandle)handle;

@end
