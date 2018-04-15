//
//  ResultCityController.m
//  MySelectCityDemo
//
//  Created by 李阳 on 15/9/2.
//  Copyright (c) 2015年 WXDL. All rights reserved.
//

#import "ResultCityController.h"

@implementation ResultCityController
-(UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:@"Cell"] ;
    }
    if ([self.dataArray count]) {
        _provinceModel = self.dataArray[indexPath.row];
    }
    NSString *nameStr = [NSString stringWithFormat:@"%@",_provinceModel.city];
    if (IsNilOrNull(nameStr)) {
        nameStr = @"";
    }
    // 一般我们就可以在这开始设置这个cell了，比如设置文字等：
    cell.textLabel.text = nameStr;
    cell.textLabel.font = MAIN_TITLE_FONT;
    cell.textLabel.textColor = TitleColor;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataArray count]) {
        _provinceModel = self.dataArray[indexPath.row];
    }
    NSString *nameStr = [NSString stringWithFormat:@"%@",_provinceModel.city];
    if (IsNilOrNull(nameStr)) {
        nameStr = @"";
    }
    if([_delegate respondsToSelector:@selector(didSelectedProVinceString:andCityStr:)])
    {
        [_delegate didSelectedProVinceString:self.provinceStr andCityStr:nameStr];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   if([_delegate respondsToSelector:@selector(didScroll)])
   {
       [_delegate didScroll];
   }
}
@end
