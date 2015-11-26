

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    DORBubbleTipDirectionDown = 0,
    DORBubbleTipDirectionUp
} DORBubbleTipDirection;

@interface DORBubbleView : UIView

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) CGPoint tipPoint;
@property (nonatomic, assign) DORBubbleTipDirection tipDirection;
@property (nonatomic, strong) UIView *customView;

+ (instancetype)viewWithText:(NSString *)text center:(CGPoint)center;
+ (instancetype)viewWithText:(NSString *)text tipPoint:(CGPoint)point tipDirection:(DORBubbleTipDirection)direction;

- (instancetype)popIn;
- (instancetype)popOut;
- (instancetype)popOutAfterDelay:(NSTimeInterval)delay;

@end
