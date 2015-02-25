#import "User.h"
#import <SSKeychain.h>
#import <XMPPvCardTemp.h>

@interface User ()

// Private interface goes here.

@end

NSString *kSpotServiceName = @"jp.co.e-bussiness.spot.Spot";

@implementation User

- (NSString *)password {
    return [SSKeychain passwordForService:kSpotServiceName account:self.uniqueIdentifier];
}

- (void)setPassword:(NSString *)password {
    [SSKeychain setPassword:password forService:kSpotServiceName account:self.uniqueIdentifier];
}

- (UIImage *)avatarImage {
    if (self.avatarData) {
        return [UIImage imageWithData:self.avatarData];
    }
    
    return [UIImage imageNamed:@"avatar"];
}

- (void)updateWithVcard:(XMPPvCardAvatarModule *)card {
    self.displayName = card.xmppvCardTempModule.myvCardTemp.formattedName;
    self.avatarData = card.xmppvCardTempModule.myvCardTemp.photo;
}

@end
