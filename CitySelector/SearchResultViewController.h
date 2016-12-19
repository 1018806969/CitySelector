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

-(void)selectedCityHandle:(TSelectedCityHandle)handle;

@end
