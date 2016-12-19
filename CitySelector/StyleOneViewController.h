//
//  StyleOneViewController.h
//  CitySelector
//
//  Created by txx on 16/12/19.
//  Copyright © 2016年 txx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StyleOneViewController : UIViewController

typedef void(^TSelectedCityHandle)(NSString *name);


/**
 选择好了城市回调到viewcontroller中

 @param handle 回调代码块
 */
-(void)selectedCitySccessedHandle:(TSelectedCityHandle)handle;


@end
