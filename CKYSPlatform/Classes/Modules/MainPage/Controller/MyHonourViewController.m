//
//  MyHonourViewController.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/28.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "MyHonourViewController.h"
#import "MyHonourCollectionViewCell.h"
#import "WebDetailViewController.h"

#define  CellWidth (SCREEN_WIDTH-70)/3

static NSString *honourcellIdentifier = @"MyHonourCollectionViewCell";

@interface MyHonourViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *honourCollectionView;
@property (nonatomic, strong) NSMutableArray *honourArray;

@end

@implementation MyHonourViewController

-(NSMutableArray *)honourArray{
    if (_honourArray == nil) {
        _honourArray = [NSMutableArray array];
    }
    return _honourArray;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"荣誉资质";
    [self gethonourAndData];
    [self createCollectionView];
}

#pragma mark - 请求荣誉资质数据
-(void)gethonourAndData{
    NSString *gethonourAndCertUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getAppHonorArr_Url];
    
    NSString *uuid = DeviceId_UUID_Value;
    if (IsNilOrNull(uuid)){
        uuid = @"";
    }
    NSDictionary *pramaDic = @{DeviceId:uuid,@"ver":@"301"};
    [[UIApplication sharedApplication].keyWindow addSubview:self.viewDataLoading];
    [self.viewDataLoading startAnimation];
    [HttpTool postWithUrl:gethonourAndCertUrl params:pramaDic success:^(id json) {
        [self.viewDataLoading stopAnimation];
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        NSArray *honour = dict[@"honors"];
        for (NSDictionary *honourdict in honour) {
            NSString *path = honourdict[@"path"];
            [self.honourArray addObject:path];
        }
        [self.honourCollectionView reloadData];
    } failure:^(NSError *error) {
        [self.viewDataLoading stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

-(void)createCollectionView{
    
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //该方法也可以设置itemSize
    layout.itemSize =CGSizeMake(CellWidth, CellWidth+17);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    
    //2.初始化collectionView
    self.honourCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:self.honourCollectionView];
    [self.honourCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)){
            make.top.mas_offset(65+NaviAddHeight);
        }else{
            make.top.mas_offset(0);
        }
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(-BOTTOM_BAR_HEIGHT);
    }];
    self.honourCollectionView.showsVerticalScrollIndicator = NO;
    self.honourCollectionView.showsHorizontalScrollIndicator = NO;
    self.honourCollectionView.backgroundColor = [UIColor whiteColor];
    self.honourCollectionView.hidden = NO;
    
    [self.honourCollectionView registerClass:[MyHonourCollectionViewCell class] forCellWithReuseIdentifier:honourcellIdentifier];
    //4.设置代理
    self.honourCollectionView.delegate = self;
    self.honourCollectionView.dataSource = self;
}

#pragma mark UICollectionView代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.honourArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MyHonourCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:honourcellIdentifier forIndexPath:indexPath];
    [cell refreshWithArray:self.honourArray anTag:indexPath.row];
   
    return cell;
}
/**设置每个item的尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CellWidth,CellWidth+17);
}
/**设置每个item的UIEdgeInsets*/
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
/**设置每个item水平间距*/
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

#pragma mark-点击collectioncell放大查看图片
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //查看我的荣誉
   [[XLImageViewer shareInstanse] showNetImages:self.honourArray index:indexPath.row from:self.honourCollectionView];
  
}

@end
