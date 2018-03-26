

#import <UIKit/UIKit.h>
#import "ChatViewUtilits.h"

@class BaseUser,ChatAlertInfomationView;


FOUNDATION_EXPORT CGFloat const  ChatDetialUserViewHeight;

FOUNDATION_EXPORT CGFloat const  ChatDetialUserViewWidth;


@protocol ChatAlertInfomationViewDelegate <NSObject>

///关注,私信,管理,关闭
-(void)chatAlertInfomationView:(ChatAlertInfomationView *)chatAlertInfomationView didClickButton:(UIButton *)button withTypeName:(ChatAlertInfomationType)type;
@end


@interface ChatAlertInfomationView : UIView

+ (instancetype)infomationView;
/** 用户信息 */
@property (nonatomic, strong) BaseUser *user;
/**守护的人头像*/
@property (nonatomic, strong) NSArray *shouHu;

@property (nonatomic , weak) id<ChatAlertInfomationViewDelegate> delegate;

@end
