#import "Friend.h"

@interface Friend ()

// Private interface goes here.

@end

@implementation Friend

- (void)awakeFromInsert {
    [super awakeFromInsert];
    
    self.createAt = [NSDate date];
}

@end
