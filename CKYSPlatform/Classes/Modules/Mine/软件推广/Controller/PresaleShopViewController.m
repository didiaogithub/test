//
//  DBusinessSchoolViewController.m
//  CKYSPlatform
//
//  Created by ckys on 16/6/28.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "PresaleShopViewController.h"
#import "ClassDetailViewController.h"
#import "PresaleView.h"
#import "AllPresaleShopTableViewCell.h"
#import "PresaleShopModel.h"
#import "PresaleDetailModel.h"

static NSString *CellIdentifier = @"AllPresaleShopTableViewCell";

@interface PresaleShopViewController ()<UITableViewDelegate,UITableViewDataSource,PresaleViewDelegate,AllPresaleShopTableViewCellDelegate>
{
    BOOL _isOpen[1000];
    NSString *_ckidString;
    
    PresaleView *_presaleView;
    PresaleShopModel *_preSaleModel;
    PresaleDetailModel *_presaleDetailModel;
    NSString *_isRefreshing;

}
@property(nonatomic,strong)UITableView *presaleTableView;
@property(nonatomic,strong)NSMutableArray *presaleArray;
@end

@implementation PresaleShopViewController

-(NSMutableArray *)presaleArray{
    if (_presaleArray == nil) {
        _presaleArray = [[NSMutableArray alloc] init];
    }
    return _presaleArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"预售店铺管理";
    _ckidString = KCKidstring;
    if (IsNilOrNull(_ckidString)) {
        _ckidString = @"";
    }
    [self getPresaleData];
    [self createTableView];
    [self refreshData];
}

