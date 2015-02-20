#import "_SpotMessage.h"
#import <JSQMessageData.h>

@interface SpotMessage : _SpotMessage <JSQMessageData> {}

+ (void)showLocalNotificationForMessage:(SpotMessage *)message;
+ (NSInteger) numberOfUnreadMessages;

@end
