//
//  StyleTwoViewController.m
//  CitySelector
//
//  Created by txx on 16/12/20.
//  Copyright © 2016年 txx. All rights reserved.
//

#import "StyleTwoViewController.h"
#import "Citys.h"
#import "CityGroup.h"
#import "StyleTwoTableViewCell.h"
#import "SearchResultViewController.h"

@interface StyleTwoViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchControllerDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UISearchBar *searchBar;

@property(nonatomic,strong)UISearchController *searchController;

/**
 所有城市名字的数组
 */
@property(nonatomic,strong)NSArray<Citys *> *allCities;

/**
 将城市名按照索引分组的数组
 */
@property(nonatomic,strong)NSMutableArray<CityGroup *> *cityGroups;

/**
 cell的高度数组
 */
@property(nonatomic,strong)NSMutableDictionary *cellHeightDictionary;

@property(nonatomic,copy)TSeletedCityHandle handle;


@end

static NSString *const THotCell = @"THotCell";


@implementation StyleTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];

    [self.view addSubview:self.tableView];
}

-(void)selectedCityHandle:(TSeletedCityHandle)handle
{
    _handle = [handle copy] ;
}
-(void)selectedCity:(NSString *)name
{
    if (_handle) {
        _handle(name);
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cityGroups.count ;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StyleTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:THotCell];
    cell.group = self.cityGroups[indexPath.section];
    __weak typeof(self) weakself = self ;
    [cell selectedCityHandle:^(NSString *name) {
        [weakself selectedCity:name];
    }];
    //将cell的高度缓存在字典中
    [self.cellHeightDictionary setObject:[NSNumber numberWithFloat:cell.height] forKey:[NSNumber numberWithInteger:indexPath.row]];
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.cityGroups[section].index;
}
/**
 从缓存中取出cell的高度
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_cellHeightDictionary.count == 0) {
        return 0;
    }
    CGFloat height = [[_cellHeightDictionary objectForKey:[NSNumber numberWithInteger:indexPath.row]] floatValue];
    return height;
}
/**
 返回区索引的数组
 */
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *indexs = [NSMutableArray arrayWithCapacity:self.cityGroups.count];
    for (CityGroup *group in self.cityGroups) {
        [indexs addObject:group.index];
    }
    return indexs ;
}
/**
 searchBar的代理
 */
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if (searchBar == self.searchBar) {
        //弹出searchController
        [self presentViewController:self.searchController animated:YES completion:nil];
        return NO;
    }
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar == _searchController.searchBar) {
        SearchResultViewController *resultViewController = (SearchResultViewController *)_searchController.searchResultsController;
        
        //更新数据源
        resultViewController.results = [Citys searchText:searchText inDataArray:self.allCities];
    }
    
}
/**
 这个代理方法在searchController消失的时候调用，这里只是移除了searchController，还可以进行其他操作
 */
-(void)didDismissSearchController:(UISearchController *)searchController
{
    self.searchController = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (UISearchController *)searchController {
    if (!_searchController) {
        SearchResultViewController *resultController = [SearchResultViewController new];
        __weak typeof(self) weakSelf = self;
        [resultController selectedCityHandle:^(NSString *name) {
            
            [weakSelf selectedCity:name];
            [weakSelf.searchController dismissViewControllerAnimated:YES completion:nil];
            weakSelf.searchController = nil ;
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

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[StyleTwoTableViewCell class] forCellReuseIdentifier:THotCell];
        tableView.rowHeight = 44.f;
        tableView.sectionHeaderHeight = 28.f;
        tableView.sectionIndexColor = [UIColor lightGrayColor];
        tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView = tableView;
        _tableView.tableHeaderView = self.searchBar ;
    }
    return _tableView;
}
- (UISearchBar *)searchBar {
    if (!_searchBar) {
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.bounds.size.width, 40)];
        searchBar.delegate = self;
        searchBar.placeholder = @"搜索城市名称/首字母缩写";
        _searchBar = searchBar;
    }
    return _searchBar;
}
-(void)loadData
{
    NSArray *rootArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cityGroups" ofType:@"plist"]];
    self.cityGroups = [NSMutableArray arrayWithCapacity:rootArray.count];
    for (NSDictionary *groupDictionary in rootArray) {
        CityGroup *group = [[CityGroup alloc]initWithDictionary:groupDictionary];
        [self.cityGroups addObject:group];
    }
}
-(NSMutableDictionary *)cellHeightDictionary
{
    if (!_cellHeightDictionary) {
        _cellHeightDictionary = [NSMutableDictionary dictionary];
    }
    return _cellHeightDictionary;
}
-(NSArray<Citys *> *)allCities
{
    if (!_allCities) {
        NSMutableArray<Citys *> *allData = [NSMutableArray array];
        int index = 0;
        for (CityGroup *citysGroup in _cityGroups) {// 获取所有的city
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
        _allCities = allData;
    }
    return _allCities;
}
@end
