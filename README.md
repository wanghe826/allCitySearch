# allCitySearch
中国所有城市的列表以及搜索
##使用方法：
```objective-c
SelectCityTableViewController* vc = [SelectCityTableViewController new];
    vc.selectCallback = ^(NSString* city){
        NSLog(@"选择了--->%@", city);
    };
UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:vc];
[self presentViewController:navi animated:YES completion:nil];

```

![Aaron Swartz](https://github.com/wanghe826/allCitySearch/blob/master/selectCity.gif)


