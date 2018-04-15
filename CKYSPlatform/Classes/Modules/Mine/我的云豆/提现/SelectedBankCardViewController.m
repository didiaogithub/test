//
//  SelectedBankCardViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/11/3.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import "SelectedBankCardViewController.h"
#import "BankCardTableViewCell.h"
#import "AddBankCardViewController.h"
#import "CardModel.h"
@interface SelectedBankCardViewController ()<UITableViewDelegate,UITableViewDataSource,BankCardTableViewCellDelegate>
{
    UIButton *selectedButton;
    NSString *_ckidString;
    CardModel *_cardModel;
}
@property(nonatomic,strong)UITableView *bankCardTableView;
@property(nonatomic,strong)NSMutableArray *cardArray;

@end

@implementation SelectedBankCardViewController
-(NSMutableArray *)cardArray{
    if (_cardArray == nil) {
        _cardArray = [[NSMutableArray alloc] init];
    }
    return _cardArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择银行卡";
    _ckidString = KCKidstring;
    if (IsNilOrNull(_ckidString)) {
        _ckidString = @"";
    }
    [CKCNotificationCenter addObserver:self selector:@selector(addCardScucess:) name:@"addcard" object:nil];
    [self createTableView];
     [self getBankCardData];
}
#pragma mark-添加银行卡成功
-(void)addCardScucess:(NSNotification *)notice{
    //刷新数据
    [self.cardArray removeAllObjects];
    [self getBankCardData];
}

/**获取银行卡列表*/
-(void)getBankCardData{
    [self.cardArray removeAllObjects];
    
    if (IsNilOrNull(_ckidString)){
        _ckidString = @"";
    }
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSDictionary *pramaDic = @{@"ckid":_ckidString,DeviceId:uuid};

    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getBankCardList_Url];
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        NSDictionary *dict= json;
        NSArray *bankArr = dict[@"bankCard"];
        for (NSDictionary *cardDic in bankArr){
            _cardModel = [[CardModel alloc] init];
            [_cardModel setValuesForKeysWithDictionary:cardDic];
            [self.cardArray addObject:_cardModel];
        }
        [self.bankCardTableView reloadData];
        
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}
-(void)createTableView{

    if (@available(iOS 11.0, *)){
         _bankCardTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64+AdaptedHeight(10), SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    }else{
       _bankCardTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,AdaptedHeight(10), SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    _bankCardTableView.showsVerticalScrollIndicator = NO;
    _bankCardTableView.rowHeight = UITableViewAutomaticDimension;
    _bankCardTableView.estimatedRowHeight = 44;
    _bankCardTableView.backgroundColor = [UIColor tt_grayBgColor];
    _bankCardTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_bankCardTableView];
    _bankCardTableView.delegate = self;
    _bankCardTableView.dataSource = self;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    UIImageView *bankImageView = [[UIImageView alloc] init];
    [headerView addSubview:bankImageView];
    [bankImageView setImage:[UIImage imageNamed:@"savenextbank"]];
    [bankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(30));
        make.left.mas_offset(AdaptedWidth(35));
        make.height.mas_offset(AdaptedHeight(40));
        make.right.mas_offset(-AdaptedWidth(35));
    }];
 
    
    UIButton *addCardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [headerView addSubview:addCardButton];
    [addCardButton setTitle:@"+添加新的银行卡" forState:UIControlStateNormal];
    addCardButton.titleLabel.font = MAIN_SAVEBUTTON_FONT;
    [addCardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addCardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bankImageView);
    }];
    [addCardButton addTarget:self action:@selector(clickAddButton) forControlEvents:UIControlEventTouchUpInside];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
     return AdaptedHeight(80);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.cardArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BankCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BankCardTableViewCell"];
    if (cell == nil) {
        cell = [[BankCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BankCardTableViewCell"];
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.row = indexPath.row;
    if ([self.cardArray count]) {
        _cardModel = self.cardArray[indexPath.row];
        [cell refreshWithModel:_cardModel];
    }
    return cell;
  
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.cardArray count]){
      _cardModel = self.cardArray[indexPath.row];
    }
    if (_bankcardBlock) {
        _bankcardBlock(_cardModel);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setBankcardBlock:(TransBlock)bankcardBlock{
    _bankcardBlock = bankcardBlock;

}

/**设置默认银行卡*/
-(void)setDefaultBankCardWithRow:(NSInteger)row andButton:(UIButton *)button{
    button.userInteractionEnabled = NO;
    if ([self.cardArray count]) {
        _cardModel = self.cardArray[row];
    }
    if (IsNilOrNull(_ckidString)){
        _ckidString = @"";
    }
    NSString *idstr = [NSString stringWithFormat:@"%@",_cardModel.ID];
    if (IsNilOrNull(idstr)){
        idstr = @"";
    }
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,setDefaultBankCard_Url];
    NSDictionary *pramaDic = @{@"ckid":_ckidString,@"id":idstr,DeviceId:uuid};
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        NSDictionary *dict= json;
        if([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        button.userInteractionEnabled = YES;
        [self getBankCardData];
        
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}
#pragma mark-删除银行卡之后 带回删除的id
-(void)setBackBlock:(BackBlock)backBlock{
    _backBlock = backBlock;
}
#pragma mark-作滑删除
//左滑删除
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *delectRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath){
        
        if([self.cardArray count]){
            _cardModel = self.cardArray[indexPath.row];
        }
        NSString *cardId = [NSString stringWithFormat:@"%@",_cardModel.ID];
        if (IsNilOrNull(cardId)) {
            cardId = @"";
        }
        if (IsNilOrNull(_ckidString)){
            _ckidString = @"";
        }
        NSString *uuid = DeviceId_UUID_Value;
        if (IsNilOrNull(uuid)){
            uuid = @"";
        }
        NSDictionary * pramaDic = @{@"ckid":_ckidString,@"bankcardId":cardId,DeviceId:uuid};
        NSString *deleteBankCardUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,deleteBankCard_Url];
        
        [self.view addSubview:self.viewDataLoading];
        [self.viewDataLoading startAnimation];
        [HttpTool postWithUrl:deleteBankCardUrl params:pramaDic success:^(id json) {
            [self.viewDataLoading stopAnimation];
            NSDictionary *dict = json;
            if ([dict[@"code"] integerValue] != 200) {
                [self showNoticeView:dict[@"codeinfo"]];
                return ;
            }
            if (_backBlock){
               _backBlock(cardId);
            }
            //删除成功之后删除数组数据
            if ([self.cardArray count]) {
                if ((self.cardArray.count-1) > indexPath.row || (self.cardArray.count-1) == indexPath.row ) {
                    [self.cardArray removeObjectAtIndex:indexPath.row];
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                }
                
            }
        } failure:^(NSError *error) {
            [self.viewDataLoading stopAnimation];
            if (error.code == -1009) {
                [self showNoticeView:NetWorkNotReachable];
            }else{
                [self showNoticeView:NetWorkTimeout];
            }
        }];
    }];
    return @[delectRowAction];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
#pragma mark-点击添加新的银行卡
-(void)clickAddButton{
    AddBankCardViewController *addBankCard = [[AddBankCardViewController alloc] init];
    [self.navigationController pushViewController:addBankCard animated:YES];

}


@end
