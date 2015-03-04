#import "User.h"
#import <SSKeychain.h>
#import <XMPPvCardTemp.h>
#import <JSQMessagesAvatarImageFactory.h>

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
    UIImage *orgImage = [UIImage imageNamed:@"avatar"];
    
//    if let data = XMPPManager.instance.xmppvCardAvatarModule.photoDataForJID(jid) {
//        orgImage = UIImage(data: data)
//    }
//    
//    let image = JSQMessagesAvatarImageFactory.avatarImageWithImage(orgImage, diameter: 75)
//    
//    return image.avatarImage
    
    if (self.avatarData) {
        orgImage = [UIImage imageWithData:self.avatarData];
    }
    
    JSQMessagesAvatarImage *image = [JSQMessagesAvatarImageFactory avatarImageWithImage:orgImage diameter:75];
    
    return image.avatarImage;
}

- (void)updateWithVcard:(XMPPvCardAvatarModule *)card {
    self.displayName = card.xmppvCardTempModule.myvCardTemp.formattedName;
    self.avatarData = card.xmppvCardTempModule.myvCardTemp.photo;
}

@end
