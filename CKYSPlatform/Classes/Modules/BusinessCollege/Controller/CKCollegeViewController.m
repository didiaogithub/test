//
//  CKCollegeViewController.m
//  CKYSPlatform
//
//  Created by 忘仙 on 2017/7/3.
//  Copyright © 2017年 ckys. All rights reserved.
//
//  此类暂时不用

#import "CKCollegeViewController.h"
#import "CKWaterFlowLayout.h"
#import "CKCollegeCell.h"
#import "CKCollegeHeaderView.h"
#import "CKClassSearchViewController.h"
#import "WebDetailViewController.h"

@interface CKCollegeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, CKWaterFlowLayoutDelegate, CKCollegeHeaderViewDelegate>

@property (nonatomic, strong) UICollectionView *collegeCollect;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *heightArray;

@end

@implementation CKCollegeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initComponents];
}

-(void)initComponents {
    
    _heightArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 20; i++) {
        [_heightArray addObject:[NSString stringWithFormat:@"%u", 150+arc4random()%100]]
        ;
    }
    
    
    UILabel *titleLable = [UILabel configureLabelWithTextColor:[UIColor tt_bodyTitleColor] textAlignment:NSTextAlignmentCenter font:NAV_BAR_FONT];
//    [self.navView addSubview:titleLable];
    titleLable.text = @"商学院";
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(30);
        make.left.right.mas_offset(0);
        make.height.mas_offset(20);
    }];
    
    UIButton *searchBtn = [UIButton new];
    [searchBtn setImage:[UIImage imageNamed:@"source_Search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchLesson) forControlEvents:UIControlEventTouchUpInside];
//    [self.navView addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(30);
        make.right.mas_offset(-10);
        make.height.mas_offset(20);
    }];
    
    self.view.backgroundColor = [UIColor tt_grayBgColor];
    //创建瀑布流布局
    CKWaterFlowLayout *layout = [CKWaterFlowLayout waterFlowLayoutWithColumnCount:2];
    //或者一次性设置
    [layout setColumnSpacing:10 rowSpacing:10 sectionInset:UIEdgeInsetsMake(AdaptedHeight(300), 10, 10, 10)];
    //设置代理，实现代理方法
    layout.delegate = self;
    //创建collectionView
    self.collegeCollect = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) collectionViewLayout:layout];
    self.collegeCollect.backgroundColor = [UIColor tt_grayBgColor];
    [self.collegeCollect registerClass:[CKCollegeCell class] forCellWithReuseIdentifier:@"CKCollegeCell"];
    [self.collegeCollect registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerID"];
    [self.collegeCollect registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerID"];
    self.collegeCollect.dataSource = self;
    self.collegeCollect.delegate = self;
    [self.view addSubview:self.collegeCollect];
}

-(void)searchLesson {
    CKClassSearchViewController *searchVC = [[CKClassSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CKCollegeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CKCollegeCell" forIndexPath:indexPath];
    
    return cell;
}

//根据item的宽度与indexPath计算每一个item的高度
- (CGFloat)waterFlowLayout:(CKWaterFlowLayout *)waterFlowLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    
    return [_heightArray[indexPath.row] floatValue];

}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = nil;
    
    if (kind == UICollectionElementKindSectionFooter) {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerID" forIndexPath:indexPath];
        view.backgroundColor = [UIColor redColor];
        
    }else{
        view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerID" forIndexPath:indexPath];
        view.backgroundColor = [UIColor yellowColor];
        
        CKCollegeHeaderView *headerView = [[CKCollegeHeaderView alloc] initWithFrame:view.frame];
        headerView.delegate = self;
        [view addSubview:headerView];
        
    }
    
    return view;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    [self showNoticeView:[NSString stringWithFormat:@"%@", indexPath]];
}

#pragma mark - CKCollegeHeaderViewDelegate
-(void)bannerPushToDetail:(NSInteger)index {

    WebDetailViewController *bannerDetail = [[WebDetailViewController alloc] init];
    bannerDetail.detailUrl = @"http://www.baidu.com";//detailUrl;
    bannerDetail.typeString = @"banner";
    [self.navigationController pushViewController:bannerDetail animated:YES];
}

-(void)turnToDetailClassify:(NSInteger)index {

    if (index == 520) {
    }else if (index == 521){
    }else if (index == 522){
    }else if (index == 523){
        WebDetailViewController *classLive = [[WebDetailViewController alloc] init];
        classLive.typeString = @"classlive";
        classLive.detailUrl = @"http://m.qlchat.com/live/500000051078903.htm"; //_liveUrl;
        [self.navigationController pushViewController:classLive animated:YES];
    }
}

@end
