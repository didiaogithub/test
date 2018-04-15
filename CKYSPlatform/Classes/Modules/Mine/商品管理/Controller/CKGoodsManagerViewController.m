//
//  CKGoodsManagerViewController.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/1/9.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKGoodsManagerViewController.h"
#import "CKGoodsManagerCell.h"
#import "GoodModel.h"

@interface CKGoodsManagerViewController ()<UITableViewDelegate, UITableViewDataSource, CKGoodsManagerCellDelegate>
{
    UIView *_topView;
    UIButton *_hasShopButton;
    UIButton *_noShopButton;
    UILabel *_bottomLine;
    UIButton *_allSelectedButton;
    UIButton *_functionButton;
    NSString *type;
    NSString *_ckidstring;
    GoodModel *_goodModel;
}
@property(nonatomic,strong)NSMutableArray *dataSourceArray;
@property(nonatomic,strong)UITableView *shopManagerTableView;

@end

@implementation CKGoodsManagerViewController

-(NSMutableArray *)dataSourceArray{
    if (_dataSourceArray == nil) {
        _dataSourceArray = [[NSMutableArray alloc] init];
    }
    return _dataSourceArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"店铺管理";
    _ckidstring = KCKidstring;
    if (IsNilOrNull(_ckidstring)) {
        _ckidstring = @"";
    }
    [self createViews];
    [self creteBottomView];
    [self getShopManagerDataWithType:@"1"];
    
}
/**获取2已下架 或者已上架 1商品列表*/
-(void)getShopManagerDataWithType:(NSString *)typestr{
    [self.dataSourceArray removeAllObjects];
    NSString *requestUrl = nil;
    if ([typestr isEqualToString:@"1"]) { //获取已上架
        requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getGoodsOnSale_Url];
    }else{ //获取已下架2
        requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getGoodsOffShelves_Url];
        
    }
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSDictionary *pramaDic = @{@"ckid":_ckidstring,DeviceId:uuid};
    [self.view addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        if([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        
        NSArray *onsaleArr = dict[@"items"];
        for (NSDictionary *saleDic in onsaleArr) {
            _goodModel = [[GoodModel alloc] init];
            [_goodModel setValuesForKeysWithDictionary:saleDic];
            [self.dataSourceArray addObject:_goodModel];
        }
        [self.shopManagerTableView reloadData];
        
    } failure:^(NSError *error) {
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
    
    
}
-(void)createViews{
    
    float buttonW= (SCREEN_WIDTH)/2;
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH, AdaptedHeight(40))];
    [_topView setBackgroundColor:[UIColor tt_redMoneyColor]];
    [self.view addSubview:_topView];
    
    //已上架按钮
    _hasShopButton = [self createOrderButtonWithframe:CGRectMake(0, 0, buttonW, AdaptedHeight(40)) andTag:888 andAction:@selector(clickManagerButton:)  andNomalImage:[UIImage imageNamed:@"onsalewhite"]];
    [_topView addSubview:_hasShopButton];
    
    
    //未上架按钮
    _noShopButton = [self createOrderButtonWithframe:CGRectMake(CGRectGetMaxX(_hasShopButton.frame), 0, buttonW, AdaptedHeight(40)) andTag:889 andAction:@selector(clickManagerButton:) andNomalImage:[UIImage imageNamed:@"offsalewhite"]];
    [_topView addSubview:_noShopButton];
    
    
    float lineX = _hasShopButton.imageView.frame.origin.x;
    float width = _hasShopButton.imageView.frame.size.width;
    
    _bottomLine = [[UILabel alloc] init];
    [_topView addSubview:_bottomLine];
    _bottomLine.backgroundColor = [UIColor whiteColor];
    _bottomLine.layer.cornerRadius = 2;
    _bottomLine.clipsToBounds = YES;
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(lineX-5);
        make.bottom.mas_offset(-AdaptedHeight(3));
        make.width.mas_offset(width+10);
        make.height.mas_offset(4);
    }];
    
    
    _shopManagerTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _shopManagerTableView.delegate  = self;
    _shopManagerTableView.dataSource = self;
    _shopManagerTableView.backgroundColor = [UIColor whiteColor];
    self.shopManagerTableView.rowHeight = UITableViewAutomaticDimension;
    self.shopManagerTableView.estimatedRowHeight = 44;
    _shopManagerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_shopManagerTableView];
    [_shopManagerTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.left.right.mas_offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50-BOTTOM_BAR_HEIGHT);
    }];
    
}
/**点击 已上架 或者 已下架按钮 触发点击事件*/
-(void)clickManagerButton:(UIButton *)button{
    button.selected = !button.selected;
    float lineX = _noShopButton.imageView.frame.origin.x;
    float offsaleX = _noShopButton.imageView.frame.size.width;
    if (button.tag == 888) { //上架按钮
        type = @"1";
        [self getShopManagerDataWithType:type];
        _hasShopButton.selected = YES;
        _noShopButton.selected = NO;
        _hasShopButton.userInteractionEnabled = NO;
        _noShopButton.userInteractionEnabled = YES;
        [_functionButton setTitle:@"下架" forState:UIControlStateNormal];
        [self anamationWithLeft:lineX];
    }else{ //下架按钮
        type = @"2";
        [self getShopManagerDataWithType:type];
        _hasShopButton.selected = NO;
        _noShopButton.selected = YES;
        _hasShopButton.userInteractionEnabled = YES;
        _noShopButton.userInteractionEnabled = NO;
        [_functionButton setTitle:@"上架" forState:UIControlStateNormal];
        [self anamationWithLeft:SCREEN_WIDTH-lineX-offsaleX];
        
    }
    
}
-(void)anamationWithLeft:(float)leftx{
    [UIView animateWithDuration:0.25 animations:^{
        [_bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(leftx-5);
        }];
    }];
    
}


