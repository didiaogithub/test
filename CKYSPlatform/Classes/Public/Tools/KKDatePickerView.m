//
//  KKDatePickerView.m
//  PickerView
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "KKDatePickerView.h"

@interface KKDatePickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray *_yearArray;
    NSMutableArray *_mothArray;
    NSMutableArray *_dayArray ;
    UIView *_view;
}

@end

@implementation KKDatePickerView

-(instancetype)initWithFrame:(CGRect)frame{

    if (self=[super initWithFrame:frame]) {
        
        [self initData];
        [self initView];
    }
    return self;

}
//得到年月日这些数组
-(void)initData{
    //当前年月
    NSArray *array = [self getSystemTime];
    self.model = [[KKDatePickerViewModel alloc] init];
    self.model.year = array[0];
    self.model.moth = array[1];
    
    _yearArray = [NSMutableArray array];
    NSString *yearSystem = array[0];
    int yearCount = [yearSystem intValue];
    for (int i = 2015; i<=yearCount; i++) {
        NSString *year = [NSString stringWithFormat:@"%.2d",i];
        [_yearArray addObject:year];
    }
    
    _mothArray = [NSMutableArray array];
    NSString *monthSystem = array[1];
    int monthCount = [monthSystem intValue];
    for (int i = 1; i<=monthCount; i++){
        NSString *month = [NSString stringWithFormat:@"%.2d",i];
        [_mothArray addObject:month];
    }
    NSLog(@"初始化月份数组%@",_mothArray);

}
//初始化pickerview
-(void)initView{
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];

    bankView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-AdaptedWidth(70), AdaptedHeight(180))];
    bankView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    [self addSubview:bankView];
    bankView.backgroundColor = [UIColor whiteColor];
    bankView.layer.cornerRadius = 5;    
    
    //取消按钮
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bankView addSubview:cancelBtn];
    cancelBtn.titleLabel.font = ALL_ALERT_FONT;
    [cancelBtn setTitleColor:SubTitleColor forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(8);
        make.left.mas_offset(20);
        make.height.mas_offset(AdaptedHeight(30));
        make.width.mas_offset(60);
    }];
    [cancelBtn addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
   
    
    //筛选按钮
    UIButton * okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bankView addSubview:okBtn];
    [okBtn setTitleColor:[UIColor tt_redMoneyColor] forState:UIControlStateNormal];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    okBtn.titleLabel.font = ALL_ALERT_FONT;
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(cancelBtn);
        make.right.mas_offset(-AdaptedWidth(20));
    }];
    [okBtn addTarget:self action:@selector(clickSelectedButton) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UILabel *line = [UILabel creatLineLable];
    [bankView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(cancelBtn.mas_bottom).offset(8);
        make.left.right.mas_offset(0);
        make.height.mas_offset(1);
    }];

    
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.backgroundColor = [UIColor clearColor];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [bankView addSubview:self.pickerView];
    [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.left.right.bottom.mas_offset(0);
    }];

    
    NSArray *array = [self getSystemTime];
    NSString  *yearRow = array[0] ;
    int year = [yearRow intValue]-2015;
    
    NSString *mothStr = array[1];
    int moth = [mothStr intValue];
    //  设置默认选中日期,即现在的日期
    [self.pickerView selectRow:year inComponent:0 animated:YES];
    [self.pickerView selectRow:(moth-1) inComponent:1 animated:YES];
    
    [self performSelector:@selector(selectSystemTime)  withObject:nil afterDelay:.1];
    [self clearSeparatorWithView:_pickerView];
    
    //_pickerview的背景色为透明,在选中的那行上面放一层view,然后设置view的背景色
//    UIView * selectViewBac = [[UIView alloc] initWithFrame:CGRectMake(0, 0,_pickerView.frame.size.width, 20)];
//    selectViewBac.backgroundColor = [UIColor colorWithRed:226/255.f green:242/255.f blue:250/255.f alpha:1];
//    selectViewBac.center = self.pickerView.center;
//    
//    [self.pickerView addSubview:selectViewBac];

}
/**点击确定按钮*/
- (void)clickSelectedButton{
    if ([_delegate respondsToSelector:@selector(pickView:month:)]) {
        NSInteger yes = [_pickerView selectedRowInComponent:0];
        NSInteger mom = [_pickerView selectedRowInComponent:1];
        [_delegate pickView:[_yearArray objectAtIndex:yes] month:[_mothArray objectAtIndex:mom]];
        [self removeDatePickView];
    }
}
-(void)selectSystemTime{
    NSArray *array = [self getSystemTime];
    NSString  *yearRow = array[0];
    int year = [yearRow intValue]-2015;
    
    NSString *mothStr = array[1];
    int moth = [mothStr intValue];
    
    //得到选中的那个view,并获取到它上面的label,再改变label的字体颜色
    UIView * yearview =  [_pickerView viewForRow:year forComponent:0];
    UILabel * yearlabel = yearview.subviews.firstObject;
    yearlabel.textAlignment = NSTextAlignmentCenter;
    yearlabel.size = yearview.size;
    yearlabel.font = MAIN_BODYTITLE_FONT;
    yearlabel.textColor = [UIColor tt_redMoneyColor];
  
    
    UIView * mothview =  [_pickerView viewForRow:(moth-1) forComponent:1];
    UILabel * mothlabel = mothview.subviews.firstObject;
    mothlabel.size = mothview.size;
    mothlabel.font = MAIN_BODYTITLE_FONT;
    mothlabel.textAlignment = NSTextAlignmentCenter;
    mothlabel.textColor = [UIColor tt_redMoneyColor];
 

}
#pragma mark pickerviewDelegate
#pragma mark-返回列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
#pragma mark-返回每列行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        return  _yearArray.count;
    } else{
        return  _mothArray.count;
    }
}
//每行高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}
//每个item的宽度
- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if(component==0){
        return  (self.bounds.size.width-50)/3;
    } else{
        return  (self.bounds.size.width-50)/3;
    }

}

