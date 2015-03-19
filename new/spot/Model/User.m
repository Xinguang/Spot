#import "User.h"
#import <SSKeychain.h>
#import <XMPPvCardTemp.h>
#import <JSQMessagesAvatarImageFactory.h>
#import "SNS.h"

@interface User ()

// Private interface goes here.

@end

NSString *kSpotServiceName = @"jp.co.e-bussiness.spot.Spot";

@implementation User

- (NSString *)password {
    return [SSKeychain passwordForService:kSpotServiceName account:self.openfireId];
}

- (void)setPassword:(NSString *)password {
    [SSKeychain setPassword:password forService:kSpotServiceName account:self.openfireId];
}

- (UIImage *)avatarImage {
    UIImage *orgImage;
    
    if (self.avatarThumbnail) {
        orgImage = [UIImage imageWithData:self.avatarThumbnail];
    } else {
        orgImage = [UIImage imageNamed:@"avatar"];
    }
    
    JSQMessagesAvatarImage *image = [JSQMessagesAvatarImageFactory avatarImageWithImage:orgImage diameter:75];
    
    return image.avatarImage;
}

- (NSString *)genderStr {
    if ([self.gender isEqualToString:@"M"]) {
        return @"男性";
    }
    
    return @"女性";
}

- (UIImage *)defaultSNSImage {
    NSString *name = @"avatar";
    
    SNS *sns = self.snses.firstObject;
    if (sns) {
        name = [sns.type isEqualToString:@"qq"] ? @"icon_qq" : @"wechat_icon";
    }
    
    return [UIImage imageNamed:@"name"];
}

@end
