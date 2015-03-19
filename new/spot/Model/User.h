#import "_User.h"
#import <UIKit/UIKit.h>
#import <XMPPvCardAvatarModule.h>

@interface User : _User {}

@property (strong, nonatomic) NSString *password;

- (UIImage *)avatarImage;

- (NSString *)genderStr;

- (UIImage *)defaultSNSImage;

@end
