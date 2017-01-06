//
//  CitySelectView.h
//  CitySelector
//
//  Created by txx on 17/1/5.
//  Copyright © 2017年 txx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Result;

typedef void(^Tselected)(Result *result);
@interface CitySelectView : UIView

//call back
@property(nonatomic,copy)Tselected selected;


/**
 弹出
 */
-(void)showCitySelectView;

@end
