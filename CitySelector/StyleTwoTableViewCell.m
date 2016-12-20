//
//  StyleTwoTableViewCell.m
//  CitySelector
//
//  Created by txx on 16/12/20.
//  Copyright © 2016年 txx. All rights reserved.
//

#import "StyleTwoTableViewCell.h"
#import "StyleTwoCollectionViewCell.h"

@interface StyleTwoTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,copy)TSelectedCityHandle handle;

@property(nonatomic,strong)UICollectionView *collectionView ;
@property(nonatomic,strong)UICollectionViewFlowLayout *flowLayout;

@end

static NSString *const TCollectionViewCell = @"TCollectionViewCell";

@implementation StyleTwoTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.collectionView];
    }
    return self;
}
-(void)setGroup:(CityGroup *)group
{
    _group = group ;
    //刷新
    [self.collectionView reloadData];
    
}
- (CGFloat)height {
    int rowCount = ceil((float)self.group.cities.count/3);
    return rowCount*(40+10)+10;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.bounds.size.width==0) {
        return;
    }
    self.collectionView.frame = self.bounds;
    CGFloat btnWidth = (self.bounds.size.width - (3+1)*20)/3;
    self.flowLayout.itemSize = CGSizeMake(btnWidth, 40);
}

-(void)selectedCityHandle:(TSelectedCityHandle)handle
{
    _handle = handle;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = self.group.cities[indexPath.row].name;
    if (_handle) {
        _handle(name);
    }
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.group.cities.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StyleTwoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TCollectionViewCell forIndexPath:indexPath];
    cell.titleLabel.text = self.group.cities[indexPath.row].name;
    return cell;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self ;
        _collectionView.dataSource = self ;
        [_collectionView registerClass:[StyleTwoCollectionViewCell class] forCellWithReuseIdentifier:TCollectionViewCell];
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}
-(UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.itemSize = CGSizeMake(100, 40);
        _flowLayout.minimumLineSpacing = 10;
        _flowLayout.minimumInteritemSpacing = 20;
        _flowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
    }
    return _flowLayout;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)awakeFromNib {
    [super awakeFromNib];
}

@end
