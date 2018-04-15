//
//  CKExamModel.h
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/1/26.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "BaseEncodeModel.h"

//@interface CKOptionContentModel : BaseEncodeModel
//
//
//
//@end

@interface CKOptionModel : BaseEncodeModel

/**选项值(A、B、C..)*/
@property (nonatomic, copy) NSString *selectvalue;
/**选项内容*/
@property (nonatomic, copy) NSString *selectcontent;
/**是否选中*/
@property (nonatomic, assign) BOOL isSelected;


@end

@interface CKQuestionModel : BaseEncodeModel

/**试题id*/
@property (nonatomic, copy) NSString *questionid;
/**试题类型*/
@property (nonatomic, copy) NSString *questiontype;
/**类型名称*/
@property (nonatomic, copy) NSString *questionTypeName;
/**题干*/
@property (nonatomic, copy) NSString *question;
/**选项数量*/
@property (nonatomic, copy) NSString *selectcount;
/**分数*/
@property (nonatomic, copy) NSString *score;
/**选项列表*/
@property (nonatomic, strong) NSMutableArray<CKOptionModel*> *optionArray;

@end

@interface CKExamModel : BaseEncodeModel

/**级别id*/
@property (nonatomic, copy) NSString *levelid;
/**考试的级别*/
@property (nonatomic, copy) NSString *levelno;
/**试卷编号*/
@property (nonatomic, copy) NSString *examid;
/**试卷名称*/
@property (nonatomic, copy) NSString *examname;
/**试卷分数*/
@property (nonatomic, copy) NSString *examscore;
/**及格分数*/
@property (nonatomic, copy) NSString *passscore;
/**考试时长(分钟)*/
@property (nonatomic, copy) NSString *examtime;
/**试题数量*/
@property (nonatomic, copy) NSString *questioncount;
/**试题列表*/
@property (nonatomic, strong) NSMutableArray<CKQuestionModel*> *questionArray;

@end
