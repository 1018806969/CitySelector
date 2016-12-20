//
//  StyleTwoTableViewCell.h
//  CitySelector
//
//  Created by txx on 16/12/20.
//  Copyright © 2016年 txx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityGroup.h"

@interface StyleTwoTableViewCell : UITableViewCell
typedef void(^TSelectedCityHandle)(NSString *name);

@property(nonatomic,strong)CityGroup *group;

@property(nonatomic,assign)CGFloat height;

-(void)selectedCityHandle:(TSelectedCityHandle)handle;

@end
