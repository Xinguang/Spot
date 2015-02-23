#import "_User.h"
#import <UIKit/UIKit.h>

@interface User : _User {}

@property (strong, nonatomic) NSString *password;

- (UIImage *)avatarImage;

@end
