//
//  StyleOneViewController.m
//  CitySelector
//
//  Created by txx on 16/12/19.
//  Copyright © 2016年 txx. All rights reserved.
//

#import "StyleOneViewController.h"
#import "StyleOneTableViewCell1.h"
#import "StyleOneTableViewCell2.h"
#import "SearchResultViewController.h"

#import "CityGroup.h"

#import <CoreLocation/CoreLocation.h>
@interface StyleOneViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchControllerDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)UISearchController *searchController;

@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,strong)CLGeocoder        *geocoder;

/**
 定位状态
 */
@property(nonatomic,assign)TLocateState locateState;
/**
 定位出来的城市名
 */
@property(nonatomic,strong)NSString    *locateName;

@property(nonatomic,copy)TSelectedCityHandle selectCityHandle;


/**
 包含所有数组和groupName
 */
@property(nonatomic,strong)NSMutableArray *cityInGroups;

/**
 所有的城市
 */
@property(nonatomic,strong)NSArray<Citys *> *allCitys;

@property(nonatomic,strong)NSMutableDictionary *cellHeightDictionary;

@end

static CGFloat const TSearchBarHeight = 40.0f;
static NSString *const TLocationCell = @"TLocationCell";
static NSString *const THotPointCell = @"THotPointCell";
static NSString *const TNormalCell   = @"TNormalCell";

@implementation StyleOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"type1";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    //定位
    [self beginLocation];
    
    //获取数据
    [self requiredData];
    
    NSLog(@"----------------%@",self.cityInGroups);
}
-(void)requiredData
{
    NSArray *rootArrary = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cityGroups" ofType:@"plist"]];
    
    self.cityInGroups = [NSMutableArray arrayWithCapacity:rootArrary.count];
    for (NSDictionary * groupDictionary in rootArrary) {
        CityGroup *group = [[CityGroup alloc]initWithDictionary:groupDictionary];
        [self.cityInGroups addObject:group];
    }
}
-(void)beginLocation
{
    [self.locationManager requestWhenInUseAuthorization];
    
    __weak typeof(self) weadSelf = self ;
    [self.geocoder reverseGeocodeLocation:self.locationManager.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        [weadSelf.locationManager stopUpdatingLocation];
        
        if (error || placemarks.count == 0) {
            weadSelf.locateState = TLocateStateFail;
        }else{
            weadSelf.locateState = TLocateStateSuccess;
            
            CLPlacemark *currentPlace = [placemarks firstObject];
            weadSelf.locateName = currentPlace.locality;
        }
        [NSTimer scheduledTimerWithTimeInterval:1 target:weadSelf selector:@selector(reloadLocationCity) userInfo:nil repeats:NO];
    }];
    
}
/**
 定位结束之后刷新定位区
 */
- (void)reloadLocationCity {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    });
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section ==1) {
        return 1;
    }else
    {
        return [[self.cityInGroups[section-1] cities] count];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cityInGroups.count +1;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        StyleOneTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:TLocationCell];
        __weak typeof(self) weakSelf = self ;
        [cell locateState:self.locateState locationCityName:self.locateName handle:^(NSString *title) {
            [weakSelf cityDidSelected:title];
        }];
        return cell;
    }else if (indexPath.section == 1)
    {
        StyleOneTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:THotPointCell];
        CityGroup *group = self.cityInGroups[indexPath.section-1];
        cell.group = group ;
        __weak typeof(self) weaSelf = self ;
        [cell selectedCityHandle:^(NSString *name) {
            [weaSelf cityDidSelected:name];
        }];
        [self.cellHeightDictionary setValue:[NSNumber numberWithFloat:cell.cellHeight] forKey:[NSString stringWithFormat:@"%ld", indexPath.section]];
        NSLog(@"-----------------%f",cell.cellHeight);
        return cell;
    }else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TNormalCell];
        CityGroup *group = self.cityInGroups[indexPath.section -1];
        cell.textLabel.text = group.cities[indexPath.row].name;
        cell.backgroundColor = [UIColor whiteColor];
        return cell ;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) return @"定位城市";
    return  [self.cityInGroups[section-1] index];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1) {
        return ;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Citys *city = [self.cityInGroups[indexPath.section-1] cities][indexPath.row];
    [self cityDidSelected:city.name];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (_cellHeightDictionary.count == 0) {
            return 0 ;
        }
        return [[_cellHeightDictionary valueForKey:[NSString stringWithFormat:@"%ld", indexPath.section]] floatValue];
    }else
    {
        return 44;
    }
}
/**
 添加右侧索引的代理方法，返回索引的数组,默认section == index，即点击第一个index对应第一区，由于Demo中第一区没有对应的index，故需要在下面的代理方法中手动设置section和index的对应关系，否则会出现不对应的情况
 */
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *indexTitles = [NSMutableArray arrayWithCapacity:_cityInGroups.count];
    for (CityGroup *citiesGroup in _cityInGroups) {
        [indexTitles addObject:citiesGroup.index];
    }
    return indexTitles;
}
/**
 指定索引和区的对应关系
 */
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index+1;
}

