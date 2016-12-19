//
//  StyleOneTableViewCell1.m
//  CitySelector
//
//  Created by txx on 16/12/19.
//  Copyright © 2016年 txx. All rights reserved.
//

#import "StyleOneTableViewCell1.h"

@interface StyleOneTableViewCell1()

@property(nonatomic,copy)TLocateHanlder locationHander;

@end
@implementation StyleOneTableViewCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.locateCityButton sizeToFit];
    CGRect rect = self.locateCityButton.bounds ;
    rect.size.width += 10.0f;
    
    self.locateCityButton.frame = CGRectMake(20, 5, rect.size.width, rect.size.height);
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.locateCityButton];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self ;
}
-(void)locateScc
{
    if (_locationHander) {
        _locationHander(self.locateCityButton.titleLabel.text);
    }
}
-(void)locateState:(TLocateState)state locationCityName:(NSString *)name handle:(TLocateHanlder)hander
{
    switch (state) {
        case TLocateStateFail:{
            [self.locateCityButton setTitle:@"获取当前位置失败，请手动选择城市" forState:UIControlStateNormal];
            self.locateCityButton.userInteractionEnabled = NO;
            break;
        }
        case TLocateStateSuccess:{
            [self.locateCityButton setTitle:name forState:UIControlStateNormal];
            self.locateCityButton.userInteractionEnabled = YES;
            break;
        }
        case TLocateStateLocating:{
            [self.locateCityButton setTitle:@"正在定位..." forState:UIControlStateNormal];
            self.locateCityButton.userInteractionEnabled = NO;
        break;
        }
    }
    _locationHander = [hander copy];
    [self setNeedsLayout];
}
- (UIButton *)locateCityButton {
    if (!_locateCityButton) {
        UIButton *locationCityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [locationCityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        locationCityBtn.layer.masksToBounds = YES;
        locationCityBtn.layer.cornerRadius = 5.f;
        locationCityBtn.backgroundColor = [UIColor lightGrayColor];
        locationCityBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        locationCityBtn.userInteractionEnabled = NO;
        
        _locateCityButton = locationCityBtn;
        [_locateCityButton addTarget:self action:@selector(locateScc) forControlEvents:UIControlEventTouchUpInside];
    }
    return _locateCityButton;
}



@end
