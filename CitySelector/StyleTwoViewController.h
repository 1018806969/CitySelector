//
//  StyleTwoViewController.h
//  CitySelector
//
//  Created by txx on 16/12/20.
//  Copyright © 2016年 txx. All rights reserved.
//

/*
 
 viewcontroller
 
 */
#import <UIKit/UIKit.h>

@interface StyleTwoViewController : UIViewController

typedef void(^TSeletedCityHandle)(NSString *name);

/**
 选择好城市的回调，把当前选择的城市传递出去
 */
-(void)selectedCityHandle:(TSeletedCityHandle)handle;

@end
