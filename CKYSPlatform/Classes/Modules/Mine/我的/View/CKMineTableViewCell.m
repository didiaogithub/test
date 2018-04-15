//
//  CKMineTableViewCell.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/3/17.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKMineTableViewCell.h"
#import "FirstCollectionViewCell.h"
#import "SecondCollectionViewCell.h"
#import "CKLeaderInfoModel.h"
@implementation CKMineTableViewCell

-(void)fillData:(id)data {
    
}

-(void)callWithParameter:(id)parameter {
    
}

+(CGFloat)computeHeight:(id)data {
    return 0;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


@implementation CKMyGovernorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    // 我的管理员
    self.myGovernorView = [[UIView alloc]init];
    [self addSubview:self.myGovernorView];
    self.myGovernorView.backgroundColor = [UIColor redColor];
    [self.myGovernorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.height.equalTo(self);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    UIImageView *myGogvernorImageView = [UIImageView new];
    myGogvernorImageView.image = [UIImage imageNamed:@"管理员背景"];
    [self.myGovernorView addSubview:myGogvernorImageView];
    [myGogvernorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.myGovernorView);
    }];
    
    UIView *contentView = [UIView new];
    contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(AdaptedWidth(0));
        make.top.equalTo(self.myGovernorView);
        make.height.mas_offset(AdaptedHeight(40));
    }];
    
    UIImageView *myIconImageView = [UIImageView new];
    myIconImageView.image = [UIImage imageNamed:@"头像"];
    [contentView addSubview:myIconImageView];
    [myIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(AdaptedWidth(10));
        make.width.mas_offset(AdaptedWidth(15));
        make.height.mas_offset(AdaptedWidth(15));
        make.centerY.equalTo(contentView);
    }];
    
    nameLable = [UILabel configureLabelWithTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    [contentView addSubview:nameLable];
    [nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(myIconImageView.mas_right).
        mas_offset(AdaptedWidth(2));
        make.centerY.equalTo(contentView);
        make.height.mas_offset(AdaptedHeight(15));
    }];
    
    phoneLable = [UILabel configureLabelWithTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    [contentView addSubview:phoneLable];
    [phoneLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).mas_offset(AdaptedWidth(-10));
        make.centerY.equalTo(contentView);
        make.height.mas_offset(AdaptedHeight(15));
    }];
    
    contentLable = [UILabel configureLabelWithTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [self.myGovernorView addSubview:contentLable];
    contentLable.numberOfLines = 0;
    [contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.myGovernorView).mas_offset(AdaptedWidth(-10));
        make.left.equalTo(self.myGovernorView).mas_offset(AdaptedWidth(10));
        make.top.equalTo(phoneLable.mas_bottom).mas_offset(AdaptedWidth(10));
    }];
    
}

- (void)fillData:(id)data{
    CKLeaderInfoModel *model = data;
    if (IsNilOrNull(model.mobile)) {
        model.mobile = @"";
    }
    
    if (IsNilOrNull(model.title)) {
        model.title = @"";
    }
    
    if (IsNilOrNull(model.name)) {
        model.name = @"";
    }
    
    if (IsNilOrNull(model.text1)) {
        model.text1 = @"";
    }
    if (IsNilOrNull(model.label1)) {
        model.label1 = @"";
    }
    if (IsNilOrNull(model.text2)) {
        model.text2 = @"";
    }
    if (IsNilOrNull(model.label2)) {
        model.label2 = @"";
    }
    phoneLable.text = [NSString stringWithFormat:@"%@",model.mobile];
    nameLable.text =  [NSString stringWithFormat:@"%@ %@",model.title,model.name];
    contentLable.text = [NSString stringWithFormat:@"%@ %@                      %@ %@",model.label1,model.text1,model.label2,model.text2];
    
    
}

+ (CGFloat)computeHeight:(id)data{
    CKLeaderInfoModel *model = data;
    if (IsNilOrNull(model.text1)) {
        model.text1 = @"";
    }
    if (IsNilOrNull(model.label1)) {
        model.label1 = @"";
    }
    if (IsNilOrNull(model.text2)) {
        model.text2 = @"";
    }
    if (IsNilOrNull(model.label2)) {
        model.label2 = @"";
    }
    
        
    NSString *string = [NSString stringWithFormat:@"%@ %@                                            %@ %@",model.label1,model.text1,model.label2,model.text2];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 6;
    NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paraStyle};
    CGSize size = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    if (![model.label1 isEqualToString:@""] && ![model.label2 isEqualToString:@""]) {
        return  AdaptedHeight(size.height + 40);
    }else{
       return AdaptedHeight(40);
    }
    
}
@end

