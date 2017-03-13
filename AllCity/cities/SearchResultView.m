//
//  SearchRetView.m
//  AllUWant
//
//  Created by wanghe on 2017/3/2.
//  Copyright © 2017年 wanghe. All rights reserved.
//
#import "SelectCityTableViewController.h"
#import "SearchResultView.h"

@interface SearchResultView()<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating>
{
    UISearchController* _searchController;
    
    NSMutableArray* _preArray;
    
    UITapGestureRecognizer* _tapGesture;
}
@property(nonatomic, strong) UITableView* tableView;
@property(nonatomic, strong) NSMutableArray* datasources;
@end

@implementation SearchResultView

- (instancetype) initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.datasources = [NSMutableArray new];
        _preArray = [NSMutableArray new];
        
        self.userInteractionEnabled = YES;
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSearchView)];
        [self addGestureRecognizer:_tapGesture];
        
        self.backgroundColor = [UIColor clearColor];
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *visualView = [[UIVisualEffectView alloc] initWithEffect:effect];
        visualView.frame = [[UIScreen mainScreen] bounds];
        [self addSubview:visualView];
        visualView.alpha = 0.6;
        
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)+300) style:UITableViewStylePlain];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = [UIView new];
        [self addSubview:self.tableView];
        self.tableView.hidden = YES;
    }
    return self;
}

- (void) closeSearchView{
    if(_searchController && self.tableView.hidden==YES){
        [_searchController setActive:NO];
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    cell.textLabel.text = self.datasources[indexPath.row];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.0f;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasources.count;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.datasources.count==1 && [self.datasources[0] rangeOfString:@"抱歉"].length != 0){
        
    }else{
        [self.parentVc popViewControllerForSelected:self.datasources[indexPath.row]];
        [_searchController setActive:NO];
        [self removeFromSuperview];
    }
    
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
    NSString *searchString = _searchController.searchBar.text;
    if(searchString.length > 0){
        self.tableView.hidden = NO;
        [self.tableView reloadData];
        [self removeGestureRecognizer:_tapGesture];
    }else{
        self.tableView.hidden = YES;
        [self addGestureRecognizer:_tapGesture];
    }
    if(!_searchController){
        _searchController = searchController;
    }
    
    if(_preArray.count == 0){
        for(NSArray* arrys in self.allCities){
            for(NSDictionary* dic in arrys){
                [_preArray addObject:dic[@"name"]];
            }
        }
    }
    
    
    [self.datasources removeAllObjects];
    if (searchString.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", searchString];
        
        [self.datasources addObjectsFromArray:[_preArray filteredArrayUsingPredicate:predicate]];
        
        if(self.datasources.count == 0){
            [self.datasources addObject:@"抱歉,未找到该地区!"];
        }
        [self.tableView reloadData];
    }else{
        //如果搜索关键字为空则显示所有key
        
    }
}

- (UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView* resultView = [super hitTest:point withEvent:event];
    
    CGPoint tablePoint = [self.tableView convertPoint:point toView:self];
    if([self.tableView pointInside:tablePoint withEvent:event] && self.tableView.hidden == NO){
        return self.tableView;
    }
    return resultView;
}


@end
