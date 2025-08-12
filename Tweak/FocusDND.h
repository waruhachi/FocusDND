#import <UIKit/UIKit.h>

typedef struct CCUILayoutSize {
	NSUInteger width;
	NSUInteger height;
} CCUILayoutSize;

static CCUILayoutSize const defaultLayoutSize = {1, 1};

static NSString *const focusModuleIdentifier = @"com.apple.FocusUIModule";
static NSString *const focusModuleBundlePath = @"/System/Library/ControlCenter/Bundles/FocusUIModule.bundle";

@interface UIView ()
- (id)_viewControllerForAncestor;
@end

@interface CCUIRoundButton : UIControl
@property (retain, nonatomic) UIView *normalStateBackgroundView;
@end

@interface CCUILabeledRoundButton : UIView
@property (retain, nonatomic) CCUIRoundButton *buttonView;
@end

@interface CCUIModuleSettings : NSObject
- (id)initWithPortraitLayoutSize:(CCUILayoutSize)portraitSize landscapeLayoutSize:(CCUILayoutSize)landscapeSize;
@end