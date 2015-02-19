#import "FriendRequest.h"

@interface FriendRequest ()

// Private interface goes here.

@end

@implementation FriendRequest

- (void)awakeFromInsert {
    [super awakeFromInsert];
    
    self.createAt = [NSDate date];
}

@end
