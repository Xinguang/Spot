//
//  Bridging-Header.h
//  spot
//
//  Created by 張志華 on 2015/02/04.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

#ifndef spot_Bridging_Header_h
#define spot_Bridging_Header_h

#import "CoreData+MagicalRecord.h"
#import "APAddressBook-Bridging.h"
#import "SVProgressHUD.h"
#import "Parse.h"
#import "SSKeyChain.h"
#import "DDLog.h"
#import "libWeChatSDK/WXApi.h"
#import "JSQMessages.h"
#import "JSBadgeView.h"

#define HAVE_XMPP_SUBSPEC_BANDWIDTHMONITOR
#define HAVE_XMPP_SUBSPEC_GOOGLESHAREDSTATUS
#define HAVE_XMPP_SUBSPEC_RECONNECT
#define HAVE_XMPP_SUBSPEC_ROSTER
#define HAVE_XMPP_SUBSPEC_SYSTEMINPUTACTIVITYMONITOR
#define HAVE_XMPP_SUBSPEC_XEP_0009
#define HAVE_XMPP_SUBSPEC_XEP_0012
#define HAVE_XMPP_SUBSPEC_XEP_0016
#define HAVE_XMPP_SUBSPEC_XEP_0045
#define HAVE_XMPP_SUBSPEC_XEP_0045
#define HAVE_XMPP_SUBSPEC_XEP_0054
#define HAVE_XMPP_SUBSPEC_XEP_0060
#import "XMPPMessage+XEP_0085.h"
#define HAVE_XMPP_SUBSPEC_XEP_0100
#define HAVE_XMPP_SUBSPEC_XEP_0115
#define HAVE_XMPP_SUBSPEC_XEP_0136
#define HAVE_XMPP_SUBSPEC_XEP_0153
#define HAVE_XMPP_SUBSPEC_XEP_0184
#import "XMPPMessage+XEP_0184.h"
//#define HAVE_XMPP_SUBSPEC_XEP_0191
#define HAVE_XMPP_SUBSPEC_XEP_0199
#define HAVE_XMPP_SUBSPEC_XEP_0199
#define HAVE_XMPP_SUBSPEC_XEP_0202
#import "NSXMLElement+XEP_0203.h"
#define HAVE_XMPP_SUBSPEC_XEP_0224
#import "XMPPFramework.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPSearchModule.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPvCardTemp.h"

#import <GoogleMaps/GoogleMaps.h>


#import "Friend.h"
#import "FriendRequest.h"
#import "SNS.h"
#import "SpotMessage.h"
#import "User.h"

#endif