#pragma mark-tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CKGoodsManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CKGoodsManagerCell"];
    if (cell == nil) {
        cell = [[CKGoodsManagerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CKGoodsManagerCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    if ([self.dataSourceArray count]) {
        _goodModel = [self.dataSourceArray objectAtIndex:indexPath.row];
        [cell setModel:_goodModel];
    }
    return cell;
}

#pragma mark - 点击单选按钮 代理方法
- (void)singleClickCell:(CKGoodsManagerCell *)ckGoodsManagerCell goodsModel:(GoodModel *)goodsModel {
    _goodModel = goodsModel;
    NSMutableArray *array =  [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0;i<self.dataSourceArray.count;i++) {
        goodsModel  = self.dataSourceArray[i];
        if (goodsModel.isSelect){
            [array addObject:goodsModel];
            if (array.count == self.dataSourceArray.count) {
                _allSelectedButton.selected = YES;
            }
        }else{
            _allSelectedButton.selected = NO;
        }
    }
}
/**创建底部view*/
- (void)creteBottomView {
    UIView *bottomView = [[UIView alloc] init];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = [UIColor whiteColor];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(-BOTTOM_BAR_HEIGHT);
    }];
    
    UILabel *line = [UILabel creatLineLable];
    [bottomView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, 1));
    }];
    
    _allSelectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:_allSelectedButton];
    
    UIImage * nomalImage = [UIImage imageNamed:@"giftwhite"];
    UIImage * selectedImage = [UIImage imageNamed:@"pinkselected"];
    [_allSelectedButton setImage:nomalImage forState:UIControlStateNormal];
    [_allSelectedButton setImage:selectedImage forState:UIControlStateSelected];
    [_allSelectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(AdaptedHeight(10));
        make.left.mas_offset(AdaptedWidth(15));
        make.bottom.mas_offset(-AdaptedHeight(10));
    }];
    [_allSelectedButton addTarget:self action:@selector(clickAllSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *textLable = [UILabel configureLabelWithTextColor:TitleColor textAlignment:NSTextAlignmentLeft font:MAIN_BODYTITLE_FONT];
    [bottomView addSubview:textLable];
    textLable.text = @"全选";
    [textLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_allSelectedButton);
        make.left.equalTo(_allSelectedButton.mas_right).offset(AdaptedWidth(10));
    }];
    
    UIImageView *bankImageView = [[UIImageView alloc] init];
    [bottomView addSubview:bankImageView];
    [bankImageView setImage:[UIImage imageNamed:@"goodmanage"]];
    [bankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(7);
        make.right.mas_offset(-5);
        make.bottom.mas_offset(-7);
        make.width.mas_offset(130);
    }];
    
    //上架 或者 下架按钮
    _functionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:_functionButton];
    [_functionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bankImageView);
    }];
    [_functionButton setTitle:@"下架" forState:UIControlStateNormal];
    [_functionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _functionButton.titleLabel.font = MAIN_TITLE_FONT;
    [_functionButton addTarget:self action:@selector(clickFuntionButton:) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark-点击全选按钮
-(void)clickAllSelectedButton:(UIButton *)button{
    button.selected = !button.selected;
    BOOL btselected = button.selected;
    for (int i =0; i<self.dataSourceArray.count; i++) {
        _goodModel = (GoodModel *)[self.dataSourceArray objectAtIndex:i];
        if (btselected){
            _goodModel.isSelect = YES;
        }else{
            _goodModel.isSelect = NO;
        }
    }
    [self.shopManagerTableView reloadData];
}

#pragma mark-/**点击上架  下架按钮*/
-(void)clickFuntionButton:(UIButton *)button{
    NSMutableArray *selectedArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0;i<self.dataSourceArray.count;i++) {
        _goodModel = [self.dataSourceArray objectAtIndex:i];
        if (_goodModel.isSelect) {//选中
            [selectedArr addObject:_goodModel];
        }
    }
    if (![selectedArr count]) {
        [self showNoticeView:@"请先选择商品"];
        return;
    }
    
    [MessageAlert shareInstance].isDealInBlock = YES;
    [[MessageAlert shareInstance] hiddenCancelBtn:NO];
    if ([button.currentTitle isEqualToString:@"上架"]) {
        [[MessageAlert shareInstance] showCommonAlert:@"确定将您所选的商品上架吗? " btnClick:^{
            [self requestGoodWithType:@"3"];
        }];
        
    }else{
        
        [[MessageAlert shareInstance] showCommonAlert:@"确定将您所选的商品下架吗？" btnClick:^{
            [self requestGoodWithType:@"4"];
        }];
        
    }
    
}
/**点击 上下架 按钮代理方法*/
-(void)requestGoodWithType:(NSString *)typeString{
    NSString *requestUrl = @"";
    if ([typeString isEqualToString:@"4"]) { //获取已上架  需要下架
        requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,pullGoodsOffShelves_Url];
        type = @"1";
    }else{  //已下架  需要上架
        requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,putGoodsOnSale_Url];
        type = @"2";
    }
    
    NSString * idResultStr = nil;
    for (int i=0;i<self.dataSourceArray.count;i++) {
        _goodModel = self.dataSourceArray[i];
        if (_goodModel.isSelect) {
            if (idResultStr == nil) {
                idResultStr = [NSString stringWithFormat:@"%@",_goodModel.ID];
            }else{
                idResultStr = [idResultStr stringByAppendingString:[NSString stringWithFormat:@",%@",_goodModel.ID]];
            }
        }
    }
    if(IsNilOrNull(idResultStr)){
        idResultStr = @"";
    }
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSDictionary *pramaDic = @{@"ids":idResultStr,@"ckid":_ckidstring,DeviceId:uuid};
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        if([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        if([typeString isEqualToString:@"3"]){
            [self showNoticeView:@"商品上架成功!"];
        }else if ([typeString isEqualToString:@"4"]){
            [self showNoticeView:@"商品下架成功!"];
        }
        
        [self getShopManagerDataWithType:type];
        _allSelectedButton.selected = NO;
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}
/**创建 统一 button*/
-(UIButton *)createOrderButtonWithframe:(CGRect)frame andTag:(NSInteger)tag andAction:(SEL)action andNomalImage:(UIImage *)nomalImage{
    UIButton *button  = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:nomalImage forState:UIControlStateNormal];
    button.adjustsImageWhenHighlighted = NO;
    button.frame = frame;
    button.tag = tag;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
