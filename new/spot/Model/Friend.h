#import "_Friend.h"
#import <XMPPMessage.h>

@import UIKit;

@interface Friend : _Friend {}

+ (NSInteger)numberOfUnreadMessages;
+ (Friend *)friendOfJid: (NSString *)jidStr;
+ (void)saveUnreadMessage: (XMPPMessage *)message done:(void(^)())done;

@end
