//
//  SelectCityTableViewController.m
//  AllUWant
//
//  Created by wanghe on 2017/3/2.
//  Copyright © 2017年 wanghe. All rights reserved.
//

#import "SelectCityTableViewController.h"
#import "BMChineseSort.h"
#import "SearchResultView.h"

@interface SelectCityTableViewController ()<UISearchControllerDelegate>
@property(nonatomic, strong) NSMutableArray* indexArray;
@property(nonatomic, strong) NSMutableArray* citiesArray;

@property(nonatomic, strong) UISearchController* searchController;
@property(nonatomic, strong) SearchResultView* searchResultView;

@end

@implementation SelectCityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    self.indexArray = [defaults valueForKey:@"indexArray"];
    self.citiesArray = [defaults valueForKey:@"citiesArray"];
    
    if(!self.indexArray | !self.citiesArray){
        self.indexArray = [NSMutableArray new];
        self.citiesArray = [NSMutableArray new];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData* data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"citydata" ofType:@"json"]];
            NSArray* cities = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil] objectForKey:@"data"];
            self.indexArray = [BMChineseSort IndexWithArray:cities Key:@"name"];
            self.citiesArray = [BMChineseSort sortObjectArray:cities Key:@"name"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            [defaults setValue:self.indexArray forKey:@"indexArray"];
            [defaults setValue:self.citiesArray forKey:@"citiesArray"];
            [defaults synchronize];
        });
    }else{
        [self.tableView reloadData];
    }
    [self initNavigationBar];
    [self setSearchControllerView];
}


- (void) setupSearchResultView{
    self.searchResultView = [[SearchResultView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 700)];
//    self.searchResultView.backgroundColor = [UIColor greenColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self.searchResultView];
    self.searchResultView.hidden = YES;
}

- (SearchResultView*) searchResultView{
    if(!_searchResultView){
        _searchResultView = [[SearchResultView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 500)];
//        [self.view.window addSubview:_searchResultView];
        [[UIApplication sharedApplication].keyWindow addSubview:_searchResultView];
        _searchResultView.allCities = self.citiesArray;
        _searchResultView.parentVc = self;
        _searchResultView.hidden = YES;
    }
    return _searchResultView;
}

- (void)setSearchControllerView{
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchController.searchBar.placeholder = @"城市/行政区";
    self.searchController.searchBar.frame = CGRectMake(0, 0, 0, 44);
    self.searchController.dimsBackgroundDuringPresentation = false;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.backgroundColor = [UIColor whiteColor];
//    self.searchController.searchBar.barTintColor = [UIColor whiteColor];
    self.searchController.searchResultsUpdater = (id<UISearchResultsUpdating>)self.searchResultView;
    self.searchController.delegate = self;
}

#pragma mark SearchConroller Delegate
- (void)willPresentSearchController:(UISearchController *)searchController{
    
}
- (void)didPresentSearchController:(UISearchController *)searchController{
    self.searchResultView.hidden = NO;
}
- (void)willDismissSearchController:(UISearchController *)searchController{
    self.searchResultView.hidden = YES;
}
- (void)didDismissSearchController:(UISearchController *)searchController{
    
}


- (void) initNavigationBar{
    self.title = @"选择城市";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIImage* image = [UIImage imageNamed:@"closedLeftNavi"];
    UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn addTarget:self action:@selector(closeViewController) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.frame = CGRectMake(0, 0, 30, 30);
    [closeBtn setImage:image forState:UIControlStateNormal];
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:closeBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

- (void) closeViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView -
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.indexArray objectAtIndex:section];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.indexArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.citiesArray objectAtIndex:section] count];
}
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.indexArray;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString* city = [[[self.citiesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"];
    [self popViewControllerForSelected:city];
}
//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    NSString* city = [[[self.citiesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.textLabel.text = city;
    return cell;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void) popViewControllerForSelected:(NSString*)city{
    [self dismissViewControllerAnimated:YES completion:^{
        _selectCallback(city);
    }];
}

@end