/**获取预售店铺列表*/
-(void)getPresaleData{
    [self.presaleArray removeAllObjects];
    if (IsNilOrNull(_ckidString)){
        _ckidString = @"";
    }
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    //一次性获取已开通  未开通列表
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getCkPreSale_Url];
    NSDictionary *pramaDic = @{@"ckid":_ckidString,DeviceId:uuid};
    
    if (IsNilOrNull(_isRefreshing)){
        [[UIApplication sharedApplication].keyWindow addSubview:self.viewDataLoading];
        [self.viewDataLoading startAnimation];
    }
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        [self.viewDataLoading stopAnimation];
        [self.presaleTableView.mj_header endRefreshing];
        [self.presaleTableView.mj_footer endRefreshing];
        NSDictionary *dict = json;
        if([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        NSArray *listArr = dict[@"list"];
        for (NSDictionary * listDic in listArr) {
            NSArray *saleListArr = listDic[@"salelist"];
            _preSaleModel = [PresaleShopModel getpreSaleModelWithDictionary:listDic];
            if ([saleListArr count] ){
                [self.presaleArray addObject:_preSaleModel];
            }
        }
        [self.presaleTableView reloadData];
    } failure:^(NSError *error) {
        [self.presaleTableView.mj_header endRefreshing];
        [self.presaleTableView.mj_footer endRefreshing];
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}
-(void)createTableView{
    
    _presaleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64-NaviAddHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_presaleTableView];
    _presaleTableView.backgroundColor = [UIColor tt_grayBgColor];
    _presaleTableView.rowHeight = UITableViewAutomaticDimension;
    _presaleTableView.estimatedRowHeight = 44;
    _presaleTableView.delegate = self;
    _presaleTableView.dataSource = self;
    _presaleTableView.showsVerticalScrollIndicator = NO;
    _presaleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
#pragma mark-tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.presaleArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isOpen[section]) {
        _preSaleModel = self.presaleArray[section];
        return _preSaleModel.salelistArray.count;
    }
    else
    {
        //如果是关闭的就返回0
        return 0;
    }
}
/**段头 自定义sectionHeader*/
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _presaleView = [[PresaleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AdaptedHeight(70)) andSection:section];
    _presaleView.delegate = self;
    _presaleView.presaleShopNameLable.text = [NSString stringWithFormat:@"预售店组%ld",section+1];
    if([self.presaleArray count]){
        _preSaleModel = self.presaleArray[section];
        [self refreshHeaderModel:_preSaleModel];
    }
    return _presaleView;
}
#pragma mark-刷新段头数据
-(void)refreshHeaderModel:(PresaleShopModel *)saleModel{

    //本组投资时间
    NSString *saletime = [NSString stringWithFormat:@"%@",_preSaleModel.saletime];
    if(IsNilOrNull(saletime)){
        saletime = @"";
    }
    _presaleView.timeLable.text = [NSString stringWithFormat:@"投资时间:%@",saletime];
    
    //本组总数
    NSString *allcount = [NSString stringWithFormat:@"%@",_preSaleModel.allcount];
    if(IsNilOrNull(allcount)){
        allcount = @"";
    }

    //已开通店铺数
    NSString *opencount = [NSString stringWithFormat:@"%@",_preSaleModel.opencount];
    //预售店剩余回收时间
    NSString *leftdays = [NSString stringWithFormat:@"%@",_preSaleModel.days];
    if(IsNilOrNull(opencount)){
        opencount = @"";
    }
    if(IsNilOrNull(leftdays)){
        leftdays = @"";
    }
    NSLog(@"剩余天数%@",leftdays);
    int allcountNum = [allcount intValue];
    int opencountNum = [opencount intValue];
    _presaleView.ratioLable.text = [NSString stringWithFormat:@"%d/%d",opencountNum,allcountNum];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_presaleView.ratioLable.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    NSInteger length = opencount.length;
    NSRange range = {0,length};
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    // 设置颜色
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor tt_redMoneyColor] range:range];

    _presaleView.ratioLable.attributedText = attributedString;
    if([opencount intValue] > 0){ //开通数大于0 不显示倒计时
        _presaleView.countdownImageView.hidden = YES;
        _presaleView.remainingLable.hidden = YES;
    }else{
        _presaleView.countdownImageView.hidden = NO;
        _presaleView.remainingLable.hidden = NO;
        _presaleView.remainingLable.text = [NSString stringWithFormat:@"%@天",leftdays]; //剩余回收时间
        
    }
   
    //本组已回收的数量
    NSString *recycle = [NSString stringWithFormat:@"%@",_preSaleModel.recycle];
    if(IsNilOrNull(recycle)){
        recycle = @"";
    }
    if([allcount isEqualToString:recycle]){  //已回收和 本组数量相等说明本组已经全部回收
        _presaleView.returnView.hidden = NO;
        _presaleView.recyclingImageView.hidden = NO;
        _presaleView.headerButton.userInteractionEnabled = NO;
    }else{
        //未回收
        _presaleView.returnView.hidden = YES;
        _presaleView.recyclingImageView.hidden = YES;
        _presaleView.headerButton.userInteractionEnabled = YES;
    }
    
}
/**段头*/
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return AdaptedHeight(70);

}
/**点击头部按钮*/
-(void)clickPresaleButton:(UIButton *)button{
    _isOpen[button.tag] = !_isOpen[button.tag];
    [_presaleTableView reloadData];
    //动画重载一个区
    //[_schoolTableView reloadSections:[NSIndexSet indexSetWithIndex:button.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AllPresaleShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AllPresaleShopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.delegate = self;
    cell.index = indexPath.row;
    cell.section = indexPath.section;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor tt_grayBgColor];
    if([self.presaleArray count]){
        _preSaleModel = self.presaleArray[indexPath.section];
        if ([_preSaleModel.salelistArray count]){
            _presaleDetailModel = _preSaleModel.salelistArray[indexPath.row];
            [cell refreshWithModel:_presaleDetailModel];
        }
        
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
}
#pragma mark-点击 复制1200  开通按钮1201按钮代理方法
-(void)clickDeatailButton:(UIButton *)button Index:(NSInteger)index andSection:(NSInteger)section{
    
    if([self.presaleArray count]){
        _preSaleModel = self.presaleArray[section];
        _presaleDetailModel = _preSaleModel.salelistArray[index];
    }
    //已开通  待开通  未出售
    NSString *status = [NSString stringWithFormat:@"%@",_presaleDetailModel.status];
    if(IsNilOrNull(status)){
       status = @"";
    }
    NSString *preyqcode = [NSString stringWithFormat:@"%@",_presaleDetailModel.preyqcode];
    if(IsNilOrNull(preyqcode)){
        preyqcode = @"";
    }
    
    NSInteger buttonTag = button.tag - 1200;
    if(buttonTag == 0){//点击复制
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = preyqcode;
        if(pasteboard == nil){
            [self showNoticeView:@"复制失败"];
        }else{
            [self showNoticeView:@"复制成功"];
        }
    }else{ //点击开通按钮  未出售  和 已开通点击不处理
        if ([status isEqualToString:@"待开通"]){
            [MessageAlert shareInstance].isDealInBlock = YES;
            [[MessageAlert shareInstance] hiddenCancelBtn:NO];
            [[MessageAlert shareInstance] showCommonAlert:@"确定开通预售店铺？" btnClick:^{
                
                _ckidString = KCKidstring;
                if (IsNilOrNull(_ckidString)){
                    _ckidString = @"";
                }
                if ([self.presaleArray count]) {
                    _preSaleModel = self.presaleArray[section];
                    _presaleDetailModel = _preSaleModel.salelistArray[index];
                }
                NSString *uuid = DeviceId_UUID_Value;
                if (IsNilOrNull(uuid)){
                    uuid = @"";
                }
                
                NSString *shopId = [NSString stringWithFormat:@"%@",_presaleDetailModel.ID];
                NSString *requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,openPreSaleShop_Url];
                //  店铺id
                NSDictionary *pramaDic = @{@"id":shopId,DeviceId:uuid,@"ckid":_ckidString};
                [self.view addSubview:self.viewDataLoading];
                [self.viewDataLoading startAnimation];
                
                [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
                    [self.viewDataLoading stopAnimation];
                    NSDictionary *dict = json;
                    if([dict[@"code"] integerValue] != 200){
                        [self showNoticeView:dict[@"codeinfo"]];
                        return ;
                    }
                    [self getPresaleData];
                } failure:^(NSError *error) {
                    [self.viewDataLoading stopAnimation];
                    if (error.code == -1009) {
                        [self showNoticeView:NetWorkNotReachable];
                    }else{
                        [self showNoticeView:NetWorkTimeout];
                    }
                }];
                
                
                
            }];

        }

    }
}
-(void)refreshData{
    __typeof (self) __weak weakSelf = self;
    self.presaleTableView.mj_header = [MJGearHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _isRefreshing = @"1";
        [weakSelf.presaleTableView.mj_header beginRefreshing];
        NSDate *nowDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yyy-MM-dd HH:mm:ss";
        weakSelf.endInterval = [nowDate timeIntervalSince1970];
        
        NSTimeInterval value = weakSelf.endInterval - weakSelf.startInterval;
        CGFloat second = [[NSString stringWithFormat:@"%.2f",value] floatValue];//秒
        NSLog(@"间隔------%f秒",second);
        weakSelf.startInterval = weakSelf.endInterval;
        
        RequestReachabilityStatus status = [RequestManager reachabilityStatus];
        switch (status) {
            case RequestReachabilityStatusReachableViaWiFi:
            case RequestReachabilityStatusReachableViaWWAN: {
                if (value >= Interval) {
                    [weakSelf getPresaleData];
                }else{
                    [weakSelf.presaleTableView.mj_header endRefreshing];
                }
            }
                break;
            default: {
                [self showNoticeView: NetWorkNotReachable];
                [weakSelf.presaleTableView.mj_header endRefreshing];
            }
                break;
        }
    }];
    
    self.presaleTableView.mj_footer = [MJGearFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _isRefreshing = @"2";
        RequestReachabilityStatus status = [RequestManager reachabilityStatus];
        switch (status) {
            case RequestReachabilityStatusReachableViaWiFi:
            case RequestReachabilityStatusReachableViaWWAN: {
                [weakSelf getPresaleData];
                [weakSelf.presaleTableView.mj_footer endRefreshing];
            }
                break;
            default: {
                [self showNoticeView: NetWorkNotReachable];
                [weakSelf.presaleTableView.mj_footer endRefreshing];
            }
                break;
        }
    }];
}

@end
