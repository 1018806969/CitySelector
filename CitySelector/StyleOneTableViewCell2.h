//
//  StyleOneTableViewCell2.h
//  CitySelector
//
//  Created by txx on 16/12/19.
//  Copyright © 2016年 txx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityGroup.h"

@interface StyleOneTableViewCell2 : UITableViewCell

typedef void(^TSelectCityHandle)(NSString *name);

@property(nonatomic,strong)CityGroup *group;

@property(nonatomic,assign)CGFloat    cellHeight;


-(void)selectedCityHandle:(TSelectCityHandle)handle;

@end
