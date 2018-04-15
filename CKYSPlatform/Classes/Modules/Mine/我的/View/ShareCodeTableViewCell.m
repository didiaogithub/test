//
//  ShareCodeTableViewCell.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/30.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "ShareCodeTableViewCell.h"
#import "FirstCollectionViewCell.h"

static NSString *shareCellIdentifier = @"FirstCollectionViewCell";
@implementation ShareCodeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createTableView];
    }
    return self;
}
-(void)createTableView{
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    //2.初始化collectionView
    self.mineCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,0) collectionViewLayout:layout];
    [self.contentView addSubview:self.mineCollectionView];
    [self.mineCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
        make.height.mas_offset(AdaptedHeight(60));
    }];
    self.mineCollectionView.showsVerticalScrollIndicator = NO;
    self.mineCollectionView.showsHorizontalScrollIndicator = NO;
    self.mineCollectionView.backgroundColor = [UIColor whiteColor];
    
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [self.mineCollectionView registerClass:[FirstCollectionViewCell class] forCellWithReuseIdentifier:shareCellIdentifier];
    //4.设置代理
    self.mineCollectionView.delegate = self;
    self.mineCollectionView.dataSource = self;
    
}
-(void)cellrefreshWithArray:(NSArray *)imageArr andTitleArr:(NSArray *)titleArr{
    self.iconArray = imageArr;
    self.tgTitleArray = titleArr;
    [self.mineCollectionView reloadData];
}
#pragma mark collectionView代理方法
/**每个section的item个数*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([self.typeString isEqualToString:@"D"]){
         return 3;
    }else{
        return 4;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FirstCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:shareCellIdentifier forIndexPath:indexPath];
    if([self.iconArray count] && [self.tgTitleArray count]){
     [cell refreshWithCell:self.iconArray andTitleArr:self.tgTitleArray  andIndex:indexPath.item];
    }
    return cell;
    
}
/**设置每个item的尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.typeString isEqualToString:@"D"]){
       return CGSizeMake(SCREEN_WIDTH/3,70);
    }else{
      return CGSizeMake(SCREEN_WIDTH/4,70);
    }
}
/**设置每个item的UIEdgeInsets*/
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
/**设置每个item水平间距*/
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
#pragma mark-点击collectioncell放大查看图片
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(clickShareCodeWithIndex:)]) {
//        [self.delegate clickShareCodeWithIndex:indexPath.item];
//    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(extendCell:didSelectItem:)]) {
        [self.delegate extendCell:self didSelectItem:self.tgTitleArray[indexPath.row]];
    }
}

@end
