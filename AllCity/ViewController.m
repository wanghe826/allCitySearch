//
//  ViewController.m
//  AllCity
//
//  Created by wanghe on 2017/3/13.
//  Copyright © 2017年 wanghe. All rights reserved.
//

#import "ViewController.h"
#import "SelectCityTableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)toSelectCity:(id)sender {
    
    SelectCityTableViewController* vc = [SelectCityTableViewController new];
    vc.selectCallback = ^(NSString* city){
        NSLog(@"选择了--->%@", city);
    };
    UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navi animated:YES completion:nil];
}
@end
