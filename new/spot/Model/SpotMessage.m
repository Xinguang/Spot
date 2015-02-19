#import "SpotMessage.h"
#import "Friend.h"
#import "User.h"

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

@end
