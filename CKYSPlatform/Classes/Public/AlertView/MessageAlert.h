
#import <UIKit/UIKit.h>
//识别链接 电话 邮箱等文字
#import "MLEmojiLabel.h"
typedef void(^SureBtnDidClick)(void);

@interface MessageAlert : UIView<MLEmojiLabelDelegate>

@property(nonatomic,strong)MLEmojiLabel *titleLabel;
@property (nonatomic, strong) UIButton *rightSureBtn;
@property (nonatomic, strong) UIButton *leftCancelBtn;
/**
 *  提供单利初始化方法
 */
+ (instancetype)shareInstance;
/**
 *  是否处理点击事件 处理YES 不处理NO
 */
@property(nonatomic,assign)BOOL isDealInBlock;

@property(nonatomic,copy)NSString *errorCode;
/**
 * 展示
 */
@property(nonatomic,copy)SureBtnDidClick sureBlock;

/**
 * 商品管理  自提 普通界面弹框
 */

- (void)showCommonAlert:(NSString *)title btnClick:(void(^)(void))block;
/**
 * 推送消息展示
 */
- (void)showAlert:(NSString *)title btnClick:(void(^)(void))block;
/**
 * 接口请求 错误 9001 8001 201 非200展示弹框 有的需要处理点击事件 有的不需要
 */
- (void)showRequestErrorCode:(NSString *)code errorContent:(NSString *)title;

- (void)showMsgAlert:(NSString *)title btnClick:(void(^)(void))block;

/**
 如果不想显示取消按钮请调用这个方法
 */
-(void)hiddenCancelBtn:(BOOL)hidden;


@end
