//
//  MineTableViewCell.m
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/30.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "MineTableViewCell.h"
#import "SecondCollectionViewCell.h"

static NSString *secondCellIdentifier = @"SecondCollectionViewCell";

@interface MineTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    float cellHeight;
}

@end

@implementation MineTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponent];
    }
    return self;
}

- (void)initComponent {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.mineCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,0) collectionViewLayout:layout];
    [self.contentView addSubview:self.mineCollectionView];
    [self.mineCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];

    self.mineCollectionView.showsVerticalScrollIndicator = NO;
    self.mineCollectionView.showsHorizontalScrollIndicator = NO;
    self.mineCollectionView.backgroundColor = [UIColor whiteColor];
    [self.mineCollectionView registerClass:[SecondCollectionViewCell class] forCellWithReuseIdentifier:secondCellIdentifier];
    //4.设置代理
    self.mineCollectionView.delegate = self;
    self.mineCollectionView.dataSource = self;
}

#pragma mark-刷新布局
-(void)cellrefreshWithArray:(NSArray *)imageArr andTitleArr:(NSArray *)titleArr{
    self.iconArray = imageArr;
    self.titleArray = titleArr;
    
    if (iphone5){
        cellHeight = AdaptedHeight(70);
    }else{
        cellHeight = AdaptedHeight(78);
    }
    

    [self.mineCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(cellHeight*(self.titleArray.count/4+1));
    }];
    
//    if([self.typeString isEqualToString:@"B"]){ //创客
//        if(![self.tgidString isEqualToString:@"0"]){
//        //推广人
//            [self.mineCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.mas_offset(cellHeight*2);
//            }];
//        }else{
//
//            [self.mineCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.mas_offset(cellHeight*4);
//            }];
//        }
//    }else if([self.typeString isEqualToString:@"D"]){//分销
//        [self.mineCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_offset(cellHeight * 4);
//        }];
//    }else{
//        [self.mineCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_offset(cellHeight * 4);
//        }];
//    }
    [self.mineCollectionView reloadData];
}

#pragma mark collectionView代理方法
/**每个section的item个数*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.iconArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SecondCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:secondCellIdentifier forIndexPath:indexPath];
    if([self.iconArray count] && [self.titleArray count]){
        [cell refreshWithCell:self.iconArray andTitleArr:self.titleArray andIndex:indexPath.row];
    }
    return cell;
}

/**设置每个item的尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (iphone5){
        cellHeight = AdaptedHeight(70);
    }else{
       cellHeight = AdaptedHeight(78);
    }
    return CGSizeMake((SCREEN_WIDTH-16)/4,cellHeight);
}
/**设置每个item的UIEdgeInsets*/
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
/**设置每个item水平间距*/
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - 点击collectioncell查看相应function
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedItemWithName:)]) {
        NSString *itemName = self.titleArray[indexPath.row];
        [self.delegate didSelectedItemWithName:itemName];
    }
}

@end