@implementation CKNewerDLBTestCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.backgroundColor = [UIColor tt_grayBgColor];
    self.rmksImageView = [UIImageView new];
    self.rmksImageView.userInteractionEnabled = YES;
    self.rmksImageView.image = [UIImage imageNamed:@"入门考试"];
    [self.contentView addSubview:self.rmksImageView];
    [self.rmksImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beginTest)];
    [self.rmksImageView addGestureRecognizer:tap];
}

- (void)beginTest {
    if (self.delegate && [self.delegate respondsToSelector:@selector(beginDLBTest:)]) {
        [self.delegate beginDLBTest:self];
    }
}

@end



@implementation CKMineSPCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.backgroundColor = [UIColor tt_grayBgColor];
    self.spImageView = [UIImageView new];
    self.spImageView.userInteractionEnabled = YES;
    self.spImageView.image = [UIImage imageNamed:@"应聘员工"];
    [self.contentView addSubview:self.spImageView];
    [self.spImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(applySP)];
    [self.spImageView addGestureRecognizer:tap];
}

- (void)applySP {
    if (self.delegate && [self.delegate respondsToSelector:@selector(applyServiceProvider:)]) {
        [self.delegate applyServiceProvider:self];
    }
}

@end


@implementation CKSchemeToolTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createTableView];
    }
    return self;
}

- (void)createTableView {

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
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
    [self.mineCollectionView registerClass:[FirstCollectionViewCell class] forCellWithReuseIdentifier:@"FirstCollectionViewCell"];
    self.mineCollectionView.delegate = self;
    self.mineCollectionView.dataSource = self;
    
}

- (void)fillData:(id)data {
    
    NSArray *titleArray = data[@"titleArr"];
    NSArray *imageArr = data[@"imgArr"];
    self.iconArray = imageArr;
    self.tgTitleArray = titleArray;
    
    [self.mineCollectionView reloadData];
}

+(CGFloat)computeHeight:(id)data {
    CGFloat cellHeight = AdaptedHeight(78);
    if (iphone5){
        cellHeight = AdaptedHeight(70);
    }
    return cellHeight;
}

#pragma mark collectionView代理方法
/**每个section的item个数*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    self.typeString =  [KUserdefaults objectForKey:Ktype];
    if ([self.typeString isEqualToString:@"D"]){
        return 3;
    }else{
        return 4;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FirstCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FirstCollectionViewCell" forIndexPath:indexPath];
    if([self.iconArray count] && [self.tgTitleArray count]){
        [cell refreshWithCell:self.iconArray andTitleArr:self.tgTitleArray  andIndex:indexPath.item];
    }
    return cell;
}

/**设置每个item的尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (self.delegate && [self.delegate respondsToSelector:@selector(extendCell:didSelectItem:)]) {
        [self.delegate extendCell:self didSelectItem:self.tgTitleArray[indexPath.row]];
    }
}

@end


@interface CKUsefulToolTableViewCell()
{
    float cellHeight;
}

@end

@implementation CKUsefulToolTableViewCell

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
    self.mineCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
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
    [self.mineCollectionView registerClass:[SecondCollectionViewCell class] forCellWithReuseIdentifier:@"SecondCollectionViewCell"];
    //4.设置代理
    self.mineCollectionView.delegate = self;
    self.mineCollectionView.dataSource = self;
}

- (void)fillData:(id)data {
    NSArray *titleArray = data[@"titleArr"];
    NSArray *imageArr = data[@"imgArr"];
    self.iconArray = imageArr;
    self.titleArray = titleArray;
    [self.mineCollectionView reloadData];
}

+(CGFloat)computeHeight:(id)data {
    NSArray *titleArray = data;
    CGFloat cellHeight = AdaptedHeight(78);
    if (iphone5){
        cellHeight = AdaptedHeight(70);
    }
    return cellHeight*(titleArray.count/4+1);
}

#pragma mark collectionView代理方法
/**每个section的item个数*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.iconArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SecondCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SecondCollectionViewCell" forIndexPath:indexPath];
    if([self.iconArray count] && [self.titleArray count]){
        [cell refreshWithCell:self.iconArray andTitleArr:self.titleArray andIndex:indexPath.row];
    }
    return cell;
}

/**设置每个item的尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight = AdaptedHeight(78);
    if (iphone5){
        cellHeight = AdaptedHeight(70);
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedItem:itemName:)]) {
        NSString *itemName = self.titleArray[indexPath.row];
        [self.delegate didSelectedItem:self itemName:itemName];
    }
}

@end
