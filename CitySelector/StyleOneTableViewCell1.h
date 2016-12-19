//
//  StyleOneTableViewCell1.h
//  CitySelector
//
//  Created by txx on 16/12/19.
//  Copyright © 2016年 txx. All rights reserved.
//

/*
 
 定位城市cell
 
 */

#import <UIKit/UIKit.h>

/**
 当前定位状态

 - TLocateStateSuccess: 定位成功
 - TLocateStateFail: 定位失败
 - TLocateStateLocating: 正在定位
 */
typedef NS_ENUM(NSInteger, TLocateState)
{
    TLocateStateSuccess,
    TLocateStateFail,
    TLocateStateLocating,
};

@interface StyleOneTableViewCell1 : UITableViewCell

typedef void(^TLocateHanlder)(NSString *title);

@property(nonatomic,strong)UIButton *locateCityButton;

/**
 根据不同的定位状态设置相关现实

 @param state 定位状态
 @param name 定位到的城市名
 @param hander 回调代码块
 */
-(void)locateState:(TLocateState)state locationCityName:(NSString *)name handle:(TLocateHanlder)hander;


@end
