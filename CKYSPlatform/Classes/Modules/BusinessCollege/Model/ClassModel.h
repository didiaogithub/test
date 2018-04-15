//
//  ClassModel.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 17/3/19.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <Realm/Realm.h>

@interface lessonType : RLMObject
/**课程id*/
@property NSString *sortID;
/**标题分类名字*/
@property NSString *name;

@end

RLM_ARRAY_TYPE(lessonType)

@interface ClassTitleModel : RLMObject

/**直播url*/
@property NSString *url;

@property RLMArray<lessonType*><lessonType> *lessonTypeArr;

@property NSString *ckid;

@end


@interface ClassModel : RLMObject
/**课程图片Url*/
@property NSString *imgurl;
/**阅读量*/
@property NSString *viewed;
/**课程发布时间*/
@property NSString *time;
/**课程id*/
@property NSString *classId;
/**类型*/
@property NSString *typecode;
/**标题*/
@property NSString *title;
/**分享url*/
@property NSString *urlshare;
/**讲师*/
@property NSString *teacher;
/**详情url*/
@property NSString *url;

@property NSString *sortID;

@end

