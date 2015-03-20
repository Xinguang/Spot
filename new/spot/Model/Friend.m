#import "Friend.h"
#import <CoreData+MagicalRecord.h>

@interface Friend ()

// Private interface goes here.

@end

@implementation Friend

+ (NSInteger)numberOfUnreadMessages {
    return [Friend MR_aggregateOperation:@"sum:" onAttribute:@"unreadMessages" withPredicate:nil].integerValue;
}

+ (Friend *)friendOfJid:(NSString *)jidStr {
    return [Friend MR_findFirstByAttribute:@"jidStr" withValue:jidStr];
}

+ (void)saveUnreadMessage:(XMPPMessage *)message done:(void (^)())done {
    Friend *f = [Friend MR_findFirstByAttribute:@"jidStr" withValue: [[message from] bare]];
    if (f == nil) {
        f = [Friend MR_createEntity];
        f.jidStr = [[message from] bare];
    }
    
    f.unreadMessagesValue += 1;
    [f.managedObjectContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        done();
    }];
}

+ (void)setAllMessageRead:(NSString *)jidStr {
    Friend *friend = [Friend MR_findFirstByAttribute:@"jidStr" withValue:jidStr];
    friend.unreadMessagesValue = 0;
    [friend.managedObjectContext MR_saveToPersistentStoreWithCompletion:nil];
}

@end
