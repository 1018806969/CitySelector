//
//  CitySelectView.m
//  CitySelector
//
//  Created by txx on 17/1/5.
//  Copyright © 2017年 txx. All rights reserved.
//

#import "CitySelectView.h"
#import "Result.h"

@interface CitySelectView()<UIPickerViewDelegate,UIPickerViewDataSource>

/**
 利用textfiled的inputView呼出pickView，并添加inputAccessoryView
 */
@property(nonatomic,strong)UITextField *textField;

@property(nonatomic,strong)UIPickerView *pickView;

@property(nonatomic,strong)NSMutableArray *datas;

@property(nonatomic,assign)NSUInteger     currentProvinceIndex;

@property(nonatomic,assign)NSUInteger     currentCityIndex;


@end


@implementation CitySelectView
-(instancetype)init
{
    self = [super init];
    if (self) {
        [self loadData];
        _textField = [[UITextField alloc]init];
        [self addSubview:self.textField];
        
        _pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, 1000, 216)];
        _pickView.showsSelectionIndicator = YES ;
        _pickView.backgroundColor = [UIColor grayColor];
        _pickView.dataSource = self ;
        _pickView.delegate = self ;
        //设置inputView
        _textField.inputView = _pickView;
        
        [self addToolBarItem];
    }
    return self;
}
/**
 点击完成，也可传递数据，与代理方法传递数据选择一种即可
 */
- (void) tapSelectOkButton {
    [self hiddenPickerView];
    
    [self callBack];
}
-(void)loadData
{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"province" ofType:@"plist"];
    self.datas = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0 && self.datas) return self.datas.count;
    return [self.datas[_currentProvinceIndex][@"citys"] count];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}
/**
 delegate method 返回数据源

 */
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0 && row < _datas.count) {
        return _datas[row][@"name"];
    }
    if (component == 1) {
        NSArray *citys = _datas[_currentProvinceIndex][@"citys"];
        return citys[row][@"name"];
    }
    return @"";
}
/**
 delegate方法
 选中第一component的时候先更新数据源，再将第二component滑到第一row，同时组装数据并利用回调回传选中信息
 */
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {   _currentProvinceIndex = row;
        _currentCityIndex = 0;
        [_pickView reloadAllComponents];
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
    if (component == 1){
        _currentCityIndex = row;
    }
    [self callBack];
}
/**
 delegate方法，自定义row视图
 */
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
         forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *label = [[UILabel alloc] initWithFrame:view.frame];
    label.minimumScaleFactor = 0.5;
    label.backgroundColor = [UIColor redColor];
    label.adjustsFontSizeToFitWidth = YES;
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont boldSystemFontOfSize:15.0f]];
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return label;
}
/**
 private method ,组装数据，传递出去
 */
-(void)callBack
{
    Result *result = [[Result alloc]init];
    
    result.provinceCode = self.datas[_currentProvinceIndex][@"code"];
    result.provinceName = self.datas[_currentProvinceIndex][@"name"];
    result.cityCode     = self.datas[_currentProvinceIndex][@"citys"][_currentCityIndex][@"code"];
    result.cityName     = self.datas[_currentProvinceIndex][@"citys"][_currentCityIndex][@"name"];
    
    if (_selected) _selected(result);
}
/**
 private method 给textfiled添加toolbar
 */
-(void)addToolBarItem
{
    //TextView的键盘定制回收按钮
    UIToolbar * toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 1000, 44)];
    
    UIBarButtonItem *item0 = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(hiddenPickerView)];
    
    UIBarButtonItem * item1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(tapSelectOkButton)];
    
    toolBar.items = @[item0,item1,item2];
    _textField.inputAccessoryView = toolBar;
}
-(void)showCitySelectView
{
    [_textField becomeFirstResponder];
    [_pickView selectRow:0 inComponent:0 animated:NO];
    [_pickView selectRow:0 inComponent:1 animated:NO];
}
/**
 收起
 */
- (void) hiddenPickerView {
    [self.superview endEditing:YES];
}

@end
