//
//  SelectCityTableViewController.h
//  AllUWant
//
//  Created by wanghe on 2017/3/2.
//  Copyright © 2017年 wanghe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectCityTableViewController : UITableViewController
@property(nonatomic, strong) void (^selectCallback)(NSString* city);

- (void) popViewControllerForSelected:(NSString*)city;
@end
