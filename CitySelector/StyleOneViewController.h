//
//  StyleOneViewController.h
//  CitySelector
//
//  Created by txx on 16/12/19.
//  Copyright © 2016年 txx. All rights reserved.
//
/*
 
 第一种实现城市选择器的方法，
 
 
 在cell中通过block传递选择的城市到本vc，本vc通过block传递当前选中城市到viewcontroller中
 
 */
#import <UIKit/UIKit.h>

@interface StyleOneViewController : UIViewController

typedef void(^TSelectedCityHandle)(NSString *name);


/**
 选择好了城市回调到viewcontroller中

 @param handle 回调代码块
 */
-(void)selectedCitySccessedHandle:(TSelectedCityHandle)handle;


@end
