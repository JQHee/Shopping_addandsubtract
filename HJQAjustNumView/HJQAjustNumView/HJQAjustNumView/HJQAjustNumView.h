

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, HJQOperationType) {
    inputTextType, // 文本输入
    increaseType,  // 增加
    reduceType     // 减少
};

@interface HJQAjustNumView : UIView

/**
 *  边框颜色，默认值是浅灰色
 */
@property (nonatomic, assign) UIColor *lineColor;

/**
 *  文本框内容
 */
@property (nonatomic, copy) NSString *currentNum;

/**
 *  文本框内容改变后的回调
 */
@property (nonatomic, copy) void (^callBack) (NSString *currentNum, HJQOperationType type);

@end
