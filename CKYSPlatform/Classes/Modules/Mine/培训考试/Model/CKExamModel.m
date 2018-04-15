//
//  CKExamModel.m
//  CKYSPlatform
//
//  Created by ForgetFairy on 2018/1/26.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKExamModel.h"

//@implementation CKOptionContentModel
//
//@end

@implementation CKOptionModel

@end

@implementation CKQuestionModel

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"typename"]) {
        _questionTypeName = value;;
    }
    [super setValue:value forKey:key];
}

@end


@implementation CKExamModel

@end
