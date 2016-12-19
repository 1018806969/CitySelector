//
//  StyleOneTableViewCell2.m
//  CitySelector
//
//  Created by txx on 16/12/19.
//  Copyright © 2016年 txx. All rights reserved.
//

#import "StyleOneTableViewCell2.h"

@interface StyleOneTableViewCell2()

/**
 回调传递选择的城市
 */
@property(nonatomic,copy)TSelectCityHandle handle;

/**
 所有热门城市的父试图
 */
@property(nonatomic,strong)UIView         *view ;

/**
 所有热门城市
 */
@property(nonatomic,strong)NSMutableArray *buttons;

@end
@implementation StyleOneTableViewCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 重写
 */
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.view];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return  self ;
}
-(void)selectedCityHandle:(TSelectCityHandle)handle
{
    _handle = [handle copy];
}
/**
 重写set方法
 */
-(void)setGroup:(CityGroup *)group
{
    _group = group;
    [self createCityButton];
}
/**
 选择城市回调
 */
-(void)selectCity:(UIButton *)btn
{
    if (_handle) {
        _handle(btn.titleLabel.text);
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.bounds.size.width==0 || _buttons.count == 0) return;
    
    // int/int 结果为int(向下取整)
    // 所以这里需要转为float才能得到正确float结果
    // ceil() 向上取整函数
    int rowCount = ceil((float)_buttons.count/3);
    CGFloat btnWidth = (self.bounds.size.width - (3+1)*20)/3;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    for (int i = 0; i<_buttons.count; i++) {
        // 第几列 取模
        int line = i%3;
        // 第几行 取商
        int row = i/3;
        btnX = line*(20+btnWidth) + 20;
        btnY = row*(10+44) + 10;
        
        UIButton *btn = _buttons[i];
        btn.frame = CGRectMake(btnX, btnY, btnWidth, 44);
        
    }
    _view.frame = CGRectMake(0.f, 0.f, self.bounds.size.width, (44+10)*rowCount + 10);
    
}

-(void)createCityButton
{
    [_view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSMutableArray *citys = [NSMutableArray arrayWithCapacity:self.group.cities.count];
    for (int i = 0; i<self.group.cities.count; i++) {
        
        UIButton *btn = [[UIButton alloc] init];
        [btn addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:self.group.cities[i].name forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor yellowColor];
        [_view addSubview:btn];
        [citys addObject:btn];
    }
    _buttons = citys;

}
-(CGFloat)cellHeight
{
    int rowCount = ceil((float)self.group.cities.count/3);
    return rowCount*(44+10)+10;
}
- (UIView *)view{
    if (!_view) {
        UIView *citiesView = [[UIView alloc] init];
        _view = citiesView;
    }
    return _view;
}

@end
