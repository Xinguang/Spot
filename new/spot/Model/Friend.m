#import "Friend.h"
#import "SpotMessage.h"
#import <CoreData+MagicalRecord.h>

@interface Friend ()

// Private interface goes here.

@end

@implementation Friend

- (void)awakeFromInsert {
    [super awakeFromInsert];
    
    self.createAt = [NSDate date];
}

- (void)setAllMessagesRead {
    for (SpotMessage *m in self.messagesSet) {
        m.readValue = YES;
    }
    
    [self.managedObjectContext MR_saveToPersistentStoreWithCompletion:nil];
}

@end
