#import "User.h"
#import <SSKeychain.h>

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

@end