/**
 选中了城市的响应方法，三个地方调用：点击热门城市、搜索城市、普通城市

 @param name 选中的城市名
 */
-(void)cityDidSelected:(NSString *)name
{
    if (_selectCityHandle) {
        _selectCityHandle(name);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)selectedCitySccessedHandle:(TSelectedCityHandle)handle
{
    _selectCityHandle = [handle copy];
}


-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if (searchBar == self.searchBar) {
        [self presentViewController:self.searchController animated:YES completion:nil];
        return NO;
    }
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchBar == _searchController.searchBar) {
        SearchResultViewController *resultController = (SearchResultViewController *)_searchController.searchResultsController;
        // 更新数据 并且刷新数据
        resultController.results = [Citys searchText:searchText inDataArray:self.allCitys];
    }
}
-(NSArray <Citys *> *)allCitys
{
    NSMutableArray<Citys *> *allData = [NSMutableArray array];
    int index = 0;
    for (CityGroup *citysGroup in _cityInGroups) {// 获取所有的city
        if (index == 0) {// 第一组, 热门城市忽略
            index++;
            continue;
        }
        if (citysGroup.cities.count != 0) {
            for (Citys *city in citysGroup.cities) {
                [allData addObject:city];
            }
        }
        index++;
    }
    return allData;
}

// 这个代理方法在searchController消失的时候调用, 这里我们只是移除了searchController, 当然你可以进行其他的操作
- (void)didDismissSearchController:(UISearchController *)searchController {
    // 销毁
    self.searchController = nil;
}







- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;

        [tableView registerClass:[StyleOneTableViewCell1 class] forCellReuseIdentifier:TLocationCell];
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:TNormalCell];
        [tableView registerClass:[StyleOneTableViewCell2 class] forCellReuseIdentifier:THotPointCell];
        // 行高度
        tableView.rowHeight = 44.f;
        // sectionHeader 的高度
        tableView.sectionHeaderHeight = 28.f;
        // sectionIndexBar上的文字的颜色
        tableView.sectionIndexColor = [UIColor lightGrayColor];
        // 普通状态的sectionIndexBar的背景颜色
        tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        // 选中sectionIndexBar的时候的背景颜色
        //        tableView.sectionIndexTrackingBackgroundColor = [UIColor yellowColor];
        _tableView = tableView;
        _tableView.tableHeaderView = self.searchBar;
        
        self.locateState = TLocateStateLocating;
    }
    return _tableView;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.bounds.size.width, TSearchBarHeight)];
        searchBar.delegate = self;
        searchBar.placeholder = @"搜索城市名称/首字母缩写";
        _searchBar = searchBar;
    }
    return _searchBar;
}
- (CLLocationManager *)locationManager{
    if (!_locationManager) {
        CLLocationManager *locManager = [CLLocationManager new];
        locManager.desiredAccuracy = kCLLocationAccuracyBest;
        locManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager = locManager;
    }
    return _locationManager;
}

- (CLGeocoder *)geocoder{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
}
-(NSMutableDictionary *)cellHeightDictionary
{
    if (!_cellHeightDictionary) {
        _cellHeightDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _cellHeightDictionary;
}

- (UISearchController *)searchController {
    if (!_searchController) {
        SearchResultViewController *resultController = [SearchResultViewController new];
        __weak typeof(self) weakSelf = self;
        [resultController selectedCityHandle:^(NSString *name) {
            [weakSelf cityDidSelected:name];
            // dismiss
            [weakSelf.searchController dismissViewControllerAnimated:YES completion:nil];
            // 置为nil 销毁
            weakSelf.searchController = nil;
        }];
        // ios8+才可用 否则使用 UISearchDisplayController
        UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:resultController];
        
        searchController.delegate = self;
        searchController.searchBar.delegate = self;
        searchController.searchBar.placeholder = @"搜索城市名称/首字母缩写";
        _searchController = searchController;
    }
    return _searchController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
