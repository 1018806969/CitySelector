//
//  ViewController.m
//  CitySelector
//
//  Created by txx on 16/12/19.
//  Copyright © 2016年 txx. All rights reserved.
//

#import "ViewController.h"
#import "StyleOneViewController.h"
#import "StyleTwoViewController.h"
#import "CitySelectView.h"
#import "Result.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *pickshow;
@property(nonatomic,strong)CitySelectView  *cityView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cityView = [[CitySelectView alloc]init];
    [self.view addSubview:_cityView];
    
    //选中城市的回调
    __weak typeof(self) weakSelf = self ;
    _cityView.selected = ^(Result *result)
    {
        NSString *str = [NSString stringWithFormat:@"%@-%@-%@-%@",result.provinceCode,result.provinceName,result.cityCode,result.cityName];
        [weakSelf.pickshow setTitle:str forState:UIControlStateNormal];
    };

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)type1:(UIButton *)sender {
    
    StyleOneViewController *oneViewController = [[StyleOneViewController alloc]init];
    [oneViewController selectedCitySccessedHandle:^(NSString *name) {
        NSLog(@"选择的城市为%@",name);
        
    }];
    [self.navigationController pushViewController:oneViewController animated:YES];
}

- (IBAction)type2:(UIButton *)sender {
    
    StyleTwoViewController *twoViewController = [[StyleTwoViewController alloc]init];
    [twoViewController selectedCityHandle:^(NSString *name) {
        NSLog(@"选择的城市为%@",name);
    }];
    [self.navigationController pushViewController:twoViewController animated:YES];
}
- (IBAction)type3:(UIButton *)sender {
    
    [_cityView showCitySelectView];
}

@end