//改变选中那行的字体和颜色
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (!view){
        view = [[UIView alloc]init];
    }
    UILabel *textLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, (self.bounds.size.width-50)/3, 30)];
    if (component == 1){
        NSInteger selecrDay  = [_pickerView selectedRowInComponent:component];
        if (selecrDay == row) {
            textLable.textColor = [UIColor tt_redMoneyColor];
            textLable.font = MAIN_BODYTITLE_FONT;
        }
    }
    textLable.textAlignment = NSTextAlignmentCenter;
    if (component==0) {
        textLable.text = [_yearArray objectAtIndex:row];
    }
    if (component==1) {
        textLable.text = [_mothArray objectAtIndex:row];
    }
    [view addSubview:textLable];
    
    return view;
}

//被选择的行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    UIView * yearView =  [_pickerView viewForRow:row forComponent:0];
    UILabel * yearlabel = yearView.subviews.firstObject;
    yearlabel.size = yearView.size;
    yearlabel.textColor = [UIColor tt_redMoneyColor];
    yearlabel.textAlignment = NSTextAlignmentCenter;
    yearlabel.font = MAIN_BODYTITLE_FONT;
    
    
    UIView * monthView =  [_pickerView viewForRow:row forComponent:1];
    UILabel * monthlabel = monthView.subviews.firstObject;
    monthlabel.size = monthView.size;
    monthlabel.textColor = [UIColor tt_redMoneyColor];
    monthlabel.textAlignment = NSTextAlignmentCenter;
    monthlabel.font = MAIN_BODYTITLE_FONT;

    
//    NSLog(@"当前年文字%@ ,当前月文字%@",yearlabel.text,monthlabel.text);
    if(component==0){
        self.model.year = [_yearArray objectAtIndex:row];
        
        //清空上一次月份的那一列留下来的数据
        NSLog(@"过滤数组%@",_mothArray);
        [_mothArray removeAllObjects];
        //需要去掉的元素数组
        NSMutableArray *filteredArray = [[NSMutableArray alloc]initWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08", nil];
        //需要被筛选的数组
        NSMutableArray *dataArray = [[NSMutableArray alloc]initWithObjects:@"09",@"10",@"11",@"12", nil];
        NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",filteredArray];
        //过滤数组
        NSArray * reslutFilteredArray = [dataArray filteredArrayUsingPredicate:filterPredicate];
        NSLog(@"Reslut Filtered Array = %@",reslutFilteredArray);
        NSLog(@"当前年份%@ 当前月份%@",self.model.year,self.model.moth);
        if(row == 0){ //第0列第一行
            _mothArray = [NSMutableArray arrayWithArray:reslutFilteredArray];
        }else if(_yearArray.count == row+1){//最后一行
            NSArray *array = [self getSystemTime];
            NSString *monthSystem = array[1];
            int monthCount = [monthSystem intValue];
            for (int i = 1; i<=monthCount; i++){
                NSString *month = [NSString stringWithFormat:@"%.2d",i];
                [_mothArray addObject:month];
            }
        }else{
            for (int i = 1; i<13; i++) {
                NSString *moth = [NSString stringWithFormat:@"%.2d",i];
                [_mothArray addObject:moth];
            }
        
        }
        //更新第二个滚轮的数据
        [self.pickerView reloadComponent:1];
        
    }
    if(component==1) {
        self.model.moth = [_mothArray objectAtIndex:row];
    }
}
//让分割线背景颜色为透明
- (void)clearSeparatorWithView:(UIView * )view
{
    if(view.subviews != 0  )
    {
        //分割线很薄的😊
        if(view.bounds.size.height < 5)
        {
            view.backgroundColor = [UIColor clearColor];
        }
        
        [view.subviews enumerateObjectsUsingBlock:^( UIView *  obj, NSUInteger idx, BOOL *  stop) {
            [self clearSeparatorWithView:obj];
        }];
    }
    
}
// 获取系统时间
-(NSArray*)getSystemTime{
    
    NSDate *date = [NSDate date];
    NSTimeInterval  sec = [date timeIntervalSinceNow];
    NSDate *currentDate = [[NSDate alloc]initWithTimeIntervalSinceNow:sec];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM"];
    NSString *na = [df stringFromDate:currentDate];
    NSLog(@"时间%@",na);
    return [na componentsSeparatedByString:@"-"];
    
}
/**点击取消按钮*/
- (void)clickCancelButton{
    
    [self removeDatePickView];
}
- (void)removeDatePickView
{
    [self removeFromSuperview];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self removeDatePickView];
}
- (void)show{
    AppDelegate * app = [AppDelegate shareAppDelegate];
    [app.window addSubview:self];
    
}

@end
