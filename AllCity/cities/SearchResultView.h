//
//  SearchRetView.h
//  AllUWant
//
//  Created by wanghe on 2017/3/2.
//  Copyright © 2017年 wanghe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelectCityTableViewController;

@interface SearchResultView : UIView
@property(nonatomic, strong) NSMutableArray* allCities;
@property(nonatomic, strong) SelectCityTableViewController* parentVc;
@end
