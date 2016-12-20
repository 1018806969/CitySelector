//
//  StyleTwoCollectionViewCell.m
//  CitySelector
//
//  Created by txx on 16/12/20.
//  Copyright © 2016年 txx. All rights reserved.
//

#import "StyleTwoCollectionViewCell.h"

@implementation StyleTwoCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self) {
        [self addSubview:self.titleLabel];
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = self.contentView.frame;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        _titleLabel = label;
    }
    return _titleLabel;
}

@end
