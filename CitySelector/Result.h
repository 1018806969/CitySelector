//
//  Result.h
//  CitySelector
//
//  Created by txx on 17/1/5.
//  Copyright © 2017年 txx. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 模型类，作为回调参数
 */
@interface Result : NSObject
@property (nonatomic, strong) NSString *provinceCode;
@property (nonatomic, strong) NSString *provinceName;
@property (nonatomic, strong) NSString *cityCode;
@property (nonatomic, strong) NSString *cityName;
@end
