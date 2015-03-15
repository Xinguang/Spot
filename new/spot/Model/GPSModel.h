//
//  GPSModel.h
//  spot
//
//  Created by 張志華 on 2015/03/02.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>

@protocol PositionModel
@end

@interface PositionModel : JSONModel

@property(nonatomic) double lat;
@property(nonatomic) double lon;
@property(nonatomic) NSInteger userCount;

@end

@implementation PositionModel
@end

@interface GPSModel : JSONModel

@property (strong, nonatomic) NSArray<PositionModel>* positions;

@end





