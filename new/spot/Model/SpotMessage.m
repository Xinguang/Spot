#import "SpotMessage.h"
#import "Friend.h"
#import "User.h"
#import <CoreData+MagicalRecord.h>

@interface SpotMessage () <JSQMessageData>

// Private interface goes here.

@end

@implementation SpotMessage

- (void)awakeFromInsert {
    [super awakeFromInsert];
    
    self.createAt = [NSDate date];
    self.messageId = [[NSUUID UUID] UUIDString];
    self.deliveredValue = NO;
    self.readValue = NO;
}

- (NSString *)senderId {
    if (self.incomingValue) {
        return self.friend.accountName;
    } else {
        return self.friend.user.username;
    }
}

- (NSString *)senderDisplayName {
    return @"test";
}

- (NSDate *)date {
    return self.createAt;
}


- (BOOL)isMediaMessage {
    return NO;
}

+ (NSInteger)numberOfUnreadMessages {
    return [self MR_countOfEntitiesWithPredicate:[NSPredicate predicateWithFormat:@"read==NO"]];
}

+ (void)showLocalNotificationForMessage:(SpotMessage *)message {
    if (![[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
//        dispatch_async(dispatch_get_main_queue(), ^{
        Friend *friend = message.friend;
        
        NSString *name = friend.accountName;
        if ([friend.displayName length]) {
            name = friend.displayName;
        }
        
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.alertAction = @"Reply";
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.applicationIconBadgeNumber = [self numberOfUnreadMessages];
        localNotification.alertBody = [NSString stringWithFormat:@"%@: %@",name,message.text];
        
        localNotification.userInfo = @{@"kNotificationFriendAccountName":friend.accountName};
        
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
//        });
    }
}

@end
