#import <UIKit/UIKit.h>

@interface LambdaSheet : NSObject {}

- (id) initWithTitle: (NSString*) title;

- (void) addButtonWithTitle: (NSString*) title block: (dispatch_block_t) block;
- (void) addDestructiveButtonWithTitle: (NSString*) title block: (dispatch_block_t) block;
- (void) addCancelButtonWithTitle: (NSString*) title block: (dispatch_block_t) block;
- (void) addCancelButtonWithTitle: (NSString*) title;

- (void) showFromTabBar: (UITabBar*) view;
- (void) showFromToolbar: (UIToolbar*) view;
- (void) showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated; 
- (void) showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated;
- (void) showInView: (UIView*) view;

@end
