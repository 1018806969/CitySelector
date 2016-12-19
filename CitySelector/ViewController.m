//
//  ViewController.m
//  CitySelector
//
//  Created by txx on 16/12/19.
//  Copyright © 2016年 txx. All rights reserved.
//

#import "ViewController.h"
#import "StyleOneViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    
}
- (IBAction)type3:(UIButton *)sender {
    
    
    
}

@end
